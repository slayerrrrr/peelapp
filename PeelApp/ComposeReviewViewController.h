//
//  ComposeReviewViewController.h
//  YangSheng
//
//  Created by Peelapp on 12-3-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@interface ComposeReviewViewController : UIViewController<UITextViewDelegate, LoginViewControllerDelegate>{
    IBOutlet UITextView *reviewTextView;
    NSMutableData * receivedData;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    NSString *postURL;
    IBOutlet UINavigationBar *navBar;
}

@property(nonatomic, retain) UITextView *reviewTextView;
@property(nonatomic, retain) NSMutableData * receivedData;
@property(nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property(nonatomic, retain) NSString *postURL;
@property(nonatomic, retain) UINavigationBar *navBar;

-(IBAction)cancelButtonPressed;
-(IBAction)postButtonPressed;

@end
