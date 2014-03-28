//
//  QueryManager.h
//  Movie
//
//  Created by Yoon Lee on 3/14/14.
//  Copyright (c) 2014 Yoon Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
// borrowed fastest JSON serializer class from github
#import "JSONKit.h"

// exclusive notification identifier to let listener object to know the status
extern NSString *const MOVIE_REQUEST_NOTIFICATION_RECEV;

@interface QueryManager : NSObject<NSURLConnectionDataDelegate>

+ (id)sharedQueryManager;

// mix with keyword parameter
- (void)makeMovieQuery:(NSString*)keyword;
// excuting the query
- (void)executeQuery;

@end
