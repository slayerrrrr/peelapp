//
//  ComposeReviewViewController.m
//  ;
//
//  Created by Peelapp on 12-3-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ComposeReviewViewController.h"
#import "LoginViewController.h"
#import "Constant.h"

@implementation ComposeReviewViewController
@synthesize reviewTextView;
@synthesize receivedData;
@synthesize activityIndicator;
@synthesize postURL;
@synthesize navBar;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"]; 
    NSDictionary *colorDic = [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"AppColorConfig"];
    NSArray *navTintArray = [colorDic objectForKey:@"NavigationBarTint"];
    float navRed = [[navTintArray objectAtIndex:0] floatValue]/255.0;
    float navGreen = [[navTintArray objectAtIndex:1] floatValue]/255.0;
    float navBlue = [[navTintArray objectAtIndex:2] floatValue]/255.0;
    self.navBar.tintColor = [UIColor colorWithRed:navRed green:navGreen blue:navBlue alpha:1];
    
    [self.reviewTextView becomeFirstResponder];
}

-(void)viewDidAppear:(BOOL)animated{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    if (self.view.tag == 0) {
        self.view.tag = 1;
        
        if (![defaults objectForKey:WeiboUsernameKey]) {
            LoginViewController *loginView = [[LoginViewController alloc] init];
            loginView.delegate = self;
            [self presentModalViewController:loginView animated:YES];
            [loginView release];
        } 
    }   
    else{
        if (![defaults objectForKey:WeiboUsernameKey]) {
            [self dismissModalViewControllerAnimated:YES];
        } 
    }
}

-(void)dealloc{
    [reviewTextView release];
    [receivedData release];
    [activityIndicator release];
    [postURL release];
    [navBar release];
    [super dealloc];
}

-(void)cancelButtonDidPressed{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)textViewDidChange:(UITextView *)textView{
	//将翻译内容控制在140个字符串以内
	if ([self.reviewTextView.text length] > 140) {
		NSString * tempString = [self.reviewTextView.text substringToIndex:140];
		self.reviewTextView.text = tempString;
	}
}

-(void)cancelButtonPressed{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)postButtonPressed{    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    [self.activityIndicator startAnimating];
    self.activityIndicator.hidden = NO;
    
    NSMutableData *tempData = [[NSMutableData alloc] init];
    self.receivedData = tempData;
    [tempData release];
    
    NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc] init];
    NSURL *connection = [[NSURL alloc] initWithString:postURL];
    
    NSMutableString *bodyText = [NSMutableString stringWithFormat:@"content=%@&uid=%@", self.reviewTextView.text, [defaults objectForKey:WeiboIDKey]];
    
    NSMutableString *httpBodyString=[[NSMutableString alloc] initWithString:bodyText];
    
    [postRequest setURL:connection];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setHTTPBody:[httpBodyString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:nil error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    [postRequest release];
    [httpBodyString release];
    [connection release];
   
    self.activityIndicator.hidden = YES;
    
    if ([jsonString isEqualToString:@"true"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"发布成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"发布失败，请稍后再试" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
	
    [jsonString release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	[self dismissModalViewControllerAnimated:YES];
}

@end
