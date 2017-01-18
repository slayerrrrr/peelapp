//
//  LoginViewController.m
//  YangSheng
//
//  Created by Peelapp on 12-2-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "Constant.h"
#import "AppDelegate.h"
#import "SettingsViewController.h"

@implementation LoginViewController
@synthesize button;
@synthesize navBar;
@synthesize delegate;
@synthesize receivedData;
@synthesize indicator;
@synthesize accountLabel;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nil
    
    if (!APPDELEGATE.weiBoEngine) {
        WBEngine *engine = [[WBEngine alloc] initWithAppKey:SinaWeiBoKey appSecret:SinaWeiBoSecret];
        [engine setRootViewController:self];
        [engine setDelegate:self];
        [engine setRedirectURI:@"http://"];
        [engine setIsUserExclusive:NO];
        APPDELEGATE.weiBoEngine = engine;
        [engine release];
    }
    
    self.indicator.hidden = YES;
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	
	//根据登录情况,显示不同内容
	if ([[defaults objectForKey:WeiboIDKey] length] == 0) {
        accountLabel.text = @"帐户: 未登录";
		[button setTitle:@"登陆新浪微博" forState:UIControlStateNormal];
	}
	else {
        accountLabel.text = [NSString stringWithFormat:@"帐户: %@", [defaults objectForKey:WeiboUsernameKey]];
		[button setTitle:@"登出新浪微博" forState:UIControlStateNormal];
	} 

    //位于登陆页面
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"]; 
    NSArray *viewControllers = [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"ViewControllers"];
    
    if ([[viewControllers objectAtIndex:APPDELEGATE.tabBarController.selectedIndex] isEqualToString:@"SettingsViewController"]) {
        self.navBar.hidden = YES;
    } 
    else{
        NSDictionary *colorDic = [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"AppColorConfig"];
        NSArray *navTintArray = [colorDic objectForKey:@"NavigationBarTint"];
        float navRed = [[navTintArray objectAtIndex:0] floatValue]/255.0;
        float navGreen = [[navTintArray objectAtIndex:1] floatValue]/255.0;
        float navBlue = [[navTintArray objectAtIndex:2] floatValue]/255.0;
        self.navBar.tintColor = [UIColor colorWithRed:navRed green:navGreen blue:navBlue alpha:1];
        
        CGRect buttonFrame = self.button.frame;
        buttonFrame.origin.y = buttonFrame.origin.y + 44;
        self.button.frame = buttonFrame;
        
        CGRect labelFrame = self.accountLabel.frame;
        labelFrame.origin.y = labelFrame.origin.y + 44;
        self.accountLabel.frame = labelFrame;
    }
}

-(void)dealloc{
    [button release];
    [navBar release];
    [indicator release];
    [accountLabel release];
    [super release];
    [super dealloc];
}

-(IBAction)buttonPressed:(id)sender{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	
	//根据登录情况,显示不同内容
	if ([[defaults objectForKey:WeiboIDKey] length] == 0) {
		[self login];
	}
	else {
		[self logout];
	} 
}

-(IBAction)doneButtonPressed{
    [self dismissModalViewControllerAnimated:YES];
    [self.delegate cancelButtonDidPressed];
}

-(void)login{
	[APPDELEGATE.weiBoEngine logIn];
}

-(void)logout{
    [APPDELEGATE.weiBoEngine logOut];
}

#pragma mark - WBEngineDelegate Methods

#pragma mark Authorize

- (void)engineAlreadyLoggedIn:(WBEngine *)engine
{
    if ([engine isUserExclusive])
    {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
                                                           message:@"请先登出！" 
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定" 
                                                 otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}

- (void)engineDidLogIn:(WBEngine *)engine
{
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:APPDELEGATE.weiBoEngine.userID forKey:@"uid"];

    [engine loadRequestWithMethodName:@"users/show.json"
                           httpMethod:@"GET"
                               params:parameter
                         postDataType:kWBRequestPostDataTypeNone
                     httpHeaderFields:nil];
    [parameter release];
}

- (void)engine:(WBEngine *)engine didFailToLogInWithError:(NSError *)error
{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"登录失败！" 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)engineDidLogOut:(WBEngine *)engine
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:WeiboIDKey];
    
    accountLabel.text = @"帐户: 未登录";
    [button setTitle:@"登陆新浪微博" forState:UIControlStateNormal];
    
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"已成功退出！" 
													  delegate:nil 
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)engineNotAuthorized:(WBEngine *)engine
{
    
}

- (void)engineAuthorizeExpired:(WBEngine *)engine
{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"请重新登录！" 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

#pragma mark - WBEngineDelegate Methods

- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{
    NSLog(@"requestDidSucceedWithResult: %@", [result objectForKey:@"name"]);
    
    NSString *username = [result objectForKey:@"name"];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:APPDELEGATE.weiBoEngine.userID forKey:WeiboIDKey];
    [defaults setObject:username forKey:WeiboUsernameKey];
    [button setTitle:@"登出新浪微博 " forState:UIControlStateNormal]; 
    
    NSMutableData *tempData = [[NSMutableData alloc] init];
    self.receivedData = tempData;
    [tempData release];
    
    NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc] init];
    NSString *url = [NSString stringWithFormat:weiboUpdateURL, APP_ID];
    NSURL *connection = [[NSURL alloc] initWithString:url];
    
    NSMutableString *bodyText = [NSMutableString stringWithFormat:@"name=%@&uid=%@&type_id=%d", username, APPDELEGATE.weiBoEngine.userID, 1];
    
    NSMutableString *httpBodyString=[[NSMutableString alloc] initWithString:bodyText];
    
    [postRequest setURL:connection];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setHTTPBody:[httpBodyString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:nil error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"jsonString: %@", jsonString);
    
    [postRequest release];
    [connection release];
    [httpBodyString release];
    
    if ([jsonString isEqualToString:@"true"]) {
        //位于登陆页面
        NSString *path = [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"]; 
        NSArray *viewControllers = [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"ViewControllers"];
        
        if (![[viewControllers objectAtIndex:APPDELEGATE.tabBarController.selectedIndex] isEqualToString:@"SettingsViewController"]) {
            [self dismissModalViewControllerAnimated:YES];
        } 
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        accountLabel.text = [NSString stringWithFormat:@"帐户: %@", [defaults objectForKey:WeiboUsernameKey]];
        [button setTitle:@"登出新浪微博" forState:UIControlStateNormal];
    }
    
    [jsonString release];
    
    self.indicator.hidden = YES;
}

- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"新浪微博" message:[NSString stringWithFormat:@"发送失败：%@",[error description] ] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alert show];
	[alert release];
}



@end
