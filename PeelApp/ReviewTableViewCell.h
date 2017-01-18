//
//  ReviewTableViewCell.h
//  PeelApp
//
//  Created by Peelapp on 12-5-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewTableViewCell : UITableViewCell{
    IBOutlet UILabel *accountLabel;
    IBOutlet UILabel *dateLabel;
    IBOutlet UILabel *contentLabel;
}

@property(nonatomic, retain) UILabel *accountLabel;
@property(nonatomic, retain) UILabel *dateLabel;
@property(nonatomic, retain) UILabel *contentLabel;
@end
