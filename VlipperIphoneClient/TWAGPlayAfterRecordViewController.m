//
//  TWAGPlayAfterRecordViewController.m
//  VlipperIphoneClient
//
//  Created by Parag Sharma on 23/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TWAGPlayAfterRecordViewController.h"

@interface TWAGPlayAfterRecordViewController ()

@end

@implementation TWAGPlayAfterRecordViewController
@synthesize recordPlayerContentView;
@synthesize useButton;
@synthesize playAfterRecordToolbar;
@synthesize playButton;
@synthesize retakeButton;
@synthesize videoUrl;
@synthesize moviePlayer;
@synthesize playingRecording;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [playAfterRecordToolbar setBackgroundImage:[UIImage imageNamed:@"bottom_bar_bg.png"] forToolbarPosition:0 barMetrics:0];
    [retakeButton setBackgroundImage:[UIImage imageNamed:@"retake.png"] forState:0 barMetrics:0];
    [playButton setBackgroundImage:[UIImage imageNamed:@"play_button.png"] forState:0 barMetrics:0];
    [useButton setBackgroundImage:[UIImage imageNamed:@"use.png"] forState:0 barMetrics:0];
    
     UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [playAfterRecordToolbar setItems:[NSArray arrayWithObjects:retakeButton, spacer, playButton, spacer, useButton, nil]];
    moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL: videoUrl];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finish) name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer];
    [recordPlayerContentView addSubview:moviePlayer.view];
    [moviePlayer.view setFrame:recordPlayerContentView.frame];
    
    
}

- (void)viewDidUnload
{
    [self setRetakeButton:nil];
    [self setPlayButton:nil];
    [self setUseButton:nil];
    [self setPlayAfterRecordToolbar:nil];
    [self setRecordPlayerContentView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)retake:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)play:(id)sender {
    if(playingRecording != @"yes"){
        [playButton setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:0 barMetrics:0];
        [moviePlayer play];
        playingRecording = @"yes";
        
    }else {
        [playButton setBackgroundImage:[UIImage imageNamed:@"play_button.png"] forState:0 barMetrics:0];
        [moviePlayer pause];
        playingRecording = @"no";
    }

}

- (void) finish
{
    [playButton setBackgroundImage:[UIImage imageNamed:@"play_button.png"] forState:0 barMetrics:0];
    playingRecording = @"no";
}

- (IBAction)use:(id)sender {
    NSLog(@"calling RecordingViewController");
    [delegate videoApproved:videoUrl];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) setVideoURL:(NSURL *) url
{
    videoUrl = url;
}
@end
