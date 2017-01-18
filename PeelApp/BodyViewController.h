//
//  BodyViewController.h
//  YangSheng
//
//  Created by Peelapp on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "WBSendView.h"

@interface BodyViewController : UIViewController<UIScrollViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UIAlertViewDelegate, WBSendViewDelegate>{
    IBOutlet UIScrollView *bodyScrollView;
    NSDictionary *infoDictionary;
    IBOutlet UIActivityIndicatorView *indicator;
    IBOutlet UIImageView *loadingImageView;
    NSString *urlString;
    IBOutlet UIToolbar *toolBar;
}

@property(retain, nonatomic) UIScrollView *bodyScrollView;
@property(retain, nonatomic) NSDictionary *infoDictionary;
@property(retain, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property(retain, nonatomic) UIImageView *loadingImageView;
@property(retain, nonatomic) NSString *urlString;
@property(retain, nonatomic) UIToolbar *toolBar;

-(void)configScrollView;
- (CGSize)getProperSizeForLabel:(NSString *)text setTextFont:(UIFont *)textFont;

-(IBAction)reviewButtonPressed;
-(IBAction)shareButtonPressed;

@end
