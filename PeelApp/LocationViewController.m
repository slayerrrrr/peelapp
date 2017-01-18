//
//  LocationViewController.m
//  PeelApp
//
//  Created by Peelapp on 12-4-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LocationViewController.h"
#import "JSON.h"
#import "Constant.h"
#import "LocationMapViewController.h"
#import "AppDelegate.h"

@implementation LocationViewController
@synthesize resultDictionary;
@synthesize locationTableView, locationImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"]; 
        NSDictionary *colorDic = [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"AppColorConfig"];
        
        NSArray *navTitleArray = [colorDic objectForKey:@"NavigationBarTitleColor"];
        float navTitleRed = [[navTitleArray objectAtIndex:0] floatValue]/255.0;
        float navTitleGreen = [[navTitleArray objectAtIndex:1] floatValue]/255.0;
        float navTitleBlue = [[navTitleArray objectAtIndex:2] floatValue]/255.0;
        float navTitleAlpha = [[navTitleArray objectAtIndex:3] floatValue];
        
        NSString *LocationViewTabBarName = [[[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"AppTabBarNameConfig"] objectForKey:@"LocationViewController"];
        
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400, 44)] autorelease];
        label.text = LocationViewTabBarName;
        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:navTitleRed green:navTitleGreen blue:navTitleBlue alpha:navTitleAlpha];
        self.navigationItem.titleView = label;
        
        self.title = LocationViewTabBarName;
        self.tabBarItem.image = [UIImage imageNamed:@"locationView_tab_icon.png"];
    }
    return self;
}

-(void)dealloc{
    [resultDictionary release];
    [locationTableView release];
    [locationImageView release];
    [super dealloc];
    [super release];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareButtonPressed)];
    self.navigationItem.rightBarButtonItem = shareButton;
    [shareButton release];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"]; 
    self.resultDictionary = [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"LocationViewConfig"];
    
    //配table seperator颜色
    NSArray *seperatorColor = [resultDictionary objectForKey:@"tableSeperatorColor"];
    float seperatorRed = [[seperatorColor objectAtIndex:0] floatValue]/255;
    float seperatorGreen = [[seperatorColor objectAtIndex:1] floatValue]/255;
    float seperatorBlue = [[seperatorColor objectAtIndex:2] floatValue]/255;
    float seperatorAlpha = [[seperatorColor objectAtIndex:3] floatValue];
    self.locationTableView.separatorColor = [UIColor colorWithRed:seperatorRed green:seperatorGreen blue:seperatorBlue alpha:seperatorAlpha];
    
    [self.locationTableView reloadData];
}

