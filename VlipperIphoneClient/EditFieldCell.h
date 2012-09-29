//
//  EditFieldCell.h
//  VlipperIphoneClient
//
//  Created by Parag Sharma on 22/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProfileEditDelegate <NSObject>
-(void)notifyChangeForKey:(NSString *)key WithValue:(NSString *)value;
-(void)notifyProfileUpdate:(NSDictionary *) profile;
@end

@interface EditFieldCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UITextField *valueTextField;

@end
