//
//  AddContactsViewController.h
//  VlipperIphoneClient
//
//  Created by Parag Sharma on 30/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWAGConstants.h"

@protocol AddContactsDelegate <NSObject>
-(void)contactAdded;
@end

@interface AddContactsViewController : UIViewController <UITableViewDataSource>{
    UITextField *emailTextField;
}

@property (nonatomic, assign) id<AddContactsDelegate> addContactsDelegate;

@end
