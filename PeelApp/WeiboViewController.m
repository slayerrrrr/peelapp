//
//  WeiboViewController.m
//  PeelApp
//
//  Created by Gaffrey on 12-8-6.
//  Copyright (c) 2012年 Peelapp. All rights reserved.
//

#import "WeiboViewController.h"

@implementation WeiboViewController
@synthesize webView;
@synthesize activityIndicatorView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"]; 
        NSString *WeiboViewTabBarName = [[[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"AppTabBarNameConfig"] objectForKey:@"WeiboViewController"];
        
        self.title = WeiboViewTabBarName;
        self.tabBarItem.image = [UIImage imageNamed:@"weiboView_tab_icon.png"];
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSURL* url = [NSURL URLWithString:@"http://m.weibo.cn/u/1042026447"];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [webView loadRequest:request];
    webView.scalesPageToFit =YES;
    
    UIActivityIndicatorView *tempActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame : CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)] ;
    self.activityIndicatorView = tempActivityIndicatorView;
    [tempActivityIndicatorView release];
    
    [activityIndicatorView setCenter: self.view.center] ;
    [activityIndicatorView setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleGray] ;
    [self.view addSubview : activityIndicatorView] ;
}

- (void)dealloc
{
    [activityIndicatorView release];
    [webView release];
    [super dealloc];
}

@end
