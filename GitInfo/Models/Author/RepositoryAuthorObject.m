//
//  RepositoryAuthorObject.m
//  GitInfo
//
//  Created by Eugen Lipatov on 5/21/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

#import "RepositoryAuthorObject.h"

@implementation RepositoryAuthorObject


- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if (self)
    {
        self.avatarUrl = [NSURL URLWithString:[[dictionary valueForKey:@"author"] valueForKey:@"avatar_url"]];
        self.name = [[[dictionary valueForKey:@"commit"] valueForKey:@"author"] valueForKey:@"name"];
        self.commitName = [[dictionary valueForKey:@"commit"] valueForKey:@"message"];
        self.commitHash = [dictionary valueForKey:@"sha"];    }
    
    return self;
}
@end
