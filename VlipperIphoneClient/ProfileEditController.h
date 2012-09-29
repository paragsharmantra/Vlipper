//
//  ProfileEditController.h
//  VlipperIphoneClient
//
//  Created by Parag Sharma on 22/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWAGConstants.h"
#import "AboutMeEditCell.h"
#import "NameCell.h"
#import "LocationCell.h"
#import "WebCell.h"
#import "EditFieldViewController.h"
#import "ProfileImageCell.h"

@interface ProfileEditController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ProfileEditDelegate>{
    ProfileImageCell *profileImageCell;
    NameCell *nameCell;
    LocationCell *locationCell;
    WebCell *webCell;
    AboutMeEditCell *aboutMeCell;
    UIAlertView *alert;
    NSString *capturedProfileImageURL;
    BOOL profileImageUpdated;
}

@property (strong, nonatomic) IBOutlet UITableView *profileImageTableView;
@property (strong, nonatomic) IBOutlet UITableView *profileDetailsTableView;
@property (strong, nonatomic) UIImage *profileImage;
@property (strong, nonatomic) NSDictionary *profile;
@property (nonatomic, strong) id<ProfileEditDelegate> profileEditDelegate;

@end