-(void)shareButtonPressed{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"新浪微博", @"短信", @"电子邮件", nil];
    [actionSheet showInView:self.locationTableView];
    [actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *shareInfo = [NSString stringWithFormat:@"地址: %@ \n电话: %@", 
                           [resultDictionary objectForKey:@"address"], 
                           [resultDictionary objectForKey:@"phone"]];
    
    if (buttonIndex == 0) {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:WeiboIDKey]) {
            WBSendView *sendView = [[WBSendView alloc] initWithAppKey:SinaWeiBoKey appSecret:SinaWeiBoSecret text:shareInfo image:nil];
            [sendView setDelegate:self];
            
            [sendView show:YES];
            [sendView release];
        }
        else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请登陆新浪微博" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        }
        
        
    }
	else if (buttonIndex == 1) {
        Class smsClass = (NSClassFromString(@"MFMessageComposeViewController"));
        if (smsClass != nil){
            if ([MFMessageComposeViewController canSendText]) {
                MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
                
                picker.messageComposeDelegate = self;
                picker.navigationBar.tintColor = [UIColor blackColor];
                picker.body = shareInfo;
                [self presentModalViewController:picker animated:YES];
                [picker release];		
            }	
            else{
                UIAlertView * smsCheck = [[UIAlertView alloc] initWithTitle:@"请检查短信配置" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                smsCheck.frame = CGRectMake(50, 150, 100, 90);
                [smsCheck show];
                [smsCheck release];
            }
        }
        else {
            UIAlertView * smsCheck = [[UIAlertView alloc] initWithTitle:@"已复制文章内容,可用短信发送" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            smsCheck.frame = CGRectMake(50, 150, 100, 90);
            [smsCheck show];
            [smsCheck release];
        }
    }
    else if(buttonIndex == 2){
        //判断是否可以发布mail
        if( [MFMailComposeViewController canSendMail] ){
            //用MFMailComposeViewController推进到发送电子邮件界面
            MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
            controller.mailComposeDelegate = self;
            
            //设定电子邮件的内容
            [controller setMessageBody:shareInfo isHTML:NO];
            [self presentModalViewController:controller animated:YES];
            [controller release];
        }
        else {
            //弹出警告框提示用户不能发布mail
            UIAlertView * mailAlert = [[UIAlertView alloc] initWithTitle:@"请确认邮箱配置" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            mailAlert.frame = CGRectMake(50, 150, 100, 90);
            [mailAlert show];
            [mailAlert release];
        }	
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
	[self dismissModalViewControllerAnimated:YES];	
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark - WBSendViewDelegate Methods

- (void)sendViewDidFinishSending:(WBSendView *)view
{
    [view hide:YES];
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"微博发送成功！" 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)sendView:(WBSendView *)view didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    [view hide:YES];
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"微博发送失败！" 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)sendViewNotAuthorized:(WBSendView *)view
{
    [view hide:YES];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)sendViewAuthorizeExpired:(WBSendView *)view
{
    [view hide:YES];
    
    [self dismissModalViewControllerAnimated:YES];
}

//根据文字内容,判断label大小
- (CGSize)getProperSizeForLabel:(NSString *)text setTextFont:(UIFont *)textFont {
	//设置最大限度
	CGSize maximumLabelSize = CGSizeMake(271,10000);
	
	//预判label大小
	CGSize expectedLabelSize = [text	
								sizeWithFont:textFont
								constrainedToSize:maximumLabelSize 
								lineBreakMode:UILineBreakModeWordWrap]; 
	
	return expectedLabelSize;
}
 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int number = 0;
    if (section == 0) {
        number = 2;
    }
    else if (section == 1){
        number = 2;
    }
    else if (section == 2){
        number = 1;
    }
    
    return number;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        CGSize size = [self getProperSizeForLabel:[resultDictionary objectForKey:@"content"] setTextFont:[UIFont fontWithName:@"Helvetica" size:15]];
        return size.height + 10;
    }
    else{
        return 44;
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             cellIdentifier];
	
	//初始化cell
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 
                                       reuseIdentifier: cellIdentifier] autorelease];
    }
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    
    //配置cell text颜色
    NSArray *textColor = [resultDictionary objectForKey:@"textColor"];
    float textRed = [[textColor objectAtIndex:0] floatValue]/255;
    float textGreen = [[textColor objectAtIndex:1] floatValue]/255;
    float textBlue = [[textColor objectAtIndex:2] floatValue]/255;
    float textAlpha = [[textColor objectAtIndex:3] floatValue];
    cell.textLabel.textColor = [UIColor colorWithRed:textRed green:textGreen blue:textBlue alpha:textAlpha];
    
    CGSize size = [self getProperSizeForLabel:[resultDictionary objectForKey:@"content"] setTextFont:[UIFont fontWithName:@"Helvetica" size:15]];
    cell.textLabel.frame = CGRectMake(0, 5, 271, size.height);
    
    
    //配置cell背景颜色
    NSArray *cellColor = [resultDictionary objectForKey:@"cellColor"];
    float cellRed = [[cellColor objectAtIndex:0] floatValue]/255;
    float cellGreen = [[cellColor objectAtIndex:1] floatValue]/255;
    float cellBlue = [[cellColor objectAtIndex:2] floatValue]/255;
    float cellAlpha = [[cellColor objectAtIndex:3] floatValue];
    cell.backgroundColor = [UIColor colorWithRed:cellRed green:cellGreen blue:cellBlue alpha:cellAlpha];
    
    if (indexPath.section == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"地址: %@", [resultDictionary objectForKey:@"address"]];
        }
        else if(indexPath.row == 1){
            cell.textLabel.text = [NSString stringWithFormat:@"营业时间: %@", [resultDictionary objectForKey:@"time"]];
        }
    }
    else if (indexPath.section == 1){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        if (indexPath.row == 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"电话: %@", [resultDictionary objectForKey:@"phone"]];
        }
        else if (indexPath.row == 1) {
            cell.textLabel.text = @"在地图上查看";
        }
    }
    else if (indexPath.section == 2){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [resultDictionary objectForKey:@"content"]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //点击之后取消反显效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
           
        }
    }
    else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            NSURL *phoneNumberURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",[resultDictionary objectForKey:@"phone"]]];   
            
            if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:)]) {
                [[UIApplication sharedApplication] openURL:phoneNumberURL]; 
            }
        }
        else if (indexPath.row == 1) { 
            LocationMapViewController *mapView = [[LocationMapViewController alloc] init];
            mapView.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:mapView animated:YES];
            [mapView release];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return NO;
    }
    else{
        return YES;
    }
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    return (action == @selector(copy:));
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(copy:)){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSString *info = cell.textLabel.text;
        
        [[UIPasteboard generalPasteboard] setString:info];
        [UIPasteboard generalPasteboard].persistent = YES;
    }
}

    
@end
