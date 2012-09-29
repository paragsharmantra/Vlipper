//
//  TWAGContactsViewController.m
//  VlipperIphoneClient
//
//  Created by Parag Sharma on 18/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TWAGContactsViewController.h"

@interface TWAGContactsViewController ()

@end

@implementation TWAGContactsViewController
@synthesize contactsTableView;
@synthesize profileImages;

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
    imageDownloadsInProgress = [NSMutableDictionary dictionary];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topbar.png"] forBarMetrics:UIBarMetricsDefault];
    
    UIImageView *viewContactRequestsImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add_active.png"]];
    UIBarButtonItem *viewContactRequestsButton = [[UIBarButtonItem alloc] initWithCustomView:viewContactRequestsImgView];
    viewContactRequestsImgView.userInteractionEnabled = YES;
    self.navigationItem.leftBarButtonItem = viewContactRequestsButton;
    
    UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadViewContactRequestsScreen)];
    [viewContactRequestsImgView addGestureRecognizer:tap0];
    
    UIImageView *addContactImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add_active.png"]];
    UIBarButtonItem *addContactButton = [[UIBarButtonItem alloc] initWithCustomView:addContactImgView];
    addContactImgView.userInteractionEnabled = YES;
    self.navigationItem.rightBarButtonItem = addContactButton;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadAddContactScreen)];
    [addContactImgView addGestureRecognizer:tap];
   
    [self loadContacts];
}

- (void) loadAddContactScreen
{
//        if(addContactsViewController == nil){
//            addContactsViewController = [AddContactsViewController alloc];
//        }
//        UINavigationController *addContactNav = [[UINavigationController alloc] initWithRootViewController:addContactsViewController];
//        [self presentModalViewController:addContactNav animated:YES];
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add an Email", @"Import from Iphone", nil];
    [sheet showFromTabBar:self.tabBarController.tabBar];
    
}

- (void) loadViewContactRequestsScreen
{
    
    UINavigationController *viewContactRequestsNav = [[UINavigationController alloc] initWithRootViewController:[ViewContactRequestsViewController alloc]];
    [self presentModalViewController:viewContactRequestsNav animated:YES];
}


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button %d", buttonIndex);
    if(buttonIndex == 0){
        if(addContactsViewController == nil){
            addContactsViewController = [AddContactsViewController alloc];
            addContactsViewController.addContactsDelegate = self;
        }
        UINavigationController *addContactNav = [[UINavigationController alloc] initWithRootViewController:addContactsViewController];
        [self presentModalViewController:addContactNav animated:YES];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        NSMutableDictionary *friend = [[[friendsSectioned objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"users"];
        NSString *approved = (NSString *)[[[[friendsSectioned objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"friends"] objectForKey:@"approved"];
    
        ContactTableCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"AddContactCells" owner:self options:nil] objectAtIndex:1];
        cell.name.text = [friend objectForKey:@"name"];
        if([approved isEqualToString:@"0"]){
            cell.awaitingApproval.hidden = NO;
        }
        ProfileRecord *profileRecord = [entries valueForKey:[friend objectForKey:@"id"]];
            
        if (!profileRecord.profileIcon){
            if (contactsTableView.dragging == NO && contactsTableView.decelerating == NO){
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
    NSLog(@"Loading Inbox");
    NSURL *url = [NSURL URLWithString:[[TWAGConstants getServiceBaseURL] stringByAppendingString:@"users/friends"]] ;
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
//            NSLog(@"%@", indexes);
//            NSLog(@"%@", titles);
//            NSLog(@"%@", entries);
            
            [contactsTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
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



- (void)viewDidUnload
{
    [self setContactsTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)contactAdded{
    [self loadContacts];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if(friends.count < 6)
        return nil;
    else {
//        return [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
        return titles;
    }
}

//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
//    if ([titles indexOfObject:title] != NSNotFound) {
//        NSLog(@"Title : %@", title);
//        NSLog(@"Section : %i", [titles indexOfObject:title]);
//        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:[titles indexOfObject:title]] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//        return [titles indexOfObject:title];
//    }    
//    return -1;
//}

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
        NSArray *visiblePaths = [contactsTableView indexPathsForVisibleRows];
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
        UITableViewCell *cell = [contactsTableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        
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


@end
