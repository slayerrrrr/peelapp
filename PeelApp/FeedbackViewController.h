//
//  FeedbackViewController.h
//  YangSheng
//
//  Created by Peelapp on 12-3-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackViewController : UIViewController<UIAlertViewDelegate>{
    IBOutlet UITextView *feedbackTextView;
    NSMutableData * receivedData;
}

@property(nonatomic, retain) UITextView *feedbackTextView;
@property(nonatomic, retain) NSMutableData * receivedData;

-(void)postButtonPressed;
@end
