//
//  TWAGMoreViewController.h
//  VlipperIphoneClient
//
//  Created by Parag Sharma on 18/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileViewController.h"

@interface TWAGMoreViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *actionsTableView;

@end
