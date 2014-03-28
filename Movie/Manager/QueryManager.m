//
//  QueryManager.m
//  Movie
//
//  Created by Yoon Lee on 3/14/14.
//  Copyright (c) 2014 Yoon Lee. All rights reserved.
//

#import "QueryManager.h"
#define TUNES_DEFAULT_SEARCH_URI    @"https://itunes.apple.com/search"
NSString *const MOVIE_REQUEST_NOTIFICATION_RECEV = @"MOVIE_REQUEST_NOTIFICATION_RECEV";

@interface QueryManager()

// mutable string has better performance on appending with other string
@property(nonatomic, retain)NSMutableString *query;
// i realized that message was sent to device by packet, and sometimes sealed by multiple its pieces. so that had to collect puzzled data.
@property(nonatomic, retain)NSMutableData *collection;

@end

@implementation QueryManager
@synthesize query;
@synthesize collection;

+ (id)sharedQueryManager
{
    static QueryManager *qm = nil;
    
    if (qm == nil) {
        qm = [[QueryManager alloc] init];
    }
    
    return qm;
}

- (void)makeMovieQuery:(NSString*)keyword
{
    [self setQuery:[[[NSMutableString alloc] initWithString:TUNES_DEFAULT_SEARCH_URI] autorelease]];
    // sending with parameters with keyword
    [self.query appendFormat:@"?term=%@&country=US&media=movie", keyword];
}

- (void)executeQuery
{
    collection = [[NSMutableData alloc] init];
    NSURL *uri = [NSURL URLWithString:[self.query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSURLRequest *request = [NSURLRequest requestWithURL:uri cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.f];
    NSURLConnection *connection = [[[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:YES] autorelease];
    [connection start];
}

#pragma mark NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // collecting data piece into one
    [collection appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *err = nil;
    id json = [collection objectFromJSONDataWithParseOptions:JKParseOptionNone error:&err];
    if (err) {
        DLog(@"%@", [err description]);
    }
    else
        // post notification and hand over json object
        [[NSNotificationCenter defaultCenter] postNotificationName:MOVIE_REQUEST_NOTIFICATION_RECEV object:json userInfo:nil];
}

- (void)dealloc
{
    [super dealloc];
    
    [collection release];
    collection = nil;
}

@end
