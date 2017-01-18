//
//  ArticlesViewController.m
//  PeelApp
//
//  Created by peelapp  on 12-9-4.
//  Copyright (c) 2012年 Peelapp. All rights reserved.
//

#import "ArticlesViewController.h"

@implementation ArticlesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"];
        NSString *ArticlesViewTabBarName = [[[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"AppTabBarNameConfig"] objectForKey:@"ArticlesViewController"];
        
        self.title = ArticlesViewTabBarName;
        self.tabBarItem.image = [UIImage imageNamed:@"articlesView_tab_icon.png"];
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)dealloc
{
    [super dealloc];
}
@end
