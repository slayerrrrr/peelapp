//
//  LocationViewController.h
//  PeelApp
//
//  Created by Peelapp on 12-4-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "WBSendView.h"

@interface LocationViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, WBSendViewDelegate>{
    IBOutlet UITableView *locationTableView;
    IBOutlet UIImageView *locationImageView;
    
    NSDictionary *resultDictionary;
}

@property(nonatomic, retain) NSDictionary *resultDictionary;
@property(nonatomic, retain) UITableView *locationTableView;
@property(nonatomic, retain) UIImageView *locationImageView;

-(CGSize)getProperSizeForLabel:(NSString *)text setTextFont:(UIFont *)textFont;
-(void)shareButtonPressed;

@end
