//
//  FanWallViewController.h
//  PeelApp
//
//  Created by peelapp  on 12-9-4.
//  Copyright (c) 2012年 Peelapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FanWallViewController : UIViewController< UITableViewDelegate, UITableViewDataSource>{
 NSMutableArray *dataArray;
//    NSArray *listData;
}


@property(retain, nonatomic) NSDictionary *infoDictionary;
@property(nonatomic, retain) NSMutableArray *dataArray;
//@property(nonatomic, retain) NSArray *listData;
@end
