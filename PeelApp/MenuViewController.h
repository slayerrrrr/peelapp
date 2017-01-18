//
//  MenuViewController.h
//  PeelApp
//
//  Created by Gaffrey on 12-8-12.
//  Copyright (c) 2012年 Peelapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLURLConnection.h"

@interface MenuViewController : UIViewController<GLURLConnectionDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>{
    NSArray *dataArray;
    IBOutlet UITableView *menuTableView;
    IBOutlet UIImageView *loadingImageView;
    IBOutlet UIActivityIndicatorView *actIndicator;
}

@property(nonatomic, retain) NSArray *dataArray; 
@property(nonatomic, retain) UITableView *menuTableView;
@property(nonatomic, retain) UIImageView *loadingImageView;
@property(nonatomic, retain) UIActivityIndicatorView *actIndicator;

@end
