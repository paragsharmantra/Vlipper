//
//  ProfileViewController.h
//  VlipperIphoneClient
//
//  Created by Parag Sharma on 06/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWAGConstants.h"
#import "AboutMeViewCell.h"
#import "LocationCell.h"
#import "WebCell.h"
#import "ProfileEditController.h"

@interface ProfileViewController : UIViewController<ProfileEditDelegate>{
    NSDictionary *profile;
    BOOL profileLoaded;
    AboutMeViewCell *aboutMeCell;
    LocationCell *locationCell;
    WebCell *webCell;
}
@property (strong, nonatomic) IBOutlet UITableView *profileImageTableView;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UILabel *joinedOnLabel;
@property (strong, nonatomic) IBOutlet UITableView *profileDetailsTableView;
@end
