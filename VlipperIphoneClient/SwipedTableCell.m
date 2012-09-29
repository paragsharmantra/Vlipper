//
//  SwipedTableCell.m
//  VlipperIphoneClient
//
//  Created by Parag Sharma on 01/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SwipedTableCell.h"

@implementation SwipedTableCell
@synthesize playSwipeButton;
@synthesize replySwipeButton;
@synthesize contactSwipeButton;
@synthesize deleteSwipeButton;

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

@end
