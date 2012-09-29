//
//  ProfileViewController.m
//  VlipperIphoneClient
//
//  Created by Parag Sharma on 06/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

@synthesize profileImageTableView;
@synthesize profileImage;
@synthesize nameLabel;
@synthesize emailLabel;
@synthesize joinedOnLabel;
@synthesize profileDetailsTableView;

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
    [self loadProfile];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topbar.png"] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iphone_bg6.png"]];
    UIImageView *cancelImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cancel_button.png"]];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithCustomView:cancelImgView];
    cancelImgView.userInteractionEnabled = YES;
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UITapGestureRecognizer *cancelTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissThisView)];
    [cancelImgView addGestureRecognizer:cancelTapRecognizer];
    
    UIImageView *editImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"compose_new.png"]];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithCustomView:editImgView];
    editImgView.userInteractionEnabled = YES;
    self.navigationItem.rightBarButtonItem = saveButton;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadEditScreen)];
    [editImgView addGestureRecognizer:tap];
    
    
    locationCell = (LocationCell *)[[[NSBundle mainBundle] loadNibNamed:@"ViewProfileTableCell" owner:self options:nil] objectAtIndex:1];
    webCell = (WebCell *)[[[NSBundle mainBundle] loadNibNamed:@"ViewProfileTableCell" owner:self options:nil] objectAtIndex:2];
    
}

- (void) loadEditScreen{
    ProfileEditController *editViewController = [ProfileEditController alloc];
    editViewController.profileEditDelegate = self;
    editViewController.profile = profile;
    UINavigationController *editNav = [[UINavigationController alloc] initWithRootViewController:editViewController];
    [self presentModalViewController:editNav animated:YES];
}


- (void) dismissThisView{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(profileLoaded){
        if(cell == nil){
            //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];   
            //cell.detailTextLabel.textAlignment = UITextAlignmentCenter;
            if(indexPath.row == 0){
                NSString *aboutMe = ([profile objectForKey:@"about_me"] != [NSNull null])? [profile objectForKey:@"about_me"] : @"";
                aboutMeCell = (AboutMeViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"ViewProfileTableCell" owner:self options:nil] objectAtIndex:0];
                aboutMeCell.aboutMeLabel.text = aboutMe;
                cell = aboutMeCell;
                
                NSString *url = [NSString stringWithFormat:@"img/%@.jpg", [profile objectForKey:@"id"]];
                url = [[TWAGConstants getServiceBaseURL] stringByAppendingString:url];
                profileImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
                
                nameLabel.text = ([profile objectForKey:@"name"] != [NSNull null]) ? [profile objectForKey:@"name"] : @"";
                emailLabel.text = [profile objectForKey:@"email"];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *created = [dateFormatter dateFromString:[profile objectForKey:@"created"]];
                [dateFormatter setDateFormat:@"dd MMMM, yyyy"];
                joinedOnLabel.text = [NSString stringWithFormat:@"Joined on %@", [dateFormatter stringFromDate:created]]; 
            }
            else if(indexPath.row == 1){
                NSString *location = ([profile objectForKey:@"location"] != [NSNull null]) ? [profile objectForKey:@"location"] :@"";
                locationCell.locationLabel.text = location;
                cell = locationCell;
            }
            else if(indexPath.row == 2){
                NSString *web = ([profile objectForKey:@"web"] != [NSNull null]) ? [profile objectForKey:@"web"] : @"";
                webCell.webLabel.text = web;
                cell = webCell;
            }
        }
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(profileLoaded)
        return 3;
    else 
        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == 0)
        return 110;
    else
        return 40;
}

- (void) loadProfile
{
    NSLog(@"Loading My Profile");
    NSURL *url = [NSURL URLWithString:[[TWAGConstants getServiceBaseURL] stringByAppendingString:@"users/profile"]] ;
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    NSError *requestError;
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if(error == nil){
            NSMutableDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSString* responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@", responseStr);
            profile = [[jsonResponse objectForKey:@"result"] objectForKey:@"User"];
            profileLoaded = YES;  
            [profileDetailsTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            
        }else {
            NSLog(@"%@", requestError);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Connection to Server Failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
        }
    }];
    
}

-(void)notifyProfileUpdate:(NSDictionary *) newprofile
{
    profile = newprofile;
    [profileDetailsTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

- (void)viewDidUnload
{
    [self setProfileImageTableView:nil];
    [self setProfileDetailsTableView:nil];
    [self setProfileImage:nil];
    [self setNameLabel:nil];
    [self setEmailLabel:nil];
    [self setJoinedOnLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
