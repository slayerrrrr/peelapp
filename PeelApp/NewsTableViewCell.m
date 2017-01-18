//
//  NewsTableViewCell.m
//  PeelApp
//
//  Created by Peelapp on 12-4-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewsTableViewCell.h"

@implementation NewsTableViewCell

@synthesize titleLabel, dateLabel;

- (void)dealloc
{
    [titleLabel release];
    [dateLabel release];
    [super dealloc];
}


@end
