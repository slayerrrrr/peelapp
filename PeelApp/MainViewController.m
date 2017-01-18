//
//  MainViewController.m
//  PeelApp
//
//  Created by Peelapp on 12-4-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "JSON.h"
#import "Constant.h"

@interface MainViewController()
@property(nonatomic, assign) QueryType queryType;

-(void)configHomePageScrollViewWithIndex:(int)index withImageData:(NSData *)data;
@end

@implementation MainViewController
@synthesize queryType;
@synthesize photoCount, photoReturnedCount;
@synthesize photoDictionary;
@synthesize homePhotoScrollView, pageControl;
@synthesize loadingImageView, actIndicator;

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
        
        NSString *MainViewTabBarName = [[[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"AppTabBarNameConfig"] objectForKey:@"MainViewController"];
        
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400, 44)] autorelease];
        label.text = MainViewTabBarName;
        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:navTitleRed green:navTitleGreen blue:navTitleBlue alpha:navTitleAlpha];
        self.navigationItem.titleView = label;
        
        self.title = MainViewTabBarName;
        self.tabBarItem.image = [UIImage imageNamed:@"mainView_tab_icon.png"];
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.loadingImageView.hidden = NO;
    self.actIndicator.hidden = NO;
    [self.actIndicator startAnimating];
    
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
    self.photoDictionary = tempDic;
    [tempDic release];
    
    NSString *homeURL = [NSString stringWithFormat:homePageURL, APP_ID];
    
    GLURLConnection *urlConnection = [[GLURLConnection alloc] initWithURLString:homeURL delegate:self tag:ImageAddressQuery];
    [urlConnection release];
    
    NSLog(@"%@", homeURL);
}

-(void)dealloc{
    [photoDictionary release];
    [homePhotoScrollView release];
    [pageControl release];
    [loadingImageView release];
    [actIndicator release];
    
    [super dealloc];
}

-(void)configHomePageScrollViewWithIndex:(int)index withImageData:(NSData *)data{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(320*index, 0, 320, 367)];
    imageView.image = [UIImage imageWithData:data];
    [self.homePhotoScrollView addSubview:imageView];
    [imageView release];
}

#pragma mark - Connection Delegate
- (void)urlConnectionDidFinishLoading:(GLURLConnection *)urlConnection{
    self.loadingImageView.hidden = YES;
    self.actIndicator.hidden = YES;
    [self.actIndicator stopAnimating];
    
    if (urlConnection.tag == ImageAddressQuery) {
        NSString *jsonString = [[NSString alloc] initWithData:urlConnection.receivedData encoding:NSUTF8StringEncoding];
        
        SBJSON *jsonParser = [[SBJSON alloc] init];
        NSError *error = nil;
        NSArray *resultArray = [jsonParser objectWithString:jsonString error:&error];
        
        [jsonString release];
        [jsonParser release];
        
        self.photoCount = [resultArray count];
        self.photoReturnedCount = 0;
        self.pageControl.numberOfPages = self.photoCount;
        [self.homePhotoScrollView setContentSize:CGSizeMake(320*photoCount, 367)];
        
        for (int i = 0; i < photoCount; i++) {
            UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            indicator.frame = CGRectMake(140+320*i, 160, 37, 37);
            [indicator startAnimating];
            indicator.hidden = NO;
            [self.homePhotoScrollView addSubview:indicator];
            [indicator release];
        }
        
        for (int i = 1; i <= [resultArray count]; i++) {
            NSString *urlString = [[resultArray objectAtIndex:i-1] objectForKey:@"photo_url"];
            GLURLConnection *urlConnection = [[GLURLConnection alloc] initWithURLString:urlString delegate:self tag:i];
            [urlConnection release];
        }
    }
    else{
        self.photoReturnedCount++;
        [self configHomePageScrollViewWithIndex:urlConnection.tag-1 withImageData:urlConnection.receivedData];
    }
}

- (void)urlConnection:(GLURLConnection *)urlConnection didFailWithError:(NSError *)error{
    self.loadingImageView.hidden = YES;
    self.actIndicator.hidden = YES;
    [self.actIndicator stopAnimating];
    
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"网络连接失败" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"刷新", nil];
    [alterView show];
    [alterView release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
        self.photoDictionary = tempDic;
        [tempDic release];
        
        self.loadingImageView.hidden = NO;
        self.actIndicator.hidden = NO;
        [self.actIndicator startAnimating];
        
        GLURLConnection *urlConnection = [[GLURLConnection alloc] initWithURLString:homePageURL delegate:self tag:ImageAddressQuery];
        [urlConnection release];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)myScrollView{
	CGFloat pageWidth = homePhotoScrollView.frame.size.width;
    int page = floor((homePhotoScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
}

@end
