//
//  TWAGComoseViewController.h
//  VlipperIphoneClient
//
//  Created by Parag Sharma on 18/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWAGRecordingViewController.h"
#import "TWAGPlayAfterRecordViewController.h"
#import "AutoCompleteDelegate.h"

@protocol ComposeDelegate <NSObject>
-(void)displayJustSentMailWithSubject:(NSString *)subject forRecipientId:(NSString *) recipientId forRecipientName:(NSString *) recipientName;
-(void)updateUploadCellToProgressPercentage:(float) percentage;
-(void)notifyWithReceiverId:(NSInteger *) receiverId;
-(void)notifyWithReceiverId:(NSInteger *) receiverName;
@end

@interface TWAGComoseViewController : UIViewController <TWAGRecordingViewControllerDelegate>{
    BOOL uploadInProgress;
    AutoCompleteDelegate *autoCompleteDelegate;
}
@property (strong, nonatomic) IBOutlet UIImageView *recordImageView;
@property (strong, nonatomic) NSURL *videoUrl;
@property (strong, nonatomic)  UITextField *toTextField;
@property (strong, nonatomic) UITextField *subjectTextField;

@property (nonatomic, assign) id<ComposeDelegate> composeDelegate;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *mailId;
@property (nonatomic, weak) NSString *email;
@property (nonatomic, weak) NSString *subject;

@property (nonatomic, strong) AutoCompleteTableView *autoCompleteTableView;

@end
