//
//  LinkViewController.m
//  PeelApp
//
//  Created by Gaffrey on 12-8-7.
//  Copyright (c) 2012年 Peelapp. All rights reserved.
//

#import "LinkViewController.h"

@implementation LinkViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"]; 
        NSString *LinkViewTabBarName = [[[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"AppTabBarNameConfig"] objectForKey:@"LinkViewController"];
        
        self.title = LinkViewTabBarName;
        self.tabBarItem.image = [UIImage imageNamed:@"linkView_tab_icon.png"];
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
