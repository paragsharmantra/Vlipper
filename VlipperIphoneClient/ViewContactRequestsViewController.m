//
//  ViewContactRequestsViewController.m
//  VlipperIphoneClient
//
//  Created by Parag Sharma on 03/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewContactRequestsViewController.h"

@interface ViewContactRequestsViewController ()

@end

@implementation ViewContactRequestsViewController
@synthesize contactRequestsTableView;

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
    
    imageDownloadsInProgress = [NSMutableDictionary dictionary];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topbar.png"] forBarMetrics:UIBarMetricsDefault];
    
    UIImageView *cancelImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cancel_button.png"]];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithCustomView:cancelImgView];
    cancelImgView.userInteractionEnabled = YES;
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UITapGestureRecognizer *cancelTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissThisView)];
    [cancelImgView addGestureRecognizer:cancelTapRecognizer];

    
    contactRequestsTableView.delegate = self;
    [self loadContacts];

}

- (void) dismissThisView{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidUnload
{
    [self setContactRequestsTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *friend = [[[friendsSectioned objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"users"];
    
    ContactTableCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"AddContactCells" owner:self options:nil] objectAtIndex:1];
    cell.name.text = [friend objectForKey:@"name"];
    ProfileRecord *profileRecord = [entries valueForKey:[friend objectForKey:@"id"]];
    cell.viewImage.hidden = NO;
    if (!profileRecord.profileIcon){
        if (contactRequestsTableView.dragging == NO && contactRequestsTableView.decelerating == NO){
            [self startIconDownload:profileRecord forIndexPath:indexPath];
        }
        cell.imageView.image = [UIImage imageNamed:@"Placeholder.png"];                
    }else{
        cell.imageView.image = profileRecord.profileIcon;
    }
    
    return cell;
}


- (void) loadContacts
{
    NSLog(@"Loading contact requests");
    NSURL *url = [NSURL URLWithString:[[TWAGConstants getServiceBaseURL] stringByAppendingString:@"users/friend_requests"]] ;
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    NSError *requestError;
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if(error == nil){
            NSMutableDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSString* responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@", responseStr);
            friends = [jsonResponse objectForKey:@"result"];
            friendsSectioned = [[NSMutableArray alloc] init];
            entries = [[NSMutableDictionary alloc]init];
            titles = [[NSMutableArray alloc] init];
            indexes = [[NSMutableArray alloc] init];
            int i = -1;
            for (NSMutableDictionary *friend in friends) {
                NSMutableDictionary *friendObj = [friend objectForKey:@"users"];
                NSString *name = [NSMutableString stringWithFormat:@"%@", [friendObj objectForKey:@"name"]];
                
                ProfileRecord *profileRecord = [ProfileRecord alloc];
                NSString *url = [NSString stringWithFormat:@"img/%@.jpg", [friendObj objectForKey:@"id"]];
                url = [[TWAGConstants getServiceBaseURL] stringByAppendingString:url];
                [profileRecord setImageURLString:url];
                [entries setValue:profileRecord forKey:[friendObj objectForKey:@"id"]];
                
                if([titles indexOfObject:[name substringToIndex:1]] != NSNotFound){
                    NSInteger newcount = [((NSNumber *)[indexes objectAtIndex:i]) intValue]+1;
                    [indexes replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:newcount]];
                    NSMutableArray *localFriends = [friendsSectioned objectAtIndex:i];
                    [localFriends addObject:friend];
                    [friendsSectioned replaceObjectAtIndex:i withObject:localFriends];
                }else {
                    i++;
                    [titles addObject:[name substringToIndex:1]];
                    [indexes addObject:[NSNumber numberWithInt:1]];
                    [friendsSectioned addObject:[NSMutableArray arrayWithObject:friend]];
                }
            }
                    [contactRequestsTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        }else {
            NSLog(@"%@", requestError);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Connection to Server Failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
        }
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return titles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [((NSNumber *)[indexes objectAtIndex:section]) intValue];
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if(friends.count < 6)
        return nil;
    else {
        return titles;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [titles objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (void)loadImagesForOnscreenRows
{
    if ([friends count] > 0)
    {
        NSArray *visiblePaths = [contactRequestsTableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            NSDictionary *friend = [[friendsSectioned objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            ProfileRecord *profileRecord = [entries objectForKey:[[friend valueForKey:@"users"] valueForKey:@"id"]];
            if (!profileRecord.profileIcon) // avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:profileRecord forIndexPath:indexPath];
            }
        }
    }
}


- (void)startIconDownload:(ProfileRecord *)profileRecord forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil) 
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.profileRecord = profileRecord;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];  
    }
}


- (void)profileImageDidLoad:(NSIndexPath *)indexPath{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
        UITableViewCell *cell = [contactRequestsTableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        
        // Display the newly loaded image
        cell.imageView.image = iconDownloader.profileRecord.profileIcon;
    }
    
    // Remove the IconDownloader from the in progress list.
    // This will result in it being deallocated.
    [imageDownloadsInProgress removeObjectForKey:indexPath];
}

#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactViewController *controller = [ContactViewController alloc];
    controller.contactsDelegate = self;
    controller.profile = [[friendsSectioned objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]; 
    UINavigationController *viewContactNav = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentModalViewController:viewContactNav animated:YES];
    
}

-(void)reloadContactRequests
{
    [self loadContacts];
}


@end
