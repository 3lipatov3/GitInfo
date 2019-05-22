//
//  RepoDetailVC.m
//  GitInfo
//
//  Created by Eugen Lipatov on 5/21/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

#import "RepoDetailVC.h"
#import "NetworkManager.h"
#import "RepositoryAuthorObject.h"
#import <SDWebImage/SDWebImage.h>

@interface RepoDetailVC ()

@property (weak, nonatomic) IBOutlet UIImageView *authorAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *branchNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commitNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commitHashLabel;

@property (retain, nonatomic) NetworkManager *networkManager;
@property (retain, nonatomic) RepositoryAuthorObject *authorItem;

@end

@implementation RepoDetailVC
- (NetworkManager*)networkManager {
    if (_networkManager != nil) {
        return _networkManager;
    }
    _networkManager = [NetworkManager new];
    
    return _networkManager;
}


// MARK: - Life Cirlce
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    
}
- (void)loadData {
    [self.networkManager loadCommits:self.repositoryObject completion:^(BOOL success, NSString *errorString, RepositoryAuthorObject *responce) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success == true) {
                self.authorItem = responce;
                [self updateUI];
            } else {
                [self showLoadDataAlert:errorString];
            }
        });
    }];
}



- (void)updateUI {
    
    self.authorNameLabel.text = self.authorItem.name;
    
    self.commitNameLabel.text = [NSString stringWithFormat:@"Description: \n%@", self.authorItem.commitName];
    
    self.commitHashLabel.text = [NSString stringWithFormat:@"SHA: \n%@", self.authorItem.commitHash];
    
    self.branchNameLabel.text = [NSString stringWithFormat:@"Branch: %@", self.repositoryObject.defaultBranch];
  
    [self.authorAvatarImageView sd_setImageWithURL:self.authorItem.avatarUrl
                          placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
  
}


- (void)showLoadDataAlert:(NSString*)message {
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Sprry Error"
                                                                       message:message
                                                                preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Ok"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    UIAlertAction* retryAction = [UIAlertAction actionWithTitle:@"Retry"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {
                                                            [self loadData];
                                                        }];
    
    [alertView addAction:defaultAction];
    [alertView addAction:retryAction];
    [self presentViewController:alertView animated:true completion:nil];
}


@end
