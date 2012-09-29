//
//  TWAGSigninViewController.h
//  VlipperIphoneClient
//
//  Created by Parag Sharma on 24/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TWAGSignInViewDelegate <NSObject>
-(void)signinSuccess;
@end

@interface TWAGSigninViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (nonatomic, assign) id<TWAGSignInViewDelegate> signInViewDelegate;

@end
