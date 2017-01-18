//
//  NewsViewController.m
//  PeelApp
//
//  Created by Peelapp on 12-4-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewsViewController.h"
#import "Constant.h"
#import "NewsTableViewCell.h"
#import "JSON.h"
#import "AppDelegate.h"
#import "BodyViewController.h"

@implementation NewsViewController
@synthesize listTableView;
@synthesize dataArray;
@synthesize queryIndex;
@synthesize bgImageView;
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
        
        NSString *NewsViewTabBarName = [[[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"AppTabBarNameConfig"] objectForKey:@"NewsViewController"];
        
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400, 44)] autorelease];
        label.text = NewsViewTabBarName;
        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:navTitleRed green:navTitleGreen blue:navTitleBlue alpha:navTitleAlpha];
        self.navigationItem.titleView = label;

        self.title = NewsViewTabBarName;
        self.tabBarItem.image = [UIImage imageNamed:@"newsView_tab_icon.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //add empty button
    UIButton *emptyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [emptyButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];        
    emptyButton.frame = CGRectMake(0, 0, 34, 34);
    [emptyButton setBackgroundImage:nil forState:UIControlStateNormal];
    
    UIBarButtonItem *emptyBarButton = [[UIBarButtonItem alloc] initWithCustomView:emptyButton];
    self.navigationItem.leftBarButtonItem = emptyBarButton;
    [emptyBarButton release];
    
    //add refresh button
    UIButton *refreshButtonView = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshButtonView addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    refreshButtonView.frame = CGRectMake(0, 0, 34, 34);
    [refreshButtonView setImage:[UIImage imageNamed:@"news_refresh_button.png"] forState:UIControlStateNormal];
    
    UIBarButtonItem *refreshBarButton = [[UIBarButtonItem alloc] initWithCustomView:refreshButtonView];
    self.navigationItem.rightBarButtonItem = refreshBarButton;
    [refreshBarButton release];
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"]; 
    NSDictionary *colorDictionary = [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"NewsViewConfig"];
    
    //配table seperator颜色
    NSArray *seperatorColor = [colorDictionary objectForKey:@"TableCellSeperator"];
    float seperatorRed = [[seperatorColor objectAtIndex:0] floatValue]/255;
    float seperatorGreen = [[seperatorColor objectAtIndex:1] floatValue]/255;
    float seperatorBlue = [[seperatorColor objectAtIndex:2] floatValue]/255;
    float seperatorAlpha = [[seperatorColor objectAtIndex:3] floatValue];
    self.listTableView.separatorColor = [UIColor colorWithRed:seperatorRed green:seperatorGreen blue:seperatorBlue alpha:seperatorAlpha];
    
    self.listTableView.backgroundColor = [UIColor clearColor];
    
    [self refresh];
}

- (void)dealloc
{
    [listTableView release];
    [dataArray release];
    [bgImageView release];
    [indicator release];
    [loadingImageView release];

    [super dealloc];
}

#pragma mark - Custom Method
- (void)refresh {
    self.queryIndex = 0;
    self.loadingImageView.hidden = NO;
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
    self.listTableView.hidden = YES;
    
    [self.listTableView setContentOffset:CGPointZero animated:NO];
    
    NSString *urlString  = [[NSString stringWithFormat:newsPageURL, APP_ID, self.queryIndex] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    GLURLConnection *urlConnection = [[GLURLConnection alloc] initWithURLString:urlString delegate:self tag:0];
    [urlConnection release];
    
    NSLog(@"News URL: %@", urlString);
}

//show result
- (void)urlConnectionDidFinishLoading:(GLURLConnection *)urlConnection{
    NSString *jsonString = [[NSString alloc] initWithData:urlConnection.receivedData encoding:NSUTF8StringEncoding];
	
	SBJSON *jsonParser = [[SBJSON alloc] init];
	NSError *error = nil;
    
    if (urlConnection.tag == 0) {
        self.dataArray = [jsonParser objectWithString:jsonString error:&error];
    }
    else{
        [self.dataArray addObjectsFromArray:[jsonParser objectWithString:jsonString error:&error]];
    }
	
    //NSLog(@"%@", dataArray);
    self.loadingImageView.hidden = YES;
    self.indicator.hidden = YES;
    [self.indicator stopAnimating];
    
    self.listTableView.hidden = NO;
    [self.listTableView reloadData];
    
    [jsonParser release];
    [jsonString release];
} 

- (void)urlConnection:(GLURLConnection *)urlConnection didFailWithError:(NSError *)error{
    self.loadingImageView.hidden = YES;
    self.indicator.hidden = YES;
    [self.indicator stopAnimating];
    
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"网络连接失败" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"刷新", nil];
    [alterView show];
    [alterView release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        self.queryIndex = 0;
        [self refresh];
    }
}

