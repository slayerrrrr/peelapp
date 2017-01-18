//
//  MenuDetailViewController.h
//  PeelApp
//
//  Created by Gaffrey on 12-8-18.
//  Copyright (c) 2012年 Peelapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLURLConnection.h"

typedef enum {
	MenuDetailViewImageAddress = 0,
    MenuDetailViewImageDataQueryFirst = 1,
    MenuDetailViewImageDataQuerySecond = 2,
    MenuDetailViewImageDataQueryThird = 3,
    MenuDetailViewImageDataQueryFourth = 4,
    MenuDetailViewImageDataQueryFifth = 5,
}MenuDetailViewQueryType;

@interface MenuDetailViewController : UIViewController<GLURLConnectionDelegate, UIScrollViewDelegate, UIAlertViewDelegate>{
    NSString *urlString;
    NSDictionary *infoDic;
    
    IBOutlet UIScrollView *detailScrollView;
    IBOutlet UIScrollView *imageScrollView;
    IBOutlet UIPageControl *pageControl;
    IBOutlet UIImageView *loadingImageView;
    IBOutlet UIActivityIndicatorView *actIndicator;
    IBOutlet UIImageView *pageControlBg;
    
    GLURLConnection *infoURLConnection;
    NSMutableArray *imageURLConnectionArray;
}

@property(nonatomic, retain) NSString *urlString;
@property(nonatomic, retain) NSDictionary *infoDic;
@property(nonatomic, retain) UIScrollView *detailScrollView;
@property(nonatomic, retain) UIScrollView *imageScrollView;
@property(nonatomic, retain) UIPageControl *pageControl;
@property(nonatomic, retain) GLURLConnection *infoURLConnection;
@property(nonatomic, retain) NSMutableArray *imageURLConnectionArray;
@property(nonatomic, retain) UIImageView *loadingImageView;
@property(nonatomic, retain) UIActivityIndicatorView *actIndicator;
@property(nonatomic, retain) UIImageView *pageControlBg;

-(void)configScrollView;
- (CGSize)getProperSizeForLabel:(NSString *)text setTextFont:(UIFont *)textFont;

@end
