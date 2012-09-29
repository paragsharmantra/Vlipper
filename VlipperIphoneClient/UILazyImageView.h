//
//  UILazyImageView.h
//  VlipperIphoneClient
//
//  Created by Parag Sharma on 01/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILazyImageView : UIImageView{
    NSMutableData *receivedData;
}

- (id)initWithURL:(NSURL *)url;
- (void)loadWithURL:(NSURL *)url;


@end
