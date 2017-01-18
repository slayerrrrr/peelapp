//
//  MenuDetailViewController.m
//  PeelApp
//
//  Created by Gaffrey on 12-8-18.
//  Copyright (c) 2012年 Peelapp. All rights reserved.
//

#import "MenuDetailViewController.h"
#import "SBJSON.h"

@interface MenuDetailViewController()
-(void)configImageScrollView;
@end


@implementation MenuDetailViewController
@synthesize urlString;
@synthesize infoDic;
@synthesize detailScrollView, imageScrollView;
@synthesize pageControl;
@synthesize infoURLConnection, imageURLConnectionArray;
@synthesize loadingImageView, actIndicator;
@synthesize pageControlBg;

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.loadingImageView.hidden = NO;
    self.actIndicator.hidden = NO;
    [self.actIndicator startAnimating];
    
    self.detailScrollView.hidden = YES;
    
    GLURLConnection *tempConnection = [[GLURLConnection alloc] initWithURLString:urlString delegate:self tag:MenuDetailViewImageAddress];
    self.infoURLConnection = tempConnection;
    [tempConnection release];
    
    NSLog(@"%@", urlString);
    
    //配置navigation bar title
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"]; 
    NSDictionary *colorDic = [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"AppColorConfig"];
    
    NSArray *navTitleArray = [colorDic objectForKey:@"NavigationBarTitleColor"];
    float navTitleRed = [[navTitleArray objectAtIndex:0] floatValue]/255.0;
    float navTitleGreen = [[navTitleArray objectAtIndex:1] floatValue]/255.0;
    float navTitleBlue = [[navTitleArray objectAtIndex:2] floatValue]/255.0;
    float navTitleAlpha = [[navTitleArray objectAtIndex:3] floatValue];
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400, 44)] autorelease];
    label.text =  @"详情";
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:navTitleRed green:navTitleGreen blue:navTitleBlue alpha:navTitleAlpha];
    self.navigationItem.titleView = label;
    
    //set empty button to make title in the center
    UIButton *emptyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [emptyButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];        
    emptyButton.frame = CGRectMake(250, 0, 50, 34);
    [emptyButton setBackgroundImage:nil forState:UIControlStateNormal];
    
    UIBarButtonItem *emptyBarButton = [[UIBarButtonItem alloc] initWithCustomView:emptyButton];
    self.navigationItem.rightBarButtonItem = emptyBarButton;
    [emptyBarButton release];
}

- (void)dealloc
{
    [infoURLConnection cancel];
    infoURLConnection.delegate = nil;
    
    for (GLURLConnection *connection in imageURLConnectionArray) {
        [connection cancel];
        connection.delegate = nil;
    }
    
    [urlString release];
    [infoDic release];
    [detailScrollView release];
    [imageScrollView release];
    [pageControl release];
    [imageURLConnectionArray release];
    [loadingImageView release];
    [actIndicator release];
    [pageControlBg release];
    [super dealloc];
}

#pragma mark - GLConnection Delegate
- (void)urlConnectionDidFinishLoading:(GLURLConnection *)urlConnection{
    if (urlConnection.tag == MenuDetailViewImageAddress) {
        self.loadingImageView.hidden = YES;
        self.actIndicator.hidden = YES;
        [self.actIndicator stopAnimating];
        
        self.detailScrollView.hidden = NO;
        
        NSString *jsonString = [[NSString alloc] initWithData:urlConnection.receivedData encoding:NSUTF8StringEncoding];
        SBJSON *jsonParser = [[SBJSON alloc] init];
        NSError *error = nil;
        
        self.infoDic = [jsonParser objectWithString:jsonString error:&error];
        NSLog(@"%@",self.infoDic);
        
        [jsonParser release];
        [jsonString release];
        
        [self configScrollView];
        [self configImageScrollView];
    }
    else{
        int index = urlConnection.tag - 1;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(320*index, 0, 320, 320)];
        imageView.image = [UIImage imageWithData:urlConnection.receivedData];
        [self.imageScrollView addSubview:imageView];
        [imageView release];
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
        self.loadingImageView.hidden = NO;
        self.actIndicator.hidden = NO;
        [self.actIndicator startAnimating];
        
        GLURLConnection *tempConnection = [[GLURLConnection alloc] initWithURLString:urlString delegate:self tag:MenuDetailViewImageAddress];
        self.infoURLConnection = tempConnection;
        [tempConnection release];
    }
}

