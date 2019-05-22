//
//  GeneralTableViewCell.h
//  GitInfo
//
//  Created by Eugen Lipatov on 5/21/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GeneralTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *repoImageView;

@property (weak, nonatomic) IBOutlet UILabel *repoitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *repoDevLabel;

@property (weak, nonatomic) IBOutlet UILabel *repoDescriptionLabel;

@end



