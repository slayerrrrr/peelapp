//
//  SettingsViewController.m
//  yangsheng
//
//  Created by Peelapp on 12-2-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "LoginViewController.h"
#import "FeedbackViewController.h"
#import "Constant.h"

@implementation SettingsViewController
@synthesize settingsTableView;

#pragma mark - View lifecycle
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
        
        NSString *SettingsViewTabBarName = [[[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"AppTabBarNameConfig"] objectForKey:@"SettingsViewController"];
        
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400, 44)] autorelease];
        label.text = SettingsViewTabBarName;
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
        self.title = SettingsViewTabBarName;
        self.tabBarItem.image = [UIImage imageNamed:@"settingsView_tab_icon.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)dealloc
{
    [settingsTableView release];
    [super dealloc];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int number = 0;
    if (section == 0) {
        number = 1;
    }
    else if (section == 1){
        number = 2;
    }
    else if (section == 2){
        number = 1;
    }
    
    return number;
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
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"账户设置";
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            cell.textLabel.text = @"意见反馈";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if (indexPath.row == 1) {
            cell.textLabel.text = @"给程序评价";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else if (indexPath.section == 2){
        NSString  *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        cell.textLabel.text = version;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //点击之后取消反显效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            LoginViewController *loginView = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:loginView animated:YES];
            [loginView release];
        }
    }
    else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            FeedbackViewController *viewController = [[FeedbackViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
            [viewController release];
        }
        else if (indexPath.row == 1) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"]; 
            NSString *url = [[[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"SettingsViewConfig"] objectForKey:@"RateURL"];
    
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
    }
}

@end
