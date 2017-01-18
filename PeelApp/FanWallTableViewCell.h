//
//  FanWallTableViewCell.h
//  PeelApp
//
//  Created by slayer on 12-9-10.
//  Copyright (c) 2012年 Peelapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FanWallTableViewCell : UITableViewCell{
    IBOutlet UIImageView  *frameTableView;
    IBOutlet UILabel      *nameLabel;
    IBOutlet UILabel      *dateLabel;
    IBOutlet UITextView   *fanwallcomment;
}
@property(nonatomic, retain) UIImageView *frameTableView;
@property(nonatomic, retain) UILabel *nameLabel;
@property(nonatomic, retain) UILabel *dateLabel;
@property(nonatomic, retain) UITextView *fanwallcomment;

@end
