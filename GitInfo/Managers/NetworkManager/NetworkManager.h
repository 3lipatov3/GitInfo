//
//  NetworkManager.h
//  GitInfo
//
//  Created by Eugen Lipatov on 5/21/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RepositoryObject.h"
#import "RepositoryAuthorObject.h"


@interface NetworkManager : NSObject


@property (readonly) int itemsPerPage;
@property (assign) BOOL isLoading;
@property (assign) BOOL allDataLoaded;

- (void)loadRepositories:(void (^)(BOOL, NSString*, NSArray <RepositoryObject*>*))completionHandler;

- (void)loadCommits:(RepositoryObject*)repository completion:(void (^)(BOOL, NSString*, RepositoryAuthorObject*))completionHandler;

- (void)refresh;

@end

