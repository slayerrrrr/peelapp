//
//  WeiboViewController.h
//  PeelApp
//
//  Created by Gaffrey on 12-8-6.
//  Copyright (c) 2012年 Peelapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiboViewController : UIViewController{
    IBOutlet UIWebView *webView;
    UIActivityIndicatorView *activityIndicatorView;
}

@property(nonatomic, retain) UIWebView *webView;
@property(nonatomic, retain) UIActivityIndicatorView *activityIndicatorView;

@end
