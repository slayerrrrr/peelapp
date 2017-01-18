//
//  AppDelegate.m
//  PeelApp
//
//  Created by Peelapp on 12-4-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize weiBoEngine;

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [weiBoEngine release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"]; 
    NSDictionary *colorDic = [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"AppColorConfig"];
    NSArray *viewControllers = [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:@"ViewControllers"];
    
    NSArray *navTintArray = [colorDic objectForKey:@"NavigationBarTint"];
    float navRed = [[navTintArray objectAtIndex:0] floatValue]/255.0;
    float navGreen = [[navTintArray objectAtIndex:1] floatValue]/255.0;
    float navBlue = [[navTintArray objectAtIndex:2] floatValue]/255.0;
    
    NSMutableArray *viewControllerArray = [[NSMutableArray alloc] init];
    for (NSString *classString in viewControllers) {
        Class ViewClass = NSClassFromString(classString);
        UIViewController *viewController = [[[ViewClass alloc] init] autorelease];
        
        UINavigationController *nav = [[[UINavigationController alloc] initWithRootViewController:viewController] autorelease];
        [viewControllerArray addObject:nav];
        
        nav.navigationBar.tintColor = [UIColor colorWithRed:navRed green:navGreen blue:navBlue alpha:1];
        //[nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_bar.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    self.tabBarController.delegate = self;
    [self.tabBarController setViewControllers:[NSArray arrayWithArray:viewControllerArray] animated:NO];
    self.tabBarController.moreNavigationController.navigationBar.tintColor = [UIColor colorWithRed:navRed green:navGreen blue:navBlue alpha:1];
    [viewControllerArray release];
    
    NSArray *tabTintArray = [colorDic objectForKey:@"TabBarTint"];
    float tabRed = [[tabTintArray objectAtIndex:0] floatValue]/255.0;
    float tabGreen = [[tabTintArray objectAtIndex:1] floatValue]/255.0;
    float tabBlue = [[tabTintArray objectAtIndex:2] floatValue]/255.0;
    self.tabBarController.tabBar.tintColor = [UIColor colorWithRed:tabRed green:tabGreen blue:tabBlue alpha:1];
    
    NSArray *tabSelectedImageTintArray = [colorDic objectForKey:@"TabBarSelectedImageTintColor"];
    float tabSelectRed = [[tabSelectedImageTintArray objectAtIndex:0] floatValue]/255.0;
    float tabSelectGreen = [[tabSelectedImageTintArray objectAtIndex:1] floatValue]/255.0;
    float tabSelectBlue = [[tabSelectedImageTintArray objectAtIndex:2] floatValue]/255.0;
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor colorWithRed:tabSelectRed green:tabSelectGreen blue:tabSelectBlue alpha:1]];
    
    
    
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    self.tabBarController.moreNavigationController.navigationBar.topItem.title = @"更多";
    self.tabBarController.customizableViewControllers = nil;
    //[self.tabBarController.moreNavigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_bar.png"] forBarMetrics:UIBarMetricsDefault];
    
    //配置tabbar 背景图
    UIImageView *tab_imgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbar_bg.png"]];
    tab_imgv.frame = CGRectMake(0,0,320,49);
    tab_imgv.contentMode = UIViewContentModeScaleToFill;
    [self.tabBarController.tabBar insertSubview:tab_imgv atIndex:1];
    [tab_imgv release];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

//for ios version below 4.2
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
	
	return TRUE;
}

//for ios version is or above 4.2
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
	
	return TRUE;
}


// Optional UITabBarControllerDelegate method.
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
