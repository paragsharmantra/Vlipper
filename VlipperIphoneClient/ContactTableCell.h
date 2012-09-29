//
//  ContactTableCell.h
//  VlipperIphoneClient
//
//  Created by Parag Sharma on 01/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILazyImageView.h"

@interface ContactTableCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILazyImageView *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *awaitingApproval;
@property (strong, nonatomic) IBOutlet UIImageView *viewImage;

@end
