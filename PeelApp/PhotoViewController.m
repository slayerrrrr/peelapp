//
//  PhotoViewController.m
//  PeelApp
//
//  Created by Peelapp on 12-4-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PhotoViewController.h"
#import "Constant.h"
#import "SBJSON.h"
#import "PhotoListViewController.h"
#import "AppDelegate.h"

@implementation PhotoViewController
@synthesize albumScrollView;
@synthesize imageTitleArray, resultArray;
@synthesize indicator, loadingImageView;

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
        
        NSString *PhotoViewTabBarName = [[[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"AppTabBarNameConfig"] objectForKey:@"PhotoViewController"];
        
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400, 44)] autorelease];
        label.text = PhotoViewTabBarName;
        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:navTitleRed green:navTitleGreen blue:navTitleBlue alpha:navTitleAlpha];
        self.navigationItem.titleView = label;
        
        self.title = PhotoViewTabBarName;
        self.tabBarItem.image = [UIImage imageNamed:@"photoView_tab_icon.png"];
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    self.imageTitleArray = tempArray;
    [tempArray release];
    
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
    self.loadingImageView.hidden = NO;
    
    NSString *albumURL = [NSString stringWithFormat:albumPageURL, APP_ID];
    
    GLURLConnection *urlConnection = [[GLURLConnection alloc] initWithURLString:albumURL delegate:self tag:0];
    [urlConnection release];
}

-(void)dealloc{
    self.navigationController.delegate = nil;
    [albumScrollView release];
    [indicator release];
    [loadingImageView release];
    [imageTitleArray release];
    [resultArray release];
    [super dealloc];
}

#pragma mark - Connection Delegate
- (void)urlConnectionDidFinishLoading:(GLURLConnection *)urlConnection{
    self.indicator.hidden = YES;
    [self.indicator stopAnimating];
    self.loadingImageView.hidden = YES;
    
    NSString *jsonString = [[NSString alloc] initWithData:urlConnection.receivedData encoding:NSUTF8StringEncoding];
    
    SBJSON *jsonParser = [[SBJSON alloc] init];
    NSError *error = nil;
    self.resultArray = [jsonParser objectWithString:jsonString error:&error];
    [jsonString release];
    [jsonParser release];
    
    [self.albumScrollView setContentSize:CGSizeMake(320, 20+150 * ([resultArray count]/2+[resultArray count]%2))];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"]; 
    NSDictionary *colorDic = [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"PhotoViewConfig"];
    
    NSArray *textColorArray = [colorDic objectForKey:@"textColor"];
    float titleRed = [[textColorArray objectAtIndex:0] floatValue]/255.0;
    float titleGreen = [[textColorArray objectAtIndex:1] floatValue]/255.0;
    float titleBlue = [[textColorArray objectAtIndex:2] floatValue]/255.0;
    float titleAlpha = [[textColorArray objectAtIndex:3] floatValue];
    
    for (int i = 0; i < [resultArray count]; i++) {
        int position = i%2;
        int row = i/2;
        
        NSDictionary *dic = [resultArray objectAtIndex:i];
        
        ImageWithTitleViewController *imageTitleView = [[ImageWithTitleViewController alloc] init];
        imageTitleView.delegate = self;
        imageTitleView.urlString = [dic objectForKey:@"photo_url"];
//        imageTitleView.view.frame = CGRectMake(16 + position*151, 15 + row*150, 136, 136);
        imageTitleView.view.frame = CGRectMake(7 + position*157, 6 + row*150, 150, 150);
        imageTitleView.view.tag = i;
        imageTitleView.frameImageView.image = [UIImage imageNamed:@"album_frame.png"];
        imageTitleView.albumImageView.image = [UIImage imageNamed:@"album_default.png"];
        
        imageTitleView.titleLabelBgImageView.hidden = NO;
        imageTitleView.titleLabel.textColor = [UIColor colorWithRed:titleRed green:titleGreen blue:titleBlue alpha:titleAlpha];
        
        imageTitleView.titleLabel.text = [dic objectForKey:@"title"];
        [self.albumScrollView addSubview:imageTitleView.view];
        
        [self.imageTitleArray addObject:imageTitleView];
        imageTitleView.photoScrollView.maximumZoomScale = 1;
        [imageTitleView release];
    }
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
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        self.imageTitleArray = tempArray;
        [tempArray release];
        
        self.indicator.hidden = NO;
        [self.indicator startAnimating];
        self.loadingImageView.hidden = NO;
        
        GLURLConnection *urlConnection = [[GLURLConnection alloc] initWithURLString:albumPageURL delegate:self tag:0];
        [urlConnection release];
    }
}

-(void)imageDidSeleted:(ImageWithTitleViewController *)imageWithTitleViewController{
    NSDictionary *dic = [resultArray objectAtIndex:imageWithTitleViewController.view.tag];
    
    PhotoListViewController *viewController = [[PhotoListViewController alloc] init];
    viewController.photosURL = [dic objectForKey:@"url"];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}


@end
