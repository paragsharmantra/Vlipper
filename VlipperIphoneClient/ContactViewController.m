//
//  ContactViewController.m
//  VlipperIphoneClient
//
//  Created by Parag Sharma on 03/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContactViewController.h"

@interface ContactViewController ()

@end

@implementation ContactViewController
@synthesize profile;
@synthesize profileImage;
@synthesize name;
@synthesize email;
@synthesize profileBoxView;
@synthesize aboutMeTextView;
@synthesize locationTextView;
@synthesize webTextView;
@synthesize contactsDelegate;

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
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topbar.png"] forBarMetrics:UIBarMetricsDefault];
    UIImageView *cancelImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cancel_button.png"]];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithCustomView:cancelImgView];
    cancelImgView.userInteractionEnabled = YES;
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UITapGestureRecognizer *cancelTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissThisView)];
    [cancelImgView addGestureRecognizer:cancelTapRecognizer];

    name.text = [[profile valueForKey:@"users"] valueForKey:@"name"];
    email.text = [[profile valueForKey:@"users"] valueForKey:@"email"]; 
    
    NSString *aboutMe = [[profile valueForKey:@"users"] valueForKey:@"about_me"];
    if(aboutMe != (id)[NSNull null])
        aboutMeTextView.text = [[profile valueForKey:@"users"] valueForKey:@"about_me"]; 
    
    NSString *location = [[profile valueForKey:@"users"] valueForKey:@"location"];
    if(location != (id)[NSNull null])
        locationTextView.text = [[profile valueForKey:@"users"] valueForKey:@"location"];  
    
    NSString *web = [[profile valueForKey:@"users"] valueForKey:@"web"];
    if(web != (id)[NSNull null])
        webTextView.text = [[profile valueForKey:@"users"] valueForKey:@"web"];  
    
    NSString *url = [NSString stringWithFormat:@"img/%@.jpg", [[profile valueForKey:@"users"] valueForKey:@"id"]];
    NSURL *imageURL = [NSURL URLWithString:[[TWAGConstants getServiceBaseURL] stringByAppendingString:url]];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    profileImage.image = image;
    profileBoxView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"i-phone-bg.png"]];
}

- (void) dismissThisView{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void) approveFriend
{
    NSString *friendId = [[profile valueForKey:@"users"] valueForKey:@"id"];
    NSString *urlString = [[[[TWAGConstants getServiceBaseURL] stringByAppendingString:@"users/approve_friend"] stringByAppendingString:@"?friend_id="] stringByAppendingString:friendId];
    NSURL *url = [NSURL URLWithString:urlString] ;
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    NSError *requestError;
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if(error == nil){
            NSMutableDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSString* responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@", responseStr);
            [contactsDelegate reloadContactRequests];
            [self performSelectorOnMainThread:@selector(dismissThisView) withObject:nil waitUntilDone:YES];
        }else {
            NSLog(@"%@", requestError);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Connection to Server Failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
        }
    }];
    
}


- (void)viewDidUnload
{
    [self setProfileImage:nil];
    [self setName:nil];
    [self setEmail:nil];
    [self setProfileBoxView:nil];
    [self setAboutMeTextView:nil];
    [self setLocationTextView:nil];
    [self setWebTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)acceptButtonClicked:(id)sender {
    [self approveFriend];
}

- (IBAction)rejectButtonClicked:(id)sender {
    [self dismissThisView];
}
@end
