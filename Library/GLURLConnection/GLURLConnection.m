//
//  GLURLConnection.m
//  PeelApp
//
//  Created by Peelapp on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GLURLConnection.h"

@implementation GLURLConnection
@synthesize receivedData, connection, delegate, tag;

- (void)dealloc
{
    self.connection = nil;
	[receivedData release];	
	[connection cancel];
	[connection release];
	[super dealloc];
}

- (id)initWithURLString:(NSString *)urlString delegate:(id)aDelegate tag:(int)aTag{
    self.tag = aTag;
    self.delegate = aDelegate;
    self.receivedData = [NSMutableData data];
    
	NSURL *url = [NSURL URLWithString:urlString];
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:240];
    
	// Create a NSURLConnection object with delegate set to self
    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
    self.connection = urlConnection;
    [urlConnection release];
    
    
    return self;
}

- (void)cancel{
    [self.connection cancel];
    self.connection = nil;
}

- (void)connection:(NSURLConnection *)aConnection didReceiveData:(NSData *)data
{
	[self.receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection{
	self.connection = nil;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(urlConnectionDidFinishLoading:)]) {
        [self.delegate urlConnectionDidFinishLoading:self];
    }
}

- (void)connection:(NSURLConnection *)aConnection didFailWithError:(NSError *)error{
	self.connection = nil;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(urlConnection:didFailWithError:)]) {
        [self.delegate urlConnection:self didFailWithError:error];
    }
}

@end


