//
//  SwipedTableCell.h
//  VlipperIphoneClient
//
//  Created by Parag Sharma on 01/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwipedTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *playSwipeButton;
@property (weak, nonatomic) IBOutlet UIImageView *replySwipeButton;
@property (weak, nonatomic) IBOutlet UIImageView *contactSwipeButton;
@property (weak, nonatomic) IBOutlet UIImageView *deleteSwipeButton;

@end
