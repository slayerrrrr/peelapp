//
//  MainViewController.h
//  PeelApp
//
//  Created by Peelapp on 12-4-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLURLConnection.h"

typedef enum {
	ImageAddressQuery = 0,
    ImageDataQueryFirst = 1,
    ImageDataQuerySecond = 2,
    ImageDataQueryThird = 3,
    ImageDataQueryFourth = 4,
    ImageDataQueryFifth = 5,
}QueryType;

@interface MainViewController : UIViewController<GLURLConnectionDelegate, UIScrollViewDelegate, UIAlertViewDelegate>{
    int photoCount;
    int photoReturnedCount;
    NSMutableDictionary *photoDictionary;
    IBOutlet UIScrollView *homePhotoScrollView;
    IBOutlet UIPageControl *pageControl;
    IBOutlet UIImageView *loadingImageView;
    IBOutlet UIActivityIndicatorView *actIndicator;
}

@property(nonatomic, assign) int photoCount;
@property(nonatomic, assign) int photoReturnedCount;
@property(nonatomic, retain) NSMutableDictionary *photoDictionary;
@property(nonatomic, retain) UIScrollView *homePhotoScrollView;
@property(nonatomic, retain) UIPageControl *pageControl;
@property(nonatomic, retain) UIImageView *loadingImageView;
@property(nonatomic, retain) UIActivityIndicatorView *actIndicator;

@end
