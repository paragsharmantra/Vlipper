//
//  TWAGPlayerViewController.m
//  VlipperIphoneClient
//
//  Created by Parag Sharma on 19/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TWAGPlayerViewController.h"
#import "TWAGConstants.h"

@interface TWAGPlayerViewController ()

@end

@implementation TWAGPlayerViewController
@synthesize moviePlayer;
@synthesize movieContentView;
@synthesize toolBar;
@synthesize backButton;
@synthesize playButton;
@synthesize attachmentButton;
@synthesize playing;
@synthesize playerDelegate;
@synthesize mailId;

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
    [toolBar setBackgroundImage:[UIImage imageNamed:@"bottom_bar_bg.png"] forToolbarPosition:0 barMetrics:0];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_button.png"] forState:0 barMetrics:0];
    [playButton setBackgroundImage:[UIImage imageNamed:@"play_button.png"] forState:0 barMetrics:0];
    [attachmentButton setBackgroundImage:[UIImage imageNamed:@"attachment_off.png"] forState:0 barMetrics:0];
    [attachmentButton setBackgroundImage:[UIImage imageNamed:@"attachment_on.png"] forState:1 barMetrics:0];
    
    [toolBar setItems:[NSArray arrayWithObjects:backButton, spacer, playButton, spacer, attachmentButton, nil]];
    
    NSURL *videoURL = [NSURL URLWithString:[[TWAGConstants getServiceBaseURL] stringByAppendingString:[NSString stringWithFormat:@"img/media/%@.MOV", mailId]]];
    NSLog(@"%@", videoURL);
    moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL: videoURL];
//    moviePlayer.view.transform = CGAffineTransformConcat(moviePlayer.view.transform, CGAffineTransformMakeRotation(M_PI_2));
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buffering) name:MPMoviePlayerLoadStateDidChangeNotification object:moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finish) name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer];
    [movieContentView addSubview: moviePlayer.view];
//    UIImageView *firstFrameView = [[UIImageView alloc]initWithImage:[moviePlayer thumbnailImageAtTime:0 timeOption:MPMovieTimeOptionNearestKeyFrame]];
//    [movieContentView addSubview: firstFrameView];
    [moviePlayer.view setFrame:movieContentView.frame];
}

- (void)viewDidUnload
{
    [self setMovieContentView:nil];
    [self setToolBar:nil];
    [self setBackButton:nil];
    [self setPlayButton:nil];
    [self setAttachmentButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)back:(id)sender {
    [moviePlayer stop];
    playing = @"no";
    [playerDelegate back];
}

- (IBAction)play:(id)sender {
    if(playing != @"yes"){
        [playButton setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:0 barMetrics:0];
        [moviePlayer play];
        playing = @"yes";
        
    }else {
        [playButton setBackgroundImage:[UIImage imageNamed:@"play_button.png"] forState:0 barMetrics:0];
        [moviePlayer pause];
        playing = @"no";
    }
}

- (void)buffering
{
    if(playing == @"yes"){
        [playButton setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:0 barMetrics:0];
        playing = @"no";
        
    }else {
        [playButton setBackgroundImage:[UIImage imageNamed:@"play_button.png"] forState:0 barMetrics:0];
        playing = @"yes";
    }

}

- (void)finish
{
    [playButton setBackgroundImage:[UIImage imageNamed:@"play_button.png"] forState:0 barMetrics:0];
    playing = @"no";
}
@end
