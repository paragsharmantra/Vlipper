//
//  ContactViewController.h
//  VlipperIphoneClient
//
//  Created by Parag Sharma on 03/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWAGConstants.h"

@protocol ContactsDelegate <NSObject>
-(void)reloadContactRequests;
@end

@interface ContactViewController : UIViewController

@property (strong, nonatomic)  NSDictionary *profile;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *email;
@property (strong, nonatomic) IBOutlet UIView *profileBoxView;
@property (strong, nonatomic) IBOutlet UITextView *aboutMeTextView;
@property (strong, nonatomic) IBOutlet UITextView *locationTextView;
@property (strong, nonatomic) IBOutlet UITextView *webTextView;

@property (nonatomic, strong) id<ContactsDelegate> contactsDelegate;
- (IBAction)acceptButtonClicked:(id)sender;
- (IBAction)rejectButtonClicked:(id)sender;

@end
