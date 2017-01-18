//
//  MenuListTableViewCell.h
//  PeelApp
//
//  Created by Gaffrey on 12-8-14.
//  Copyright (c) 2012年 Peelapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuListTableViewCell : UITableViewCell{
    IBOutlet UIImageView *imageView;
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *subtitleLabel;
    IBOutlet UILabel *priceLabel;
}

@property(nonatomic, retain) UIImageView *imageView;
@property(nonatomic, retain) UILabel *titleLabel;
@property(nonatomic, retain) UILabel *subtitleLabel;
@property(nonatomic, retain) UILabel *priceLabel;

@end