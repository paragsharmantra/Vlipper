//
//  TWAGRecordingViewController.h
//  VlipperIphoneClient
//
//  Created by Parag Sharma on 22/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "TWAGPlayAfterRecordViewController.h"

@protocol TWAGRecordingViewControllerDelegate <NSObject>
-(void)cancel;
-(void)videoReady:(NSURL *) url;
@end

@interface TWAGRecordingViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, TWAGPlayAfterRecordDelegate>
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *recordingButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraFlipButton;
- (IBAction)cancel:(id)sender;
- (IBAction)record:(id)sender;
- (IBAction)flip:(id)sender;

@property (nonatomic, assign) id<TWAGRecordingViewControllerDelegate> recorderDelegate;

@property (nonatomic, strong) UIImagePickerController *cameraUI;
@property (strong, nonatomic) TWAGPlayAfterRecordViewController *player;
@property (nonatomic, strong) NSString *recording;

@property (strong, nonatomic) NSString *recordingScreen;
@property (strong, nonatomic) NSString *playScreen;

@property (strong, nonatomic) NSString *playing;
@property (nonatomic, strong) NSString *side;
@property (strong, nonatomic) IBOutlet UIView *mediaContentView;


@end
