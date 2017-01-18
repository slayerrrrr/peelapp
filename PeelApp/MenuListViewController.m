//
//  MenuListViewController.m
//  PeelApp
//
//  Created by Gaffrey on 12-8-13.
//  Copyright (c) 2012年 Peelapp. All rights reserved.
//

#import "MenuListViewController.h"
#import "JSON.h"
#import "MenuListTableViewCell.h"
#import "MenuDetailViewController.h"

@interface MenuListViewController()
-(void)configNavigationBar;
@end

@implementation MenuListViewController
@synthesize infoDic;
@synthesize menuListTableView;
@synthesize dataArray;
@synthesize imageDic;
@synthesize loadingImageView, actIndicator;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.loadingImageView.hidden = NO;
    self.actIndicator.hidden = NO;
    [self.actIndicator startAnimating];
    
    self.menuListTableView.hidden = YES;
    
    NSString *urlString  = [[infoDic objectForKey:@"url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    GLURLConnection *urlConnection = [[GLURLConnection alloc] initWithURLString:urlString delegate:self tag:0];
    [urlConnection release];
    NSLog(@"Menu List URL: %@", [infoDic objectForKey:@"url"]);
    
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
    self.imageDic = tempDic;
    [tempDic release];
    
    [self configNavigationBar];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"]; 
    NSDictionary *colorDic= [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"MenuViewConfig"];
    
    //配置cell seperator颜色
    NSArray *sepTitleColor = [colorDic objectForKey:@"MenuListViewTableCellSeperatorColor"];
    float sepTitleRed = [[sepTitleColor objectAtIndex:0] floatValue]/255;
    float sepTitleGreen = [[sepTitleColor objectAtIndex:1] floatValue]/255;
    float sepTitleBlue = [[sepTitleColor objectAtIndex:2] floatValue]/255;
    float sepTitleAlpha = [[sepTitleColor objectAtIndex:3] floatValue];
    menuListTableView.separatorColor = [UIColor colorWithRed:sepTitleRed green:sepTitleGreen blue:sepTitleBlue alpha:sepTitleAlpha];
}

- (void)dealloc
{
    [infoDic release];
    [menuListTableView release];
    [dataArray release];
    [imageDic release];
    [loadingImageView release];
    [actIndicator release];
    [super dealloc];
}

#pragma mark - Custom Method
-(void)configNavigationBar{
    self.title = @"列表";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"]; 
    NSDictionary *colorDic = [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"AppColorConfig"];
    
    NSArray *navTitleArray = [colorDic objectForKey:@"NavigationBarTitleColor"];
    float navTitleRed = [[navTitleArray objectAtIndex:0] floatValue]/255.0;
    float navTitleGreen = [[navTitleArray objectAtIndex:1] floatValue]/255.0;
    float navTitleBlue = [[navTitleArray objectAtIndex:2] floatValue]/255.0;
    float navTitleAlpha = [[navTitleArray objectAtIndex:3] floatValue];
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400, 44)] autorelease];
    label.text = @"列表";
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

-(void)downloadImage:(int)index{
    NSDictionary *item = [self.dataArray objectAtIndex:index];
    
    if ([[item objectForKey:@"photo_url"] isKindOfClass:[NSNull class]]) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:[item objectForKey:@"photo_url"]];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    
    if ([imageData length] > 0) {
        [imageDic setObject:[UIImage imageWithData:imageData] forKey:[item objectForKey:@"id"]];
    }
    else{
        //把default照片放在这里
        //item.image = [UIImage imageNamed:@"barcode_favorite_no_result.png"];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        MenuListTableViewCell *itemCell = (MenuListTableViewCell *)[menuListTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        [itemCell.imageView setImage:[UIImage imageWithData:imageData]];
    });
}

- (void)loadImagesForOnscreenRows{
    if ([self.dataArray count] > 0){
        NSArray *visiblePaths = [self.menuListTableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths){
            NSDictionary *item = [self.dataArray objectAtIndex:indexPath.row];
            
            if (![self.imageDic objectForKey:[item objectForKey:@"id"]]){
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [self downloadImage:indexPath.row];
                });
            }
        }
    }
}

