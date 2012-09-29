//
//  ProfileRecord.h
//  VlipperIphoneClient
//
//  Created by Parag Sharma on 01/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileRecord : NSObject{
    UIImage *profileIcon;
}

@property (nonatomic, retain) UIImage *profileIcon;
@property (nonatomic, retain) NSString *imageURLString;

@end
