//
//  BodyViewController.m
//  YangSheng
//
//  Created by Peelapp on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BodyViewController.h"
#import "JSON.h"
#import "Constant.h"
#import "ReviewViewController.h"
#import "AppDelegate.h"

@implementation BodyViewController
@synthesize bodyScrollView;
@synthesize infoDictionary;
@synthesize indicator;
@synthesize urlString;
@synthesize loadingImageView;
@synthesize toolBar;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"]; 
    NSDictionary *colorDic= [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"NewsViewConfig"];

    NSArray *barColor = [colorDic objectForKey:@"BodyBarColor"];
    float barRed = [[barColor objectAtIndex:0] floatValue]/255;
    float barGreen = [[barColor objectAtIndex:1] floatValue]/255;
    float barBlue = [[barColor objectAtIndex:2] floatValue]/255;
    float barAlpha = [[barColor objectAtIndex:3] floatValue];
    toolBar.tintColor = [UIColor colorWithRed:barRed green:barGreen blue:barBlue alpha:barAlpha];
    
    NSDictionary *tempDic = [[NSDictionary alloc] init];
    self.infoDictionary = tempDic;
    [tempDic release];
    
    NSLog(@"%@", urlString);
    
    GLURLConnection *urlConnection = [[GLURLConnection alloc] initWithURLString:urlString delegate:self tag:0];
    [urlConnection release];
    
    [self.indicator startAnimating];
    self.indicator.hidden = NO;
    self.loadingImageView.hidden = NO;
}

- (void)dealloc{
    [urlString release];
    [bodyScrollView release];
    [indicator release];
    [loadingImageView release];
    [toolBar release];
    [super dealloc];
}

//show result
- (void)urlConnectionDidFinishLoading:(GLURLConnection *)urlConnection{
    NSString *jsonString = [[NSString alloc] initWithData:urlConnection.receivedData encoding:NSUTF8StringEncoding];

    SBJSON *jsonParser = [[SBJSON alloc] init];
    NSError *error = nil;
    self.infoDictionary = [jsonParser objectWithString:jsonString error:&error];
    
    [jsonParser release];
    [jsonString release];
    
    NSLog(@"%@", infoDictionary);
    
    [self configScrollView];

    
    [self.indicator stopAnimating];
    self.indicator.hidden = YES;
    self.loadingImageView.hidden = YES;
} 

- (void)urlConnection:(GLURLConnection *)urlConnection didFailWithError:(NSError *)error{
    self.indicator.hidden = YES;
    [self.indicator stopAnimating];
    self.loadingImageView.hidden = YES;
    
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"网络连接失败" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"刷新", nil];
    [alterView show];
    [alterView release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        NSDictionary *tempDic = [[NSDictionary alloc] init];
        self.infoDictionary = tempDic;
        [tempDic release];
        
        GLURLConnection *urlConnection = [[GLURLConnection alloc] initWithURLString:urlString delegate:self tag:0];
        [urlConnection release];
        
        [self.indicator startAnimating];
        self.indicator.hidden = NO;
        self.loadingImageView.hidden = NO;
    }
}

-(void)configScrollView{    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"]; 
    NSDictionary *colorDic= [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"NewsViewConfig"];
    
    //配置title
    NSString *title = [infoDictionary objectForKey:@"title"];////////////////////改过
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 300, 40)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 280, 42)];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.text = title;
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    titleLabel.numberOfLines = 2;
    titleLabel.shadowColor = [UIColor whiteColor];
    titleLabel.shadowOffset = CGSizeMake(0, 1);
    
    NSArray *titleColor = [colorDic objectForKey:@"BodyTitleColor"];
    float titleRed = [[titleColor objectAtIndex:0] floatValue]/255;
    float titleGreen = [[titleColor objectAtIndex:1] floatValue]/255;
    float titleBlue = [[titleColor objectAtIndex:2] floatValue]/255;
    float titleAlpha = [[titleColor objectAtIndex:3] floatValue];
    titleLabel.textColor = [UIColor colorWithRed:titleRed green:titleGreen blue:titleBlue alpha:titleAlpha];
    
    [self.bodyScrollView addSubview:titleLabel];
    [titleLabel release];
    
    //配置Date
//    int titleHeight = 20;
//    
//    if ([[infoDictionary objectForKey:@"title"] length] > 15) {
//        titleHeight = 40;
//    }
    NSString *date = [infoDictionary objectForKey:@"created_at"];
