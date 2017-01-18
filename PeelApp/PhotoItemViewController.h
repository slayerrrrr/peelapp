//
//  PhotoItemViewController.h
//  PeelApp
//
//  Created by Peelapp on 12-5-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageWithTitleViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "ReviewViewController.h"
#import "WBSendView.h"

@interface PhotoItemViewController : UIViewController<ImageWithTitleViewControllerDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, ReviewViewControllerDelegate, WBSendViewDelegate>{
    NSMutableArray *imageTitleArray;
    NSArray *photoArray;
    IBOutlet UIScrollView *photoScrollView;
    int initIndex;
    IBOutlet UIToolbar *toolBar;
    IBOutlet UINavigationBar *navBar;
    IBOutlet UIImageView *downloadImageView;
}

@property(nonatomic, retain) NSMutableArray *imageTitleArray;
@property(nonatomic, retain) NSArray *photoArray;
@property(nonatomic, retain) UIScrollView *photoScrollView;
@property(nonatomic, assign) int initIndex;
@property(nonatomic, retain) UIToolbar *toolBar;
@property(nonatomic, retain) UINavigationBar *navBar;
@property(nonatomic, retain) UIImageView *downloadImageView;

-(IBAction)saveIntoPhotoLibrary;
-(IBAction)cancelButtonPressed;
-(IBAction)reviewButtonPressed;
-(IBAction)shareButtonPressed;
-(void)hideDownloadImageView;
-(void)initImageView;

@end
