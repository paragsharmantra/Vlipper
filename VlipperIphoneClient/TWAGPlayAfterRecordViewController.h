//
//  TWAGPlayAfterRecordViewController.h
//  VlipperIphoneClient
//
//  Created by Parag Sharma on 23/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@protocol TWAGPlayAfterRecordDelegate <NSObject>
-(void)videoApproved:(NSURL *) url;
@end

@interface TWAGPlayAfterRecordViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *retakeButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *useButton;
@property (weak, nonatomic) IBOutlet UIToolbar *playAfterRecordToolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *playButton;
@property (weak, nonatomic) NSURL *videoUrl;
@property (strong) MPMoviePlayerController *moviePlayer;
@property (strong, nonatomic) NSString *playingRecording;

- (IBAction)use:(id)sender;
- (IBAction)retake:(id)sender;
- (IBAction)play:(id)sender;


- (void) setVideoURL:(NSURL *) url;
@property (weak, nonatomic) IBOutlet UIView *recordPlayerContentView;
@property (assign, nonatomic) id<TWAGPlayAfterRecordDelegate> delegate;

@end
