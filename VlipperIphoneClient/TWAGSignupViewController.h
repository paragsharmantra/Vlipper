//
//  TWAGSignupViewController.h
//  VlipperIphoneClient
//
//  Created by Parag Sharma on 13/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWAGConstants.h"

@protocol TWAGSignupViewDelegate <NSObject>
-(void)signupInProgress;
-(void)signupSuccess;
-(void)signupError;
@end

@interface TWAGSignupViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, NSURLConnectionDelegate>

@property (weak, nonatomic) IBOutlet UITableView *signupTableView;
@property (weak, nonatomic) IBOutlet UITextField *fullNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (nonatomic, assign) id<TWAGSignupViewDelegate> signupViewDelegate;

- (IBAction)initiateSignup;


@end


