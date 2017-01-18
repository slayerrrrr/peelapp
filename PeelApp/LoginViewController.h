//
//  LoginViewController.h
//  YangSheng
//
//  Created by Peelapp on 12-2-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBEngine.h"
#import "WBSendView.h"
#import "WBLogInAlertView.h"

@interface LoginViewController : UIViewController<WBEngineDelegate>{
    id delegate;
    IBOutlet UIButton *button;
    IBOutlet UINavigationBar *navBar;
    IBOutlet UIActivityIndicatorView *indicator;
    NSMutableData * receivedData;
    IBOutlet UILabel *accountLabel;
}

@property(nonatomic, retain) UIButton *button;
@property(nonatomic, retain) UINavigationBar *navBar;
@property(nonatomic, assign) id delegate;
@property(nonatomic, retain) NSMutableData * receivedData;
@property(nonatomic, retain) UIActivityIndicatorView *indicator;
@property(nonatomic, retain) UILabel *accountLabel;

-(IBAction)buttonPressed:(id)sender;
-(void)login;
-(void)logout;
-(IBAction)doneButtonPressed;

@end

@protocol LoginViewControllerDelegate <NSObject>
-(void)cancelButtonDidPressed;
@end