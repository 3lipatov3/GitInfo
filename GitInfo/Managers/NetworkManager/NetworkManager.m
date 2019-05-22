//
//  NetworkManager.m
//  GitInfo
//
//  Created by Eugen Lipatov on 5/21/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

#import "NetworkManager.h"

typedef enum {
    RequestTypeRepositories,
    RequestTypeCommits
} RequestType;


@interface NetworkManager() {
    unsigned page;
}

@property (retain, nonatomic) NSURLSession *session;

@end


@implementation NetworkManager

- (void)loadRepositories:(void (^)(BOOL, NSString*, NSArray <RepositoryObject*>*))completionHandler {
    if (self.isLoading == true) {
        completionHandler(false, nil, nil);
        return;
    }
    
    self.isLoading = true;
    NSMutableURLRequest *request = [self request:RequestTypeRepositories repository:nil];
    NSURLSessionDataTask *downloadTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        self.isLoading = false;
        if (!error) {
            self->page++;
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*) response;
            if (httpResponse.statusCode == 200) {
                NSDictionary* json = [NSJSONSerialization
                                      JSONObjectWithData:data
                                      options:kNilOptions
                                      error:&error];
                NSMutableArray <RepositoryObject*> *result = [NSMutableArray new];
                if ([json valueForKey:@"items"] != nil) {
                    for (NSDictionary *oneRepo in [json valueForKey:@"items"]) {
                        [result addObject:[[RepositoryObject alloc] initWithDictionary:oneRepo]];
                    }
                }
                if (result.count < self.itemsPerPage) {
                    self.allDataLoaded = true;
                }
                
                completionHandler(true, nil, result);
            } else {
                self.allDataLoaded = false;
                completionHandler(false, [NSHTTPURLResponse localizedStringForStatusCode:httpResponse.statusCode], nil);
            }
        }
    }];
    
    [downloadTask resume];
}

- (void)loadCommits:(RepositoryObject*)repository completion:(void (^)(BOOL, NSString*, RepositoryAuthorObject*))completionHandler {
    if (self.isLoading == true) {
        completionHandler(false, nil, nil);
        return;
    }
    self.isLoading = true;
    NSMutableURLRequest *request = [self request:RequestTypeCommits repository:repository];
    NSURLSessionDataTask *downloadTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        self.isLoading = false;
        if (!error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*) response;
            if (httpResponse.statusCode == 200) {
                NSDictionary* json = [NSJSONSerialization
                                      JSONObjectWithData:data
                                      options:kNilOptions
                                      error:&error];
                self.allDataLoaded = true;
                
                RepositoryAuthorObject *authorItem = [[RepositoryAuthorObject alloc] initWithDictionary:json];
                completionHandler(true, nil, authorItem);
            } else {
                self.allDataLoaded = false;
                completionHandler(false, [NSHTTPURLResponse localizedStringForStatusCode:httpResponse.statusCode], nil);
            }
        } else {
            completionHandler(false, error.localizedDescription, nil);
        }
    }];
    
    [downloadTask resume];
}

- (void)refresh {
    page = 1;
    
    [self.session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        if (!dataTasks || !dataTasks.count) {
            return;
        }
        for (NSURLSessionTask *task in dataTasks) {
            [task cancel];
        }
    }];
}

- (NSURLSession*)session {
    if (_session != nil) {
        return _session;
    }
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:config];
    
    return  _session;
}

- (int)itemsPerPage {
    return 20;
}

- (NSURL*)url:(RequestType)type repository:(RepositoryObject*)repository {
    
    NSURLComponents *urlComponents = [NSURLComponents new];
    urlComponents.scheme = @"https";
    urlComponents.host = @"api.github.com";
    
    NSMutableArray<NSURLQueryItem*>*queryItems = [NSMutableArray new];
    
    switch (type) {
        case RequestTypeRepositories:
            urlComponents.path = @"/search/repositories";
            
            [queryItems addObject:[[NSURLQueryItem alloc] initWithName:@"q" value:@"language:swift+topic:swift"]];
            [queryItems addObject:[[NSURLQueryItem alloc] initWithName:@"sort" value:@"stars"]];
            [queryItems addObject:[[NSURLQueryItem alloc] initWithName:@"order" value:@"desc"]];
            [queryItems addObject:[[NSURLQueryItem alloc] initWithName:@"per_page" value:[NSString stringWithFormat:@"%d", self.itemsPerPage]]];
            [queryItems addObject:[[NSURLQueryItem alloc] initWithName:@"page" value:[NSString stringWithFormat:@"%d", page]]];
            break;
        case RequestTypeCommits:
            urlComponents.path = [NSString stringWithFormat:@"/repos/%@/commits/%@", repository.fullName, repository.defaultBranch];
            break;
        default:
            
            break;
    }
    urlComponents.queryItems = queryItems;
    return urlComponents.URL;
}


- (NSMutableURLRequest*)request:(RequestType)type repository:(RepositoryObject*)repository {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[self url:type repository:repository]];
    request.HTTPMethod = @"GET";
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    return  request;
}



@end
