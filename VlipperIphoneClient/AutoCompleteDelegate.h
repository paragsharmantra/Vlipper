//
//  AutoCompleteDelegate.h
//  VlipperIphoneClient
//
//  Created by Parag Sharma on 27/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutoCompleteTableView.h"
#import "TWAGConstants.h"

@interface AutoCompleteDelegate : NSObject <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *suggestions;
@property (nonatomic, strong) AutoCompleteTableView *autoCompleteTableView;
@property (nonatomic, strong) NSString *reciepientId;
@property (nonatomic, strong) NSString *reciepientName;

@end
