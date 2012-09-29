//
//  TWAGConstants.m
//  VlipperIphoneClient
//
//  Created by Parag Sharma on 19/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TWAGConstants.h"

@implementation TWAGConstants

+ (NSString *) getServiceBaseURL
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];
    return [settings objectForKey:@"service_url"];
}


@end