//    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(228, 53, 320, 10)];
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 63, 320, 12)];//////63

    timeLabel.textAlignment = UITextAlignmentCenter;
    timeLabel.text = date;
    timeLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textColor = [UIColor grayColor];
    timeLabel.numberOfLines = 1;
    
    NSArray *dateColor = [colorDic objectForKey:@"BodyDateColor"];
    float dateRed = [[dateColor objectAtIndex:0] floatValue]/255;
    float dateGreen = [[dateColor objectAtIndex:1] floatValue]/255;
    float dateBlue = [[dateColor objectAtIndex:2] floatValue]/255;
    float dateAlpha = [[dateColor objectAtIndex:3] floatValue];
    timeLabel.textColor = [UIColor colorWithRed:dateRed green:dateGreen blue:dateBlue alpha:dateAlpha];
    
    [self.bodyScrollView addSubview:timeLabel];
    [timeLabel release];
    
    //配置分隔线
    UIImageView *seperatorView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 85, 280, 1)];/////65
    NSArray *sepColor = [colorDic objectForKey:@"BodySeperator"];
    float sepRed = [[sepColor objectAtIndex:0] floatValue]/255;
    float sepGreen = [[sepColor objectAtIndex:1] floatValue]/255;
    float sepBlue = [[sepColor objectAtIndex:2] floatValue]/255;
    float sepAlpha = [[sepColor objectAtIndex:3] floatValue];
    seperatorView.backgroundColor = [UIColor colorWithRed:sepRed green:sepGreen blue:sepBlue alpha:sepAlpha];
    [self.bodyScrollView addSubview:seperatorView];
    [seperatorView release];
    
    //配置图片
    
    int imageHeight = 0;
    
    if ([[infoDictionary objectForKey:@"photo_url"] length] > 0) {
        imageHeight = 184;
    }
    
    NSURL *url = [NSURL URLWithString:[infoDictionary objectForKey:@"photo_url"]];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(13.5, 100, 295, imageHeight)];
    if ([imageData length] > 0) {
        imageView.image = [UIImage imageWithData:imageData];
    }
    else{
        //TO DO: fill blank image here
        //item.image = [UIImage imageNamed:@""];
    }
    
    [self.bodyScrollView addSubview:imageView];
    [imageView release];
    
    //配置body
    NSString *body = [infoDictionary objectForKey:@"content"];
    CGSize bodyLabelSize = [self getProperSizeForLabel:body setTextFont:[UIFont fontWithName:@"Helvetica" size:16]];
    UITextView *bodyTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 110+imageHeight, 310, bodyLabelSize.height)];
    bodyTextView.text = body;
    bodyTextView.font = [UIFont fontWithName:@"Helvetica" size:16];
    bodyTextView.backgroundColor = [UIColor clearColor];
    bodyTextView.editable = NO;
    bodyTextView.scrollEnabled = NO;
    
    NSArray *conentColor = [colorDic objectForKey:@"BodyContentColor"];
    float contentRed = [[conentColor objectAtIndex:0] floatValue]/255;
    float contentGreen = [[conentColor objectAtIndex:1] floatValue]/255;
    float contentBlue = [[conentColor objectAtIndex:2] floatValue]/255;
    float contentAlpha = [[conentColor objectAtIndex:3] floatValue];
    bodyTextView.textColor = [UIColor colorWithRed:contentRed green:contentGreen blue:contentBlue alpha:contentAlpha];
    
    [self.bodyScrollView addSubview:bodyTextView];
    [bodyTextView release];

    [self.bodyScrollView setContentSize:CGSizeMake(320, 120+imageHeight+bodyLabelSize.height)];
}

-(IBAction)reviewButtonPressed{
    ReviewViewController *viewController = [[ReviewViewController alloc] init];
    viewController.reviewURL = [self.infoDictionary objectForKey:@"comments_url"];
    [self presentModalViewController:viewController animated:YES];
    [viewController release];
}

-(IBAction)shareButtonPressed{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"新浪微博", @"短信", @"电子邮件", nil];
    [actionSheet showInView:self.bodyScrollView];
    [actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        //已经登陆了
        if ([defaults objectForKey:WeiboIDKey]) {
            WBSendView *sendView = [[WBSendView alloc] initWithAppKey:SinaWeiBoKey appSecret:SinaWeiBoSecret text:[infoDictionary objectForKey:@"title"] image:nil];
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
                picker.body = [infoDictionary objectForKey:@"title"];
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
            [controller setMessageBody:[infoDictionary objectForKey:@"content"] isHTML:NO];
            [controller setSubject:[infoDictionary objectForKey:@"title"]];
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

//根据文字内容,判断label大小
- (CGSize)getProperSizeForLabel:(NSString *)text setTextFont:(UIFont *)textFont {
	//设置最大限度
	CGSize maximumLabelSize = CGSizeMake(190,10000);
	
	//预判label大小
	CGSize expectedLabelSize = [text	
								sizeWithFont:textFont
								constrainedToSize:maximumLabelSize 
								lineBreakMode:UILineBreakModeTailTruncation]; 
    
    expectedLabelSize.height = expectedLabelSize.height + 10;
	
	return expectedLabelSize;
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

@end
