//
//  RepositoryObject.m
//  GitInfo
//
//  Created by Eugen Lipatov on 5/21/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

#import "RepositoryObject.h"

@implementation RepositoryObject

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if (self) {
        self.owner = [[RepositoryOwnerObject alloc] initWithDictionary:[dictionary valueForKey:@"owner"]];
        self.Id = @([[dictionary valueForKey:@"id"] intValue]);
        self.descr = ([dictionary valueForKey:@"description"] != nil && [[dictionary valueForKey:@"description"] length] > 0 ? [dictionary valueForKey:@"description"] : @"Description is empty");
        self.title = [dictionary valueForKey:@"name"];
        self.fullName = [dictionary valueForKey:@"full_name"];
        self.defaultBranch = [dictionary valueForKey:@"default_branch"];
        self.url = [dictionary valueForKey:@"url"];
    }
    
    return self;
}
@end
