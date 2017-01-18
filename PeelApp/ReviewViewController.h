//
//  ReviewViewController.h
//  YangSheng
//
//  Created by Peelapp on 12-3-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLURLConnection.h"

@interface ReviewViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, GLURLConnectionDelegate, UIAlertViewDelegate>{
    NSString *reviewURL;
    int queryIndex;
    NSMutableArray *dataArray;
    IBOutlet UITableView *reviewTableView;
    IBOutlet UIActivityIndicatorView *indicator;
    IBOutlet UIButton *writeReviewButton;
    IBOutlet UIImageView *loadingImageView;
    
    IBOutlet UINavigationBar *navBar;
    
    id delegate;
}

@property(nonatomic, retain) NSString *reviewURL;
@property(nonatomic, assign) int queryIndex;
@property(nonatomic, retain) NSMutableArray *dataArray;
@property(nonatomic, retain) UITableView *reviewTableView;
@property(nonatomic, retain) UIActivityIndicatorView *indicator;
@property(nonatomic, retain) UIImageView *loadingImageView;
@property(nonatomic, retain) UIButton *writeReviewButton;
@property(nonatomic, assign) id delegate;
@property(nonatomic, retain) UINavigationBar *navBar;

-(void)getMoreReviews;
-(IBAction)doneButtonPressed;
- (CGSize)getProperSizeForLabel:(NSString *)text setTextFont:(UIFont *)textFont;
-(IBAction)writeReviewButtonPressed;

@end

@protocol ReviewViewControllerDelegate <NSObject>
@optional
-(void)reviewViewControllerDoneButtonDidPressed:(ReviewViewController *)reviewViewController;
@end
