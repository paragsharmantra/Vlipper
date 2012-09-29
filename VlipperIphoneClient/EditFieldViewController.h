//
//  EditFieldViewController.h
//  VlipperIphoneClient
//
//  Created by Parag Sharma on 22/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditFieldCell.h"
#import "ProfileEditController.h"

@interface EditFieldViewController : UIViewController{
    EditFieldCell *editFieldCell;
}

@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSString *value;
@property (strong, nonatomic) IBOutlet UITextField *valueTextField;

@property (nonatomic, strong) id<ProfileEditDelegate> profileEditDelegate;

@end
