//
//  TWAGProtocols.h
//  VlipperIphoneClient
//
//  Created by Parag Sharma on 29/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWAGComoseViewController.h"

@protocol OutboxDelegate <NSObject>
-(void)windComposeWithOutboxViews:(TWAGComoseViewController *)composeViewController;
@end

@interface TWAGProtocols : NSObject

@end
