//
//  GLURLConnection.h
//  PeelApp
//
//  Created by Peelapp on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GLURLConnectionDelegate;

@interface GLURLConnection : NSObject{
    NSMutableData *receivedData;
	NSURLConnection *connection;
	id delegate;
    int tag;
}

@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) int tag;

- (id)initWithURLString:(NSString *)urlString delegate:(id)delegate tag:(int)tag;
- (void)cancel;

@end

@protocol GLURLConnectionDelegate <NSObject>

@optional
- (void)urlConnectionDidFinishLoading:(GLURLConnection *)urlConnection;
- (void)urlConnection:(GLURLConnection *)urlConnection didFailWithError:(NSError *)error;

@end
