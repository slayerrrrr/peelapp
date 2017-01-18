//
//  MenuListViewController.h
//  PeelApp
//
//  Created by Gaffrey on 12-8-13.
//  Copyright (c) 2012年 Peelapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLURLConnection.h"

@interface MenuListViewController : UIViewController<GLURLConnectionDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>{
    IBOutlet UIImageView *loadingImageView;
    IBOutlet UIActivityIndicatorView *actIndicator;
    IBOutlet UITableView *menuListTableView;
    
    NSDictionary *infoDic;
    NSArray *dataArray;
    NSMutableDictionary *imageDic;
}

@property(nonatomic, retain) NSDictionary *infoDic;
@property(nonatomic, retain) UITableView *menuListTableView;
@property(nonatomic, retain) NSArray *dataArray;
@property(nonatomic, retain) NSMutableDictionary *imageDic;
@property(nonatomic, retain) UIImageView *loadingImageView;
@property(nonatomic, retain) UIActivityIndicatorView *actIndicator;

-(void)downloadImage:(int)index;

@end
