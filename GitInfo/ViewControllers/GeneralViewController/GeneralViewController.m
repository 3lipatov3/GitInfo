//
//  GeneralViewController.m
//  GitInfo
//
//  Created by Eugen Lipatov on 5/21/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

#import "GeneralViewController.h"
#import "RepositoryObject.h"
#import "GeneralTableViewCell.h"
#import "NetworkManager.h"
#import "RepoDetailVC.h"
#import <SDWebImage/SDWebImage.h>

@interface GeneralViewController ()

@property (retain, nonatomic) NetworkManager *networkManager;


@property (strong, nonatomic) NSMutableArray <RepositoryObject*> *dataSource;

@end

@implementation GeneralViewController

- (NetworkManager*)networkManager {
    if (_networkManager != nil) {
        return _networkManager;
    }
    _networkManager = [NetworkManager new];
    
    return _networkManager;
}



- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    if (self.refreshControl == nil) {
        self.refreshControl = [[UIRefreshControl alloc] init];
        
        [self.refreshControl addTarget:self action:@selector(refreshContent) forControlEvents:UIControlEventValueChanged];
        
        if (@available(iOS 11.0, *)) {
            self.tableView.refreshControl = self.refreshControl;
        }
        else {
            [self.tableView addSubview:self.refreshControl];
        }
    }
    
    self.dataSource = [NSMutableArray new];
    [self.tableView.refreshControl beginRefreshing];
    [self refreshContent];
}

//MARK: - TableView delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (GeneralTableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GeneralTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"GeneralTableViewCell" forIndexPath:indexPath];
    
    RepositoryObject *item = self.dataSource[indexPath.row];
    
    cell.repoitleLabel.text = item.title;
    
    cell.repoDescriptionLabel.text = item.descr;
    
    cell.repoDevLabel.text = item.owner.login;
    
    [cell.repoImageView sd_setImageWithURL:item.owner.repoAvatarvatarUrl
                     placeholderImage:[UIImage imageNamed:@"placeholder"]];
 
    
    return cell;
    }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    [self performSegueWithIdentifier:@"ShowDetailSegue" sender:indexPath];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.networkManager.isLoading == false && self.networkManager.allDataLoaded == false) {
        if (((indexPath.section+1)*indexPath.row) + self.networkManager.itemsPerPage >= self.dataSource.count - 1) {
            [self loadData];
        }
    }
}

//MARK: - Network
- (void)loadData {
    [self.networkManager loadRepositories:^(BOOL success, NSString *errorString, NSArray<RepositoryObject *> *results) {
        if (success == true) {
            
            [self.dataSource addObjectsFromArray:results];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView.refreshControl endRefreshing];
                
                [self.tableView reloadData];
                
            });
        } else {
            if (errorString != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                       message:errorString
                                                                                preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Ok"
                                                                            style:UIAlertActionStyleDefault
                                                                          handler:^(UIAlertAction * action) {}];
                    
                    [alertView addAction:defaultAction];
                    
                    [self.tableView.refreshControl endRefreshing];
                    [self presentViewController:alertView animated:true completion:nil];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView.refreshControl endRefreshing];
                });
            }
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowDetailSegue"]) {
        RepoDetailVC *detailVC = segue.destinationViewController;
        detailVC.repositoryObject = self.dataSource[[(NSIndexPath*)sender row]];
    }
}

- (void)refreshContent {

    [self.dataSource removeAllObjects];
    [self.tableView reloadData];
    [self.networkManager refresh];
    [self loadData];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
