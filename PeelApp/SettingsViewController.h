//
//  SettingsViewController.h
//  yangsheng
//
//  Created by Peelapp on 12-2-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    IBOutlet UITableView *settingsTableView;
}

@property(nonatomic, retain) UITableView *settingsTableView;
@end
