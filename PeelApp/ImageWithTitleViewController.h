//
//  ImageWithTitleViewController.h
//  PeelApp
//
//  Created by Peelapp on 12-4-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLURLConnection.h"

@interface ImageWithTitleViewController : UIViewController<GLURLConnectionDelegate, UIScrollViewDelegate>{
    id delegate;
    GLURLConnection *urlConnection;
    NSString *urlString;
    
    IBOutlet UIImageView *frameImageView;
    IBOutlet UIImageView *albumImageView;
    IBOutlet UIImageView *titleLabelBgImageView;
    IBOutlet UILabel *titleLabel;
    IBOutlet UIActivityIndicatorView *indicator;
    IBOutlet UIScrollView *photoScrollView;
}

@property(nonatomic, assign) id delegate;
@property(nonatomic, retain) UIImageView *frameImageView;
@property(nonatomic, retain) UIImageView *albumImageView;
@property(nonatomic, retain) UIImageView *titleLabelBgImageView;
@property(nonatomic, retain) UILabel *titleLabel;
@property(nonatomic, retain) NSString *urlString;
@property(nonatomic, retain) UIActivityIndicatorView *indicator;
@property(nonatomic, retain) GLURLConnection *urlConnection;
@property(nonatomic, retain) UIScrollView *photoScrollView;

-(void)resetScrollView;

@end

@protocol ImageWithTitleViewControllerDelegate <NSObject>
-(void)imageDidSeleted:(ImageWithTitleViewController *)imageWithTitleViewController;
@end