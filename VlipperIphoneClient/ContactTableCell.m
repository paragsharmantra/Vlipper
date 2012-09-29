//
//  ContactTableCell.m
//  VlipperIphoneClient
//
//  Created by Parag Sharma on 01/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContactTableCell.h"

@implementation ContactTableCell
@synthesize profileImage;
@synthesize name;
@synthesize awaitingApproval;
@synthesize viewImage;

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
