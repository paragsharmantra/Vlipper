//
//  TWAGContactsViewController.h
//  VlipperIphoneClient
//
//  Created by Parag Sharma on 18/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddContactsViewController.h"
#import "TWAGConstants.h"
#import "ContactTableCell.h"
#import "ProfileRecord.h"
#import "IconDownloader.h"
#import "ViewContactRequestsViewController.h"

@interface TWAGContactsViewController : UIViewController <UIScrollViewDelegate, UIActionSheetDelegate, AddContactsDelegate, IconDownloaderDelegate>{
    AddContactsViewController *addContactsViewController;
    NSMutableArray *friends;
    NSDictionary *entries;
    NSMutableDictionary *imageDownloadsInProgress;
    NSMutableArray *friendsSectioned;
    
    NSMutableArray *titles;
    NSMutableArray *indexes;
    
    UITableViewCell *contactCell;
    
    
}
@property (strong, nonatomic) IBOutlet UITableView *contactsTableView;
@property (strong, nonatomic)  NSDictionary *profileImages;

@end
