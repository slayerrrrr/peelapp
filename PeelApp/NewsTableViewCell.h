//
//  NewsTableViewCell.h
//  PeelApp
//
//  Created by Peelapp on 12-4-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableViewCell : UITableViewCell {
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *dateLabel;
}

@property(nonatomic, retain) UILabel *titleLabel;
@property(nonatomic, retain) UILabel *dateLabel;

@end