-(void)showMore{
    self.queryIndex = self.queryIndex + 20;
    
    NSString *urlString  = [[NSString stringWithFormat:newsPageURL, APP_ID, self.queryIndex] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    GLURLConnection *urlConnection = [[GLURLConnection alloc] initWithURLString:urlString delegate:self tag:1];
    [urlConnection release];
    
    NSLog(@"News URL: %@", urlString);
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.dataArray count] == self.queryIndex+20) {
        return [self.dataArray count]+1;
    }
    else{
        return [self.dataArray count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  if (indexPath.row == [self.dataArray count]) {
        return 60;
    }
    else{
        return 44;
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //show more cell
    if (indexPath.row == [self.dataArray count]) {
        static NSString *cellIdentifier = @"cellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (indexPath.section == 0) {
            //初始化cell
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 
                                               reuseIdentifier: cellIdentifier] autorelease];
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([[cell.contentView subviews] count] == 0) {
            UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, 279, 40)];
            moreButton.backgroundColor = [UIColor clearColor];
            [moreButton addTarget:self action:@selector(showMore) forControlEvents:UIControlEventTouchUpInside];
            [moreButton setImage:[UIImage imageNamed:@"newsAddMoreButton.png"] forState:UIControlStateNormal];
            [cell.contentView addSubview:moreButton];
            [moreButton release];
        }
        
        return cell;
    }
    
    //normal cells
    else{
        static NSString *CellIdentifier = @"NewsTableViewCell";
        NewsTableViewCell *cell = (NewsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        if (cell == nil) { 
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NewsTableViewCell" owner:self options:nil];
            for (id oneObject in nib) if ([oneObject isKindOfClass:[NewsTableViewCell class]]){
                cell = (NewsTableViewCell *)oneObject;
                
                NSString *path = [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"]; 
                NSDictionary *colorDic= [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"NewsViewConfig"];
                
                //配置cell text颜色
                NSArray *titleColor = [colorDic objectForKey:@"TableCellTitleColor"];
                float titleRed = [[titleColor objectAtIndex:0] floatValue]/255;
                float titleGreen = [[titleColor objectAtIndex:1] floatValue]/255;
                float titleBlue = [[titleColor objectAtIndex:2] floatValue]/255;
                float titleAlpha = [[titleColor objectAtIndex:3] floatValue];
                cell.titleLabel.textColor = [UIColor colorWithRed:titleRed green:titleGreen blue:titleBlue alpha:titleAlpha];
                
                //配置cell date颜色
                NSArray *dateColor = [colorDic objectForKey:@"TableCellDateColor"];
                float dateRed = [[dateColor objectAtIndex:0] floatValue]/255;
                float dateGreen = [[dateColor objectAtIndex:1] floatValue]/255;
                float dateBlue = [[dateColor objectAtIndex:2] floatValue]/255;
                float dateAlpha = [[titleColor objectAtIndex:3] floatValue];
                cell.dateLabel.textColor = [UIColor colorWithRed:dateRed green:dateGreen blue:dateBlue alpha:dateAlpha];
            }
        }
        
        cell.titleLabel.text = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"title"];
        cell.dateLabel.text = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"created_at"];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //点击之后取消反显效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < [dataArray count]) {
        BodyViewController *viewController = [[BodyViewController alloc] init];
        viewController.urlString = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"url"];
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
}

@end
