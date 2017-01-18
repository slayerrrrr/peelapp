//
//  IntroductionViewController.h
//  PeelApp
//
//  Created by Peelapp on 12-4-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface IntroductionViewController : UIViewController<MFMailComposeViewControllerDelegate, UIAlertViewDelegate>{
    IBOutlet UIScrollView *introScrollView;
}

@property(nonatomic, retain) UIScrollView *introScrollView;

-(void)configScrollView;
-(void)phoneButtonPressed;
-(void)emailButtonPressed;
-(CGSize)getProperSizeForLabel:(NSString *)text setTextFont:(UIFont *)textFont;

@end
