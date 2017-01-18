//
//  FeedbackViewController.m
//  YangSheng
//
//  Created by Peelapp on 12-3-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FeedbackViewController.h"
#import "Constant.h"

NSString *const PostURL = @"http://peelapp.ouu.in/api/apps/%@/feedbacks";  //appid

@implementation FeedbackViewController
@synthesize feedbackTextView;
@synthesize receivedData;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
	NSString *PostButtonTile = @"发布";
	UIBarButtonItem * rightButton = [[UIBarButtonItem alloc] initWithTitle:PostButtonTile style:UIBarButtonItemStyleDone target:self action:@selector(postButtonPressed)];
	[self.navigationItem setRightBarButtonItem:rightButton];
    [rightButton release];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"]; 
    NSDictionary *colorDic = [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"AppColorConfig"];
    
    NSArray *navTitleArray = [colorDic objectForKey:@"NavigationBarTitleColor"];
    float navTitleRed = [[navTitleArray objectAtIndex:0] floatValue]/255.0;
    float navTitleGreen = [[navTitleArray objectAtIndex:1] floatValue]/255.0;
    float navTitleBlue = [[navTitleArray objectAtIndex:2] floatValue]/255.0;
    float navTitleAlpha = [[navTitleArray objectAtIndex:3] floatValue];
    
    NSString *titleString = @"意见反馈";
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400, 44)] autorelease];
    label.text = titleString;
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:navTitleRed green:navTitleGreen blue:navTitleBlue alpha:navTitleAlpha];
    self.navigationItem.titleView = label;
    
    
    self.title =  @"意见反馈";
    [self.feedbackTextView becomeFirstResponder];
}

- (void)dealloc{
    [feedbackTextView release];
    [receivedData release];
    
    [super dealloc];
}

-(void)postButtonPressed{
    NSMutableData *tempData = [[NSMutableData alloc] init];
    self.receivedData = tempData;
    [tempData release];
    
    NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc] init];
    
    NSString *url = [NSString stringWithFormat:PostURL, APP_ID];
    NSURL *connection = [[NSURL alloc] initWithString:url];
    
    NSMutableString *bodyText = [NSMutableString stringWithFormat:@"content=%@", self.feedbackTextView.text];
    
    NSMutableString *httpBodyString=[[NSMutableString alloc] initWithString:bodyText];
    
    [postRequest setURL:connection];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setHTTPBody:[httpBodyString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:nil error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    [httpBodyString release];
    [postRequest release];
    [connection release];
    
    if ([jsonString isEqualToString:@"true"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"发布成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"发布失败，请稍后再试" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
    
    [jsonString release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
