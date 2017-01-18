//
//  PhotoListViewController.m
//  PeelApp
//
//  Created by Peelapp on 12-4-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PhotoListViewController.h"
#import "JSON.h"
#import "PhotoItemViewController.h"

const int photoInterval = 6.5;
const int photoWidth = 98;
const int albumWidth = 5;


@implementation PhotoListViewController
@synthesize photoScrollView, photoArray, resultArray;
@synthesize photosURL;
@synthesize indicator, loadingImageView;
@synthesize urlConnection;

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    self.photoArray = tempArray;
    [tempArray release];
    
    NSArray *tempResultArray = [[NSArray alloc] init];
    self.resultArray = tempResultArray;
    [tempResultArray release];
    
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
    self.loadingImageView.hidden = NO;
    
    NSLog(@"url: %@", photosURL);
    
    GLURLConnection *tempConnection = [[GLURLConnection alloc] initWithURLString:photosURL delegate:self tag:0];
    self.urlConnection = tempConnection;
    [tempConnection release];
}

- (void)dealloc
{
    self.navigationController.delegate = nil;
    [self.urlConnection cancel];
    self.urlConnection.delegate = nil;
    
    [urlConnection release];
    [indicator release];
    [loadingImageView release];
    [photoArray release];
    [resultArray release];
    [photoScrollView release];
    [photosURL release];
    [super dealloc];
}

#pragma mark - Connection Delegate
- (void)urlConnectionDidFinishLoading:(GLURLConnection *)aurlConnection{
    self.indicator.hidden = YES;
    [self.indicator stopAnimating];
    self.loadingImageView.hidden = YES;
    
    NSString *jsonString = [[NSString alloc] initWithData:urlConnection.receivedData encoding:NSUTF8StringEncoding];
    
    SBJSON *jsonParser = [[SBJSON alloc] init];
    NSError *error = nil;
    self.resultArray = [jsonParser objectWithString:jsonString error:&error];
    
    //NSLog(@"%@", self.resultArray);
    [jsonParser release];
    [jsonString release];
    
    float height = (photoInterval+photoWidth) * ([resultArray count]/3 + 1) + 10;
    [self.photoScrollView setContentSize:CGSizeMake(320, height)];
    
    for (int i = 0; i < [resultArray count]; i++) {
        int position = i%3;
        int row = i/3;
        
        NSDictionary *dic = [resultArray objectAtIndex:i];
        
        ImageWithTitleViewController *imageTitleView = [[ImageWithTitleViewController alloc] init];
        imageTitleView.delegate = self;
        imageTitleView.urlString = [dic objectForKey:@"thumb_photo_url"];
        imageTitleView.view.frame = CGRectMake(photoInterval + position*(photoWidth+photoInterval), photoInterval + row*(photoWidth+photoInterval), photoWidth, photoWidth);
        
//        imageTitleView.view.frame = CGRectMake(photoInterval + position*(photoWidth+photoInterval), photoInterval + row*(photoWidth+photoInterval), 203, 203);
        
        
        imageTitleView.albumImageView.frame = CGRectMake(albumWidth, albumWidth, photoWidth-albumWidth*2, photoWidth-albumWidth*2);
        imageTitleView.frameImageView.image = [UIImage imageNamed:@"photo_frame.png"];
        imageTitleView.albumImageView.image = [UIImage imageNamed:@"photo_default.png"];
        imageTitleView.view.tag = i;
        
        imageTitleView.titleLabel.hidden = YES;
        [imageTitleView.indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [self.photoScrollView addSubview:imageTitleView.view];
        
        [self.photoArray addObject:imageTitleView];
        imageTitleView.photoScrollView.maximumZoomScale = 1;
        [imageTitleView release];
    }
}

- (void)urlConnection:(GLURLConnection *)aurlConnection didFailWithError:(NSError *)error{
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
        self.photoArray = tempArray;
        [tempArray release];
        
        NSArray *tempResultArray = [[NSArray alloc] init];
        self.resultArray = tempResultArray;
        [tempResultArray release];
        
        self.indicator.hidden = NO;
        [self.indicator startAnimating];
        self.loadingImageView.hidden = NO;
        
        NSLog(@"url: %@", photosURL);
        
        GLURLConnection *tempConnection = [[GLURLConnection alloc] initWithURLString:photosURL delegate:self tag:0];
        self.urlConnection = tempConnection;
        [tempConnection release];
    }
}

-(void)imageDidSeleted:(ImageWithTitleViewController *)imageWithTitleViewController{
    PhotoItemViewController *viewController = [[PhotoItemViewController alloc] init];
    viewController.initIndex = imageWithTitleViewController.view.tag;
    viewController.photoArray = self.resultArray;
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

@end
