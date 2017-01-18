//
//  MenuViewController.m
//  PeelApp
//
//  Created by Gaffrey on 12-8-12.
//  Copyright (c) 2012年 Peelapp. All rights reserved.
//

#import "MenuViewController.h"
#import "Constant.h"
#import "GLURLConnection.h"
#import "JSON.h"
#import "MenuListViewController.h"

@implementation MenuViewController
@synthesize dataArray;
@synthesize menuTableView;
@synthesize loadingImageView, actIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"]; 
        NSString *MenuViewTabBarName = [[[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"AppTabBarNameConfig"] objectForKey:@"MenuViewController"];
        
        NSDictionary *colorDic = [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"AppColorConfig"];
        
        NSArray *navTitleArray = [colorDic objectForKey:@"NavigationBarTitleColor"];
        float navTitleRed = [[navTitleArray objectAtIndex:0] floatValue]/255.0;
        float navTitleGreen = [[navTitleArray objectAtIndex:1] floatValue]/255.0;
        float navTitleBlue = [[navTitleArray objectAtIndex:2] floatValue]/255.0;
        float navTitleAlpha = [[navTitleArray objectAtIndex:3] floatValue];
        
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400, 44)] autorelease];
        label.text = MenuViewTabBarName;
        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:navTitleRed green:navTitleGreen blue:navTitleBlue alpha:navTitleAlpha];
        self.navigationItem.titleView = label;
        
        self.title = MenuViewTabBarName;
        self.tabBarItem.image = [UIImage imageNamed:@"menuView_tab_icon.png"];
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
    
    self.menuTableView.hidden = YES;
    
    NSString *urlString  = [[NSString stringWithFormat:menuPageURL, APP_ID] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    GLURLConnection *urlConnection = [[GLURLConnection alloc] initWithURLString:urlString delegate:self tag:0];
    [urlConnection release];
    
    NSLog(@"Menu URL: %@", urlString);
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"]; 
    NSDictionary *colorDic= [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"MenuViewConfig"];
    
    //配置cell seperator颜色
    NSArray *sepTitleColor = [colorDic objectForKey:@"MenuViewTableCellSeperatorColor"];
    float sepTitleRed = [[sepTitleColor objectAtIndex:0] floatValue]/255;
    float sepTitleGreen = [[sepTitleColor objectAtIndex:1] floatValue]/255;
    float sepTitleBlue = [[sepTitleColor objectAtIndex:2] floatValue]/255;
    float sepTitleAlpha = [[sepTitleColor objectAtIndex:3] floatValue];
    menuTableView.separatorColor = [UIColor colorWithRed:sepTitleRed green:sepTitleGreen blue:sepTitleBlue alpha:sepTitleAlpha];
}

-(void)dealloc{
    [dataArray release];
    [menuTableView release];
    [loadingImageView release];
    [actIndicator release];
    [super dealloc];
}

//show result
- (void)urlConnectionDidFinishLoading:(GLURLConnection *)urlConnection{
    self.loadingImageView.hidden = YES;
    self.actIndicator.hidden = YES;
    [self.actIndicator stopAnimating];
    
    self.menuTableView.hidden = NO;
    
    NSString *jsonString = [[NSString alloc] initWithData:urlConnection.receivedData encoding:NSUTF8StringEncoding];
	
	SBJSON *jsonParser = [[SBJSON alloc] init];
	NSError *error = nil;
    
    self.dataArray = [jsonParser objectWithString:jsonString error:&error];
	//NSLog(@"%@",self.dataArray);
    
    [jsonParser release];
    [jsonString release];
    
    [self. menuTableView reloadData];
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
        
        NSString *urlString  = [[NSString stringWithFormat:menuPageURL, APP_ID] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        GLURLConnection *urlConnection = [[GLURLConnection alloc] initWithURLString:urlString delegate:self tag:0];
        [urlConnection release];
    }
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
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
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"]; 
        NSDictionary *colorDic= [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"MenuViewConfig"];
        
        //配置cell text颜色
        NSArray *titleColor = [colorDic objectForKey:@"MenuViewTableCellTitleColor"];
        float titleRed = [[titleColor objectAtIndex:0] floatValue]/255;
        float titleGreen = [[titleColor objectAtIndex:1] floatValue]/255;
        float titleBlue = [[titleColor objectAtIndex:2] floatValue]/255;
        float titleAlpha = [[titleColor objectAtIndex:3] floatValue];
        cell.textLabel.textColor = [UIColor colorWithRed:titleRed green:titleGreen blue:titleBlue alpha:titleAlpha];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //点击之后取消反显效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MenuListViewController *listView = [[MenuListViewController alloc] init];
    listView.infoDic = [self.dataArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:listView animated:YES];
    [listView release];
}


@end
