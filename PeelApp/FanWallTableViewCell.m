//
//  FanWallTableViewCell.m
//  PeelApp
//
//  Created by slayer on 12-9-10.
//  Copyright (c) 2012年 Peelapp. All rights reserved.
//

#import "FanWallTableViewCell.h"

@implementation FanWallTableViewCell;

@synthesize frameTableView;
@synthesize nameLabel, dateLabel;
@synthesize fanwallcomment;


-(void)dealloc
{[frameTableView release];
    [nameLabel   release];
    [dateLabel   release];
    [fanwallcomment release];
    [super dealloc];
}

@end


