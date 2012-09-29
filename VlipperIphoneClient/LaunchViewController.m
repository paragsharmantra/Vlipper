//
//  LaunchViewController.m
//  VlipperIphoneClient
//
//  Created by Parag Sharma on 13/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LaunchViewController.h"
#import "TWAGSignupViewController.h"
#import "TWAGSigninViewController.h"
#import "TWAGSignupInProgressViewController.h"
#import "TWAGInboxViewController.h"
#import "TWAGSentViewController.h"
#import "TWAGContactsViewController.h"
#import "TWAGMoreViewController.h"

@interface LaunchViewController ()

@end

@implementation LaunchViewController
@synthesize signupViewController;
@synthesize signinViewController;
@synthesize tabBarController = _tabBarController;
@synthesize profileImages;
@synthesize loadingViewController;

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
    UIView *view1 = [self.view viewWithTag:1];
    UIColor *background1 = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background1.png"]];
    view1.backgroundColor = background1;
    
    UIView *view2 = [self.view viewWithTag:2];
    UIColor *background2 = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    view2.backgroundColor = background2;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)signup:(id)sender {
    signupViewController = [TWAGSignupViewController alloc];
    signupViewController.signupViewDelegate = self;
    [self.navigationController pushViewController:signupViewController animated:YES];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationController.navigationBar.topItem.leftBarButtonItem = leftButton;
    UIBarButtonItem *signupButton = [[UIBarButtonItem alloc] initWithTitle:@"Signup" style:UIBarButtonItemStyleBordered target:self action:@selector(initiateSignup)];
    signupButton.enabled = NO;
    self.navigationController.navigationBar.topItem.rightBarButtonItem = signupButton;
}

- (void) back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) initiateSignup
{
    [signupViewController initiateSignup];

}


- (IBAction)signin:(id)sender {
    signinViewController = [TWAGSigninViewController alloc];
    signinViewController.signInViewDelegate = self;
    [self.navigationController pushViewController:signinViewController animated:YES];
}

-(void) signupInProgress
{
    TWAGSignupInProgressViewController *progress = [TWAGSignupInProgressViewController alloc];
    [self.navigationController pushViewController:progress animated:YES];
}

-(void) signupSuccess
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logging In" message:@"The account has been created" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
    [self presentViewController:[self launch] animated:YES completion:nil];
}

-(void) signupError
{
    
}

-(void) signinSuccess
{
    [self presentViewController:[self launch] animated:YES completion:nil];
}

- (UITabBarController *) launch
{
    profileImages = [[NSMutableDictionary alloc] initWithCapacity:50];
    TWAGInboxViewController *inboxViewController = [TWAGInboxViewController alloc];
    inboxViewController.outboxDelegate = self;
    [inboxViewController setProfileImages:profileImages];
    [inboxViewController loadInbox];
    inboxViewController.tabBarItem.image = [UIImage imageNamed:@"inbox.png"];
    UINavigationController *inboxNavController = [[UINavigationController alloc] initWithRootViewController:inboxViewController];
    
    sentViewController = [TWAGSentViewController alloc];
    sentViewController.outboxDelegate = self;
    [sentViewController setProfileImages:profileImages];
    [sentViewController loadOutbox];
    sentViewController.tabBarItem.image = [UIImage imageNamed:@"outbox.png"];
    UINavigationController *sentNavController = [[UINavigationController alloc] initWithRootViewController:sentViewController];
    
    TWAGContactsViewController *contactsViewController = [TWAGContactsViewController alloc];
    [contactsViewController setProfileImages:profileImages];
    contactsViewController.tabBarItem.image = [UIImage imageNamed:@"contacts.png"];
    UINavigationController *contactsNavController = [[UINavigationController alloc] initWithRootViewController:contactsViewController];
    
    TWAGMoreViewController *moreViewController = [TWAGMoreViewController alloc];
    moreViewController.tabBarItem.image = [UIImage imageNamed:@"more.png"];
    UINavigationController *moreNavController = [[UINavigationController alloc] initWithRootViewController:moreViewController];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = [NSArray arrayWithObjects:inboxNavController, sentNavController, contactsNavController, moreNavController, nil];
    
    return tabBarController;
}

-(void)windComposeWithOutboxViews:(TWAGComoseViewController *)composeViewController;
{
    composeViewController.composeDelegate = sentViewController;
}
@end