-(void)configImageScrollView{
    NSArray *imageURLArray = [infoDic objectForKey:@"photos"];
    int photoCount = [imageURLArray count];
    [self.imageScrollView setContentSize:CGSizeMake(320*photoCount, 320)];
    
    self.pageControl.numberOfPages = photoCount;
    
    if (photoCount < 2) {
        self.pageControlBg.hidden = YES;
        self.pageControl.hidden = YES;
    }
    
    for (int i = 0; i < photoCount; i++) {
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicator.frame = CGRectMake(140+320*i, 140, 37, 37);
        [indicator startAnimating];
        indicator.hidden = NO;
        [self.imageScrollView addSubview:indicator];
        [indicator release];
    }
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    self.imageURLConnectionArray = tempArray;
    [tempArray release];
    
    for (int i = 1; i <= photoCount; i++) {
        NSString *photoURLString = [imageURLArray objectAtIndex:i-1];
        GLURLConnection *urlConnection = [[GLURLConnection alloc] initWithURLString:photoURLString delegate:self tag:i];
        [self.imageURLConnectionArray addObject:urlConnection];
        [urlConnection release];;
    }
}

-(void)configScrollView{    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"]; 
    NSDictionary *colorDic= [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"MenuViewConfig"];
    
    //配置price
    NSString *price = [NSString stringWithFormat:@"￥%d", [[infoDic objectForKey:@"price"] intValue]];
    UILabel *priceLabel = [[UILabel alloc] init];
    CGSize priceLabelSize = [self getProperSizeForLabel:price setTextFont:[UIFont fontWithName:@"Helvetica" size:17]];
    priceLabel.frame = CGRectMake(303-priceLabelSize.width, 275, priceLabelSize.width, priceLabelSize.height);
    priceLabel.text = price;
    priceLabel.textColor = [UIColor whiteColor];
    priceLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    priceLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    priceLabel.textAlignment = UITextAlignmentRight;
    [self.detailScrollView addSubview:priceLabel];
    [priceLabel release];
    
    //配置title
    CGSize titleLabelSize = CGSizeZero;
    
    if (![[infoDic objectForKey:@"title"] isKindOfClass:[NSNull class]]) {
        NSString *title = [infoDic objectForKey:@"title"];
        titleLabelSize = [self getProperSizeForLabel:title setTextFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
        titleLabelSize.height = titleLabelSize.height + 10;
        UITextView *titleTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 320, 315, titleLabelSize.height)];
        titleTextView.text = title;
        titleTextView.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        titleTextView.backgroundColor = [UIColor clearColor];
        titleTextView.editable = NO;
        titleTextView.scrollEnabled = NO;
        
        NSArray *titleColor = [colorDic objectForKey:@"MenuDetailViewTitleColor"];
        float titleRed = [[titleColor objectAtIndex:0] floatValue]/255;
        float titleGreen = [[titleColor objectAtIndex:1] floatValue]/255;
        float titleBlue = [[titleColor objectAtIndex:2] floatValue]/255;
        float titleAlpha = [[titleColor objectAtIndex:3] floatValue];
        titleTextView.textColor = [UIColor colorWithRed:titleRed green:titleGreen blue:titleBlue alpha:titleAlpha];
        
        [self.detailScrollView addSubview:titleTextView];
        [titleTextView release];
    }
    
    //配置subtitle
    CGSize subtitleLabelSize = CGSizeZero;
    if (![[infoDic objectForKey:@"subtitle"] isKindOfClass:[NSNull class]]) {
        NSString *subtitle = [infoDic objectForKey:@"subtitle"];
        subtitleLabelSize = [self getProperSizeForLabel:subtitle setTextFont:[UIFont fontWithName:@"Helvetica" size:16]];
        subtitleLabelSize.height = subtitleLabelSize.height + 10;
//        subtitleLabel.lineBreakMode = UILineBreakModeWordWrap;
//        subtitleLabel.numberOfLines = 2;
        UITextView *subtitleTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 323+titleLabelSize.height, 310, subtitleLabelSize.height)];
        subtitleTextView.text = subtitle;
        subtitleTextView.font = [UIFont fontWithName:@"Helvetica" size:16];
        subtitleTextView.backgroundColor = [UIColor clearColor];
        subtitleTextView.editable = NO;
        subtitleTextView.scrollEnabled = NO;
        
        NSArray *subtitleColor = [colorDic objectForKey:@"MenuDetailViewSubtitleColor"];
        float subtitleRed = [[subtitleColor objectAtIndex:0] floatValue]/255;
        float subtitleGreen = [[subtitleColor objectAtIndex:1] floatValue]/255;
        float subtitleBlue = [[subtitleColor objectAtIndex:2] floatValue]/255;
        float subtitleAlpha = [[subtitleColor objectAtIndex:3] floatValue];
        subtitleTextView.textColor = [UIColor colorWithRed:subtitleRed green:subtitleGreen blue:subtitleBlue alpha:subtitleAlpha];
        
        [self.detailScrollView addSubview:subtitleTextView];
        [subtitleTextView release];
    }
    
    //配置分割线
    UIImageView *seperatorLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_detail_seperator.png"]];
    seperatorLine.frame = CGRectMake(0, 333+titleLabelSize.height+subtitleLabelSize.height, 320, 2);
    [self.detailScrollView addSubview:seperatorLine];
    [seperatorLine release];
    
    //配置body
    NSString *body = [infoDic objectForKey:@"description"];
    CGSize bodyLabelSize = [self getProperSizeForLabel:body setTextFont:[UIFont fontWithName:@"Helvetica" size:15]];
    bodyLabelSize.height = bodyLabelSize.height + 10;
    UITextView *bodyTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 336+titleLabelSize.height+subtitleLabelSize.height, 320, bodyLabelSize.height)];
    bodyTextView.text = body;
    bodyTextView.font = [UIFont fontWithName:@"Helvetica" size:15];
    bodyTextView.backgroundColor = [UIColor clearColor];
    bodyTextView.editable = NO;
    bodyTextView.scrollEnabled = NO;
    
    NSArray *bodyColor = [colorDic objectForKey:@"MenuDetailViewBodyColor"];
    float bodyRed = [[bodyColor objectAtIndex:0] floatValue]/255;
    float bodyGreen = [[bodyColor objectAtIndex:1] floatValue]/255;
    float bodyBlue = [[bodyColor objectAtIndex:2] floatValue]/255;
    float bodyAlpha = [[bodyColor objectAtIndex:3] floatValue];
    bodyTextView.textColor = [UIColor colorWithRed:bodyRed green:bodyGreen blue:bodyBlue alpha:bodyAlpha];
    
    [self.detailScrollView addSubview:bodyTextView];
    [bodyTextView release];
    
    [self.detailScrollView setContentSize:CGSizeMake(320, 325+titleLabelSize.height+subtitleLabelSize.height+bodyLabelSize.height)];
}

- (CGSize)getProperSizeForLabel:(NSString *)text setTextFont:(UIFont *)textFont {
	//设置最大限度
	CGSize maximumLabelSize = CGSizeMake(200,10000);
	
	//预判label大小
	CGSize expectedLabelSize = [text	
								sizeWithFont:textFont
								constrainedToSize:maximumLabelSize 
								lineBreakMode:UILineBreakModeTailTruncation]; 
	
	return expectedLabelSize;
}

- (void)scrollViewDidScroll:(UIScrollView *)myScrollView{
	CGFloat pageWidth = imageScrollView.frame.size.width;
    int page = floor((imageScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
}


@end
