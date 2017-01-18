//
//  NewsViewController.h
//  PeelApp
//
//  Created by Peelapp on 12-4-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshView.h"
#import "GLURLConnection.h"

@interface NewsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,GLURLConnectionDelegate, UIAlertViewDelegate>{
    IBOutlet UITableView *listTableView;
    IBOutlet UIImageView *bgImageView;
    IBOutlet UIActivityIndicatorView *indicator;
    IBOutlet UIImageView *loadingImageView;
    
    NSMutableArray *dataArray;
    int queryIndex;
}

@property(nonatomic, retain) UITableView *listTableView;
@property(nonatomic, retain) NSMutableArray *dataArray;
@property(nonatomic, assign) int queryIndex;
@property(nonatomic, retain) UIImageView *bgImageView;
@property(nonatomic, retain) UIActivityIndicatorView *indicator;
@property(nonatomic, retain) UIImageView *loadingImageView;

-(void)refresh;
-(void)showMore;

@end