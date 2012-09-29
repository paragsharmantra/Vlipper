//
//  MailTableCell.m
//  VlipperIphoneClient
//
//  Created by Parag Sharma on 17/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MailTableCell.h"

@implementation MailTableCell
@synthesize nameLabel;
@synthesize subjectLabel;
@synthesize dateLabel;
@synthesize profileImage;
@synthesize deleteButton;
@synthesize progressView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Create a time zone view and add it as a subview of self's contentView.
		
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
