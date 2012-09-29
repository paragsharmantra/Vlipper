//
//  LaunchViewController.h
//  VlipperIphoneClient
//
//  Created by Parag Sharma on 13/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWAGSignupViewController.h"
#import "TWAGSigninViewController.h"
#import "TWAGInboxViewController.h"
#import "TWAGSentViewController.h"
#import "LoadingViewController.h"

@interface LaunchViewController : UIViewController <TWAGSignupViewDelegate, TWAGSignInViewDelegate, OutboxDelegate>{
    TWAGSentViewController *sentViewController;
}

- (IBAction)signup:(id)sender;
- (IBAction)signin:(id)sender;
- (UITabBarController *) launch;

@property (nonatomic, readwrite) TWAGSignupViewController *signupViewController;
@property (nonatomic, readwrite) TWAGSigninViewController *signinViewController;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) NSDictionary *profileImages;
@property (strong, nonatomic) LoadingViewController *loadingViewController;

@end
