//
//  FanWallViewController.m
//  PeelApp
//
//  Created by peelapp  on 12-9-4.
//  Copyright (c) 2012年 Peelapp. All rights reserved.
//

#import "FanWallViewController.h"
#import "Constant.h"
#import "JSON.h"
#import "AppDelegate.h"
#import "ReviewViewController.h"
#import "SBJSON.h"
#import "FanWallTableViewCell.h"

@implementation FanWallViewController
@synthesize dataArray;
//@synthesize listData;


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
        
        NSString *FanWallViewTabBarName = [[[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"AppTabBarNameConfig"] objectForKey:@"FanWallViewController"];
        
        
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400, 44)] autorelease];
        label.text = FanWallViewTabBarName;
        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:navTitleRed green:navTitleGreen blue:navTitleBlue alpha:navTitleAlpha];
        self.navigationItem.titleView = label;
        
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 1)];
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
        [view release];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        [rightBarButtonItem release];
        self.title = FanWallViewTabBarName;
        self.tabBarItem.image = [UIImage imageNamed:@"fanwallView_tab_icon.png"];
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //////////////配置“评论”button
    UIBarButtonItem *reviewButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(reviewButtonPressed)];
    self.navigationItem.rightBarButtonItem = reviewButton;
    [reviewButton release];





////data array resourse
//NSMutableArray *MutableArray = [[NSMutableArray alloc] initWithObjects:@"dayima",@"juhua",@"huaiyun",@"xidangdie",@"diaosi",@"baifumei",@"gaofushuai",@"nixi",
//                  @"beitai",@"luguan",@"diaoyudao",@"zhongnanhai",@"hujintao",@"xijinping",@"wenjiabao",@"quchong",nil];
//    self.dataArray =array;


//测试用的数据
NSMutableArray *Mutablearray = [[NSMutableArray alloc] initWithObjects:@"dayima",@"juhua",@"huaiyun",@"xidangdie",@"diaosi",@"baifumei",@"gaofushuai",@"nixi",
                  @"beitai",@"luguan",@"diaoyudao",@"zhongnanhai",@"hujintao",@"xijinping",@"wenjiabao",@"quchong",nil];
//    self.dataArray =array;
self.dataArray = Mutablearray;
[Mutablearray release];


}

- (void)dealloc
{
    [dataArray release];
    [super dealloc];
}
//////////review function
-(IBAction)reviewButtonPressed{
    ReviewViewController *viewController = [[ReviewViewController alloc] init];
    viewController.reviewURL = [self.infoDictionary objectForKey:@"comments_url"];
    [self presentModalViewController:viewController animated:YES];
    [viewController release];
}
#pragma mark -  test
-(NSInteger)tableView :(UITableView *) tableView
 numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    //try to insert cell
//    static NSString *CellIdentifier = @"FanWallTableViewCell";
//    FanWallTableViewCell *cell = (FanWallTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    cell.backgroundColor = [UIColor clearColor];
//    cell.contentView.backgroundColor = [UIColor clearColor];
//    if (cell == nil) {
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FanWallTableViewCell" owner:self options:nil];
//        for (id oneObject in nib) if ([oneObject isKindOfClass:[FanWallTableViewCell class]]){
//            cell = (FanWallTableViewCell *)oneObject;
    
    
    
    
    
///////test for the first version
static NSString *SimpleTableIdentifier = @"SimpleTableidentifier";
    UITableViewCell *cell   =   [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if (cell ==nil)  {
    cell = [[[UITableViewCell alloc]
             initWithStyle:UITableViewCellStyleDefault
             reuseIdentifier :SimpleTableIdentifier] autorelease];
    }
    
    //添加图像
    UIImage *image = [UIImage imageNamed:@"comment_button.png"];
    cell.imageView.image = image;
    
    
    
    //更改字体与行高
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [dataArray objectAtIndex:row];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:50];
    
    
    return cell;
}
//更改行高
-(CGFloat)tableView :(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

@end