#pragma mark - GLConnection Delegate
- (void)urlConnectionDidFinishLoading:(GLURLConnection *)urlConnection{
    self.loadingImageView.hidden = YES;
    self.actIndicator.hidden = YES;
    [self.actIndicator stopAnimating];
    
    self.menuListTableView.hidden = NO;
    
    NSString *jsonString = [[NSString alloc] initWithData:urlConnection.receivedData encoding:NSUTF8StringEncoding];
	SBJSON *jsonParser = [[SBJSON alloc] init];
	NSError *error = nil;
    
    self.dataArray = [jsonParser objectWithString:jsonString error:&error];
	NSLog(@"%@",self.dataArray);
    
    [jsonParser release];
    [jsonString release];
    
    [self.menuListTableView reloadData];
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
        
        NSString *urlString  = [[infoDic objectForKey:@"url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        GLURLConnection *urlConnection = [[GLURLConnection alloc] initWithURLString:urlString delegate:self tag:0];
        [urlConnection release];
    }
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MenuListTableViewCell";
    MenuListTableViewCell *cell = (MenuListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) { 
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MenuListTableViewCell" owner:self options:nil];
        for (id oneObject in nib) if ([oneObject isKindOfClass:[MenuListTableViewCell class]]){
            cell = (MenuListTableViewCell *)oneObject;
            
            NSString *path = [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"]; 
            NSDictionary *colorDic= [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"MenuViewConfig"];
            
            //配置cell title text颜色
            NSArray *titleColor = [colorDic objectForKey:@"MenuListViewTableCellTitleColor"];
            float titleRed = [[titleColor objectAtIndex:0] floatValue]/255;
            float titleGreen = [[titleColor objectAtIndex:1] floatValue]/255;
            float titleBlue = [[titleColor objectAtIndex:2] floatValue]/255;
            float titleAlpha = [[titleColor objectAtIndex:3] floatValue];
            cell.titleLabel.textColor = [UIColor colorWithRed:titleRed green:titleGreen blue:titleBlue alpha:titleAlpha];
            
            //配置cell subtitle text颜色
            NSArray *subtitleColor = [colorDic objectForKey:@"MenuListViewTableCellSubtitleColor"];
            float subtitleRed = [[subtitleColor objectAtIndex:0] floatValue]/255;
            float subtitleGreen = [[subtitleColor objectAtIndex:1] floatValue]/255;
            float subtitleBlue = [[subtitleColor objectAtIndex:2] floatValue]/255;
            float subtitleAlpha = [[subtitleColor objectAtIndex:3] floatValue];
            cell.subtitleLabel.textColor = [UIColor colorWithRed:subtitleRed green:subtitleGreen blue:subtitleBlue alpha:subtitleAlpha];
            
            //配置cell price text颜色
            NSArray *priceColor = [colorDic objectForKey:@"MenuListViewTableCellPriceColor"];
            float priceRed = [[priceColor objectAtIndex:0] floatValue]/255;
            float priceGreen = [[priceColor objectAtIndex:1] floatValue]/255;
            float priceBlue = [[priceColor objectAtIndex:2] floatValue]/255;
            float priceAlpha = [[priceColor objectAtIndex:3] floatValue];
            cell.priceLabel.textColor = [UIColor colorWithRed:priceRed green:priceGreen blue:priceBlue alpha:priceAlpha];
        }
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if ([[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"title"]) {
        cell.titleLabel.text = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    }
    
    if (![[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"subtitle"] isKindOfClass:[NSNull class]]) {
        cell.subtitleLabel.text = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"subtitle"];
    }
    
    
    float price = [[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"price"] floatValue];
    if (price > 0) {
        cell.priceLabel.text = [NSString stringWithFormat:@"￥%g", price];
    }
    
    NSString *itemID = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"id"];
    if ([self.imageDic objectForKey:itemID]) {
        cell.imageView.image = [self.imageDic objectForKey:itemID];
    }
    else{
        cell.imageView.image = [UIImage imageNamed:@"menu_list_default"];
        if (menuListTableView.decelerating == NO) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [self downloadImage:indexPath.row];
            });
        }
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MenuDetailViewController *controller = [[MenuDetailViewController alloc] init];
    controller.urlString = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"url"];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}


@end
