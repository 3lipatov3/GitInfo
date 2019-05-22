//
//  RepositoryObject.h
//  GitInfo
//
//  Created by Eugen Lipatov on 5/21/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RepositoryOwnerObject.h"

@interface RepositoryObject : NSObject


@property (retain, nonatomic) RepositoryOwnerObject *owner;

@property (copy, nonatomic) NSString *url;

@property (strong, nonatomic) NSNumber *Id;

@property (copy, nonatomic) NSString *descr;

@property (copy, nonatomic) NSString *title;

@property (copy, nonatomic) NSString *fullName;

@property (copy, nonatomic) NSString *defaultBranch;



- (instancetype)initWithDictionary:(NSDictionary*)dictionary;

@end


