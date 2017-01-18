//
//  PhotoListViewController.h
//  PeelApp
//
//  Created by Peelapp on 12-4-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLURLConnection.h"
#import "ImageWithTitleViewController.h"

@interface PhotoListViewController : UIViewController<GLURLConnectionDelegate, ImageWithTitleViewControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>{
    IBOutlet UIScrollView *photoScrollView;
    IBOutlet UIActivityIndicatorView *indicator;
    IBOutlet UIImageView *loadingImageView;
    NSMutableArray *photoArray;
    NSArray *resultArray;
    NSString *photosURL;
    GLURLConnection *urlConnection;
}

@property(nonatomic, retain) UIScrollView *photoScrollView;
@property(nonatomic, retain) UIActivityIndicatorView *indicator;
@property(nonatomic, retain) UIImageView *loadingImageView;
@property(nonatomic, retain) NSMutableArray *photoArray;
@property(nonatomic, retain) NSArray *resultArray;
@property(nonatomic, retain) NSString *photosURL;
@property(nonatomic, retain) GLURLConnection *urlConnection;

@end
