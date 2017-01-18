//
//  ReviewTableViewCell.m
//  PeelApp
//
//  Created by Peelapp on 12-5-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReviewTableViewCell.h"

@implementation ReviewTableViewCell
@synthesize accountLabel, dateLabel, contentLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc{
    [accountLabel release];
    [dateLabel release];
    [contentLabel release];
    [super dealloc];
}
@end
