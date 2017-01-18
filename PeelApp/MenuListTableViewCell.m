//
//  MenuListTableViewCell.m
//  PeelApp
//
//  Created by Gaffrey on 12-8-14.
//  Copyright (c) 2012年 Peelapp. All rights reserved.
//

#import "MenuListTableViewCell.h"

@implementation MenuListTableViewCell
@synthesize imageView;
@synthesize titleLabel, subtitleLabel;
@synthesize priceLabel;

- (void)dealloc
{
    [imageView release];
    [titleLabel release];
    [subtitleLabel release];
    [priceLabel release];
    [super dealloc];
}

@end
