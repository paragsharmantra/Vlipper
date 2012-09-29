//
//  TWAGSentViewController.h
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

@interface TWAGSentViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIGestureRecognizerDelegate, TWAGPlayerViewControllerDelegate, PullRefreshDelegate, ComposeDelegate, IconDownloaderDelegate>{
    
    UIProgressView *progressView;
    BOOL uploadInProgress;
    UILabel *dateLabel;
    NSMutableDictionary *imageDownloadsInProgress;
}

@property (nonatomic, strong) NSMutableArray *mails;
@property (nonatomic, strong) NSMutableArray *filteredMails;
@property (weak, nonatomic) IBOutlet PullRefreshTableView *outboxTableView;
@property (weak, nonatomic) IBOutlet UITableViewCell *swipedTableViewCell;
@property (strong, nonatomic) NSIndexPath *swipedIndexPath;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) TWAGUIImageView *deleteImgView;
@property (strong, nonatomic) NSString *swipeDirection;
@property (strong, nonatomic) TWAGPlayerViewController *playerController;
@property (strong, nonatomic) NSDictionary *profileImages;

@property (nonatomic, strong) id<OutboxDelegate> outboxDelegate;

- (void)loadOutbox;

@end
