//
//  PhotoViewController.h
//  PeelApp
//
//  Created by Peelapp on 12-4-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLURLConnection.h"
#import "ImageWithTitleViewController.h"

@interface PhotoViewController : UIViewController<GLURLConnectionDelegate, ImageWithTitleViewControllerDelegate, UIAlertViewDelegate>{
    IBOutlet UIScrollView *albumScrollView;
    IBOutlet UIActivityIndicatorView *indicator;
    IBOutlet UIImageView *loadingImageView;
    NSMutableArray *imageTitleArray;
    NSArray *resultArray;
}

@property(nonatomic, retain) UIScrollView *albumScrollView;
@property(nonatomic, retain) UIActivityIndicatorView *indicator;
@property(nonatomic, retain) UIImageView *loadingImageView;
@property(nonatomic, retain) NSMutableArray *imageTitleArray;
@property(nonatomic, retain) NSArray *resultArray;
@end
