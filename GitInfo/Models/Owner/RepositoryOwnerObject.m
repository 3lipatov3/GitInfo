//
//  RepositoryOwnerObject.m
//  GitInfo
//
//  Created by Eugen Lipatov on 5/21/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

#import "RepositoryOwnerObject.h"

@implementation RepositoryOwnerObject


- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if (self)
    {
        self.login = [dictionary valueForKey:@"login"];
        self.repoAvatarvatarUrl = [NSURL URLWithString:[dictionary valueForKey:@"avatar_url"]];
        self.Id = @([[dictionary valueForKey:@"id"] intValue]);
    }
    return self;
}

@end
