//
//  TWAGPlayerViewController.h
//  VlipperIphoneClient
//
//  Created by Parag Sharma on 19/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "TWAGConstants.h"

@protocol TWAGPlayerViewControllerDelegate <NSObject>
-(void)back;
@end

@interface TWAGPlayerViewController : UIViewController
- (IBAction)back:(id)sender;
- (IBAction)play:(id)sender;

@property (strong) MPMoviePlayerController *moviePlayer;
@property (weak, nonatomic) IBOutlet UIView *movieContentView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *playButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *attachmentButton;
@property (strong, nonatomic) NSString *playing;
- (IBAction)play:(id)sender;
@property (nonatomic, assign) id<TWAGPlayerViewControllerDelegate> playerDelegate;
- (IBAction)back:(id)sender;
@property (nonatomic, strong) NSString *mailId;

@end
