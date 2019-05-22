//
//  RepositoryOwnerObject.h
//  GitInfo
//
//  Created by Eugen Lipatov on 5/21/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RepositoryOwnerObject : NSObject

@property (copy, nonatomic) NSString *login;

@property (strong, nonatomic) NSURL *repoAvatarvatarUrl;

@property (strong, nonatomic) NSNumber *Id;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;


@end

