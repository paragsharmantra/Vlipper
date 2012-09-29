//
//  TWAGRecordingViewController.m
//  VlipperIphoneClient
//
//  Created by Parag Sharma on 22/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TWAGRecordingViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface TWAGRecordingViewController ()

@end

@implementation TWAGRecordingViewController
@synthesize toolBar;
@synthesize cancelButton;
@synthesize recordingButton;
@synthesize cameraFlipButton;
@synthesize recorderDelegate;
@synthesize cameraUI;
@synthesize recording;
@synthesize side;
@synthesize mediaContentView;
@synthesize playing;
@synthesize playScreen;
@synthesize  recordingScreen;
@synthesize player;

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
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [toolBar setBackgroundImage:[UIImage imageNamed:@"bottom_bar_bg.png"] forToolbarPosition:0 barMetrics:0];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [self prepareRecordingScreen];
    
    [toolBar setItems:[NSArray arrayWithObjects:cancelButton, spacer, recordingButton, spacer, cameraFlipButton, nil]];
    
    cameraUI = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
            cameraUI.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
            [cameraUI setShowsCameraControls:NO];
            [cameraUI setVideoMaximumDuration:30];
            [cameraUI setDelegate:self];
            cameraUI.allowsEditing = YES;
            [self.view addSubview:cameraUI.view];
            [cameraUI setCameraOverlayView:toolBar];
        }
}

- (void)viewDidUnload
{
    [self setToolBar:nil];
    [self setCancelButton:nil];
    [self setRecordingButton:nil];
    [self setCameraFlipButton:nil];
    [self setMediaContentView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)cancel:(id)sender {
    [recorderDelegate cancel];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void) prepareRecordingScreen
{
    recordingScreen = @"yes";    
    playScreen = @"no";
    [recordingButton setBackgroundImage:[UIImage imageNamed:@"record.png"] forState:0 barMetrics:0];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"cancel_button.png"] forState:0 barMetrics:0];
    [cameraFlipButton setBackgroundImage:[UIImage imageNamed:@"camera.png"] forState:0 barMetrics:0];
}

- (IBAction)record:(id)sender {
    if(recording == @"yes"){
        [recordingButton setBackgroundImage:[UIImage imageNamed:@"record.png"] forState:0 barMetrics:0];
        [cameraUI stopVideoCapture];
    }else {
        [recordingButton setBackgroundImage:[UIImage imageNamed:@"record.png"] forState:0 barMetrics:0];
        recording = @"yes";
        [cameraUI startVideoCapture];
    }
}

- (IBAction)flip:(id)sender {
    if(side == @"back")
    {
        cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        side = @"front";
    }
    else {
        cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        side = @"back";
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"finishing recording");
    
    NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
    player = [TWAGPlayAfterRecordViewController alloc];
    [player setVideoURL:videoURL];
    player.delegate = self;
    recording = @"no";
    [self.navigationController pushViewController:player animated:YES];
}

-(void)videoApproved:(NSURL *) url
{
    [recorderDelegate videoReady:url];
    NSLog(@"called RecordingViewController");
}
@end
