//
//  TWAGInboxViewController.h
//  VlipperIphoneClient
//
//  Created by Parag Sharma on 17/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWAGUIImageView.h"
#import "TWAGConstants.h"
#import "TWAGPlayerViewController.h"
#import "PullRefreshTableView.h"
#import "TWAGComoseViewController.h"
#import "TWAGProtocols.h"
#import "ProfileRecord.h"
#import "IconDownloader.h"
#import "LaunchViewController.h"

@interface TWAGInboxViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIGestureRecognizerDelegate, TWAGPlayerViewControllerDelegate, PullRefreshDelegate, UIActionSheetDelegate, IconDownloaderDelegate>{
    TWAGComoseViewController *compose;
    NSMutableDictionary *imageDownloadsInProgress;
}

@property (nonatomic, strong) NSMutableArray *mails;
@property (nonatomic, strong) NSMutableArray *filteredMails;
@property (weak, nonatomic) IBOutlet PullRefreshTableView *inboxTableView;
@property (weak, nonatomic) IBOutlet UITableViewCell *swipedTableViewCell;
@property (strong, nonatomic) NSIndexPath *swipedIndexPath;
@property (strong, nonatomic) NSDictionary *swipedMail;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) TWAGUIImageView *deleteImgView;
@property (strong, nonatomic) NSString *swipeDirection;
@property (strong, nonatomic) TWAGPlayerViewController *playerController;
@property (strong, nonatomic) NSDictionary *profileImages;

@property (nonatomic, strong) id<OutboxDelegate> outboxDelegate;

- (void)loadInbox;
+ (NSString *) getDateLabel:(NSString *)date;

@end
