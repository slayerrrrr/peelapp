//
//  PhotoItemViewController.m
//  PeelApp
//
//  Created by Peelapp on 12-5-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PhotoItemViewController.h"
#import "ReviewViewController.h"
#import "Constant.h"
#import "AppDelegate.h"

@implementation PhotoItemViewController
@synthesize photoArray;
@synthesize photoScrollView;
@synthesize initIndex;
@synthesize imageTitleArray;
@synthesize toolBar;
@synthesize navBar;
@synthesize downloadImageView;

const int viewHeight = 480;

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self performSelector:@selector(initImageView) withObject:nil afterDelay:0.3];
}

- (void)dealloc
{
    self.navigationController.delegate = nil;
    [photoArray release];
    [photoScrollView release];
    [imageTitleArray release];
    [toolBar release];
    [navBar release];
    [downloadImageView release];
    [super dealloc];
}

#pragma mark - Custom Method
-(void)initImageView{
    self.navigationController.navigationBarHidden = YES;
    self.view.frame = CGRectMake(0, -64, 320, 480);
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    self.imageTitleArray = tempArray;
    [tempArray release];
    
    self.photoScrollView.frame = CGRectMake(0, 0, 340, 480);
    
    for (int i = 0; i < [self.photoArray count]; i++) {
        NSDictionary *dic = [self.photoArray objectAtIndex:i];
        
        ImageWithTitleViewController *imageTitleView = [[ImageWithTitleViewController alloc] init];
        imageTitleView.delegate = self;
        imageTitleView.urlString = [dic objectForKey:@"photo_url"];
        
        imageTitleView.view.frame = CGRectMake(340*i, 0, 340, viewHeight);
        imageTitleView.albumImageView.frame = CGRectMake(0, 0, 320, 480);
        
        imageTitleView.albumImageView.image = [UIImage imageNamed:@"photo_detail_default.png"];
        
        imageTitleView.view.tag = i;
        imageTitleView.view.backgroundColor = [UIColor clearColor];
        imageTitleView.titleLabel.hidden = YES;
        imageTitleView.frameImageView.hidden = YES;
        [imageTitleView.indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [imageTitleView.photoScrollView addSubview:imageTitleView.albumImageView];
        
        [self.photoScrollView addSubview:imageTitleView.view];        
        [self.imageTitleArray addObject:imageTitleView];
        [imageTitleView release];
    }
    
    [self.photoScrollView setContentSize:CGSizeMake(340*[self.imageTitleArray count], 460)];
    [self.photoScrollView setContentOffset:CGPointMake(340*initIndex, 0) animated:NO];
    self.title = [NSString stringWithFormat:@"%d/%d", initIndex+1, [self.photoArray count]];
    
    self.navBar.topItem.title = [NSString stringWithFormat:@"%d/%d", initIndex+1, [self.photoArray count]]; 
}

-(IBAction)saveIntoPhotoLibrary{
    UIImage *image = [[[self.imageTitleArray objectAtIndex:initIndex] albumImageView] image];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), self);
}

-(IBAction)reviewButtonPressed{
    NSLog(@"%@", self.photoArray);
    
    ReviewViewController *viewController = [[ReviewViewController alloc] init];
    viewController.delegate = self;
    viewController.reviewURL = [[self.photoArray objectAtIndex:initIndex] objectForKey:@"comments_url"];
    [self presentModalViewController:viewController animated:YES];
    [viewController release];
}

-(IBAction)cancelButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

-(IBAction)shareButtonPressed{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"新浪微博", @"电子邮件", nil];
    [actionSheet showInView:self.view];
    [actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        //已经登陆了
        if ([defaults objectForKey:WeiboIDKey]) {
            UIImage * image = [[[imageTitleArray objectAtIndex:initIndex] albumImageView] image];
            WBSendView *sendView = [[WBSendView alloc] initWithAppKey:SinaWeiBoKey appSecret:SinaWeiBoSecret text:nil image:image];
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

    else if(buttonIndex == 1){
        //判断是否可以发布mail
        if( [MFMailComposeViewController canSendMail] ){
            //用MFMailComposeViewController推进到发送电子邮件界面
            MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
            controller.mailComposeDelegate = self;
            
            //设定电子邮件的内容
            [controller setMessageBody:[[imageTitleArray objectAtIndex:initIndex] urlString] isHTML:NO];
            
            UIImage * image = [[[imageTitleArray objectAtIndex:initIndex] albumImageView] image];
            [controller addAttachmentData:UIImageJPEGRepresentation(image, 1) mimeType:@"image/jpeg" fileName:@"MyFile.jpeg"];
            
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

-(void)reviewViewControllerDoneButtonDidPressed:(ReviewViewController *)reviewViewController{
    navBar.frame = CGRectMake(0, 0, 320, 44);
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
	[self dismissModalViewControllerAnimated:YES];	
    navBar.frame = CGRectMake(0, 0, 320, 44);
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self dismissModalViewControllerAnimated:YES];
    navBar.frame = CGRectMake(0, 0, 320, 44);
}

#pragma mark - Delegate
- (void)scrollViewDidScroll:(UIScrollView *)myScrollView{
	CGFloat pageWidth = myScrollView.frame.size.width;
    int page = floor((myScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.title = [NSString stringWithFormat:@"%d/%d", page+1, [self.photoArray count]];
    
    if (page < 0 || page >= [self.imageTitleArray count]) {
        return;
    }
    
    if (self.initIndex != page) {
        [[self.imageTitleArray objectAtIndex:page] resetScrollView];
        self.initIndex = page;
        
        self.navBar.topItem.title = [NSString stringWithFormat:@"%d/%d", initIndex+1, [self.photoArray count]]; 
    }
    
    if (self.view.tag == 1) {
        self.view.tag = 0;
        
        [UIView beginAnimations:@"pushOut" context:nil];
        [UIView setAnimationDuration:0.3];
        self.toolBar.alpha = 0;
        self.navBar.alpha = 0;
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        [UIView commitAnimations];
    }
}

-(void)imageDidSeleted:(ImageWithTitleViewController *)imageWithTitleViewController{
    if (self.view.tag == 0) {
        self.view.tag = 1;
        
        [UIView beginAnimations:@"pushOut" context:nil];
        [UIView setAnimationDuration:0.3];
        self.toolBar.alpha = 1;
        self.navBar.alpha = 1;
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [UIView commitAnimations];
        
    }
    else{
        self.view.tag = 0;
        
        [UIView beginAnimations:@"pushOut" context:nil];
        [UIView setAnimationDuration:0.3];
        self.toolBar.alpha = 0;
        self.navBar.alpha = 0;
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        [UIView commitAnimations];
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    self.downloadImageView.hidden = NO;
    self.downloadImageView.alpha = 1;
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideDownloadImageView) userInfo:nil repeats:NO];
}

-(void)hideDownloadImageView{
    [UIView beginAnimations:@"savePhotoAnimation" context:nil];
	[UIView setAnimationDuration:0.5];
	self.downloadImageView.alpha = 0;
	[UIView commitAnimations];
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
