//
//  ViewContactRequestsViewController.h
//  VlipperIphoneClient
//
//  Created by Parag Sharma on 03/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWAGContactsViewController.h"
#import "ContactViewController.h"

@interface ViewContactRequestsViewController : UIViewController <IconDownloaderDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, ContactsDelegate>{
    NSMutableArray *friends;
    NSDictionary *entries;
    NSMutableDictionary *imageDownloadsInProgress;
    NSMutableArray *friendsSectioned;
    
    NSMutableArray *titles;
    NSMutableArray *indexes;

}
@property (strong, nonatomic) IBOutlet UITableView *contactRequestsTableView;

@end
