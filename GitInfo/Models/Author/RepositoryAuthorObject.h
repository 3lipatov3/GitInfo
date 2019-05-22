//
//  RepositoryAuthorObject.h
//  GitInfo
//
//  Created by Eugen Lipatov on 5/21/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RepositoryAuthorObject : NSObject

@property (strong, nonatomic) NSURL *avatarUrl;

@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *commitName;

@property (copy, nonatomic) NSString *commitHash;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;

@end

NS_ASSUME_NONNULL_END
