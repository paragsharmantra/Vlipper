//
//  TWAGInboxViewController.m
//  VlipperIphoneClient
//
//  Created by Parag Sharma on 17/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TWAGInboxViewController.h"
#import "MailTableCell.h"
#import "TWAGComoseViewController.h"
#import "TWAGUIImageView.h"
#import "TWAGPlayerViewController.h"
#import "TWAGConstants.h"
#import "SwipedTableCell.h"

@interface TWAGInboxViewController ()

@end

@implementation TWAGInboxViewController
@synthesize mails;
@synthesize inboxTableView;
@synthesize searchBar;
@synthesize filteredMails;
@synthesize deleteImgView;
@synthesize swipedTableViewCell;
@synthesize swipedIndexPath;
@synthesize swipeDirection;
@synthesize playerController;
@synthesize profileImages;
@synthesize outboxDelegate;
@synthesize swipedMail;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topbar.png"] forBarMetrics:UIBarMetricsDefault];

    UIImageView *composeImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"compose_new.png"]];
    UIBarButtonItem *composeButton = [[UIBarButtonItem alloc] initWithCustomView:composeImgView];
    composeImgView.userInteractionEnabled = YES;
    self.navigationItem.rightBarButtonItem = composeButton;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadComposeScreen)];
    [composeImgView addGestureRecognizer:tap];
    
    deleteImgView = [[TWAGUIImageView alloc] initWithImage:[UIImage imageNamed:@"trash_button.png"]];
    deleteImgView.imageSrc = @"trash_button.png";
    deleteImgView.userInteractionEnabled = YES;
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithCustomView:deleteImgView];
    self.navigationItem.leftBarButtonItem = deleteButton;
    
    UITapGestureRecognizer *deleteTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDeleteButtons)];
    [deleteImgView addGestureRecognizer:deleteTap];
    
    inboxTableView.pullRefreshDelegate = self;
    imageDownloadsInProgress = [NSMutableDictionary dictionary];
}

- (void) loadComposeScreen:(NSString *)email subject:(NSString *)subject sourceMail:(NSString *)mailId forType:(NSString *)type
{
    
    compose = [TWAGComoseViewController alloc];
    [outboxDelegate windComposeWithOutboxViews:compose];
    
    if(email != nil){
        compose.email = email;
    }
    if(mailId != nil)
        compose.mailId = mailId;
    if(type != nil)
        compose.type = type;
    if(subject != nil)
        compose.subject = subject;
        
    UINavigationController *composeNav = [[UINavigationController alloc] initWithRootViewController:compose];
    [self presentModalViewController:composeNav animated:YES];
}

- (void) loadComposeScreen
{
    @try {
        if(compose == nil){
            compose = [TWAGComoseViewController alloc];
            [outboxDelegate windComposeWithOutboxViews:compose];
        }
        UINavigationController *composeNav = [[UINavigationController alloc] initWithRootViewController:compose];
        [self presentModalViewController:composeNav animated:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
}


- (void) showDeleteButtons
{
    if(deleteImgView.imageSrc == @"trash_button_active.png")
    {
        deleteImgView.image = [UIImage imageNamed:@"trash_button.png"];
        deleteImgView.imageSrc = @"trash_button.png";
    }else {
        deleteImgView.image = [UIImage imageNamed:@"trash_button_active.png"];
        deleteImgView.imageSrc = @"trash_button_active.png";
    }
    
    for (int section = 0; section < [inboxTableView numberOfSections]; section++) {
        for (int row = 0; row < [inboxTableView numberOfRowsInSection:section]; row++) {
            NSIndexPath* cellPath = [NSIndexPath indexPathForRow:row inSection:section];
            MailTableCell* cell = (MailTableCell *)[inboxTableView cellForRowAtIndexPath:cellPath];
            if(deleteImgView.imageSrc == @"trash_button_active.png")
            {
                [cell.dateLabel setHidden:YES];
                [cell.deleteButton setHidden:NO];
            }else {
                [cell.dateLabel setHidden:NO];
                [cell.deleteButton setHidden:YES];
            }
        }
    }
}

- (void)viewDidUnload
{
    [self setInboxTableView:nil];
    [self setSearchBar:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
        
    if(swipedIndexPath != nil && indexPath.row == swipedIndexPath.row && swipeDirection == @"right"){
        SwipedTableCell *swipedCell = (SwipedTableCell *)[inboxTableView dequeueReusableCellWithIdentifier:@"swiped"];
        if(swipedCell == nil){
            swipedCell = [[[NSBundle mainBundle] loadNibNamed:@"MailTableCell" owner:self options:nil] objectAtIndex:1];
            
            UIGestureRecognizer *deleteGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recognizeDeleteTap:)];
            UIGestureRecognizer *playGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recognizePlayTap:)];
            UIGestureRecognizer *replyGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recognizeReplyTap:)];
            
            [swipedCell.deleteSwipeButton setTag:indexPath.row];
            [swipedCell.deleteSwipeButton addGestureRecognizer:deleteGestureRecognizer];
            [swipedCell.playSwipeButton addGestureRecognizer:playGestureRecognizer];
            [swipedCell.replySwipeButton addGestureRecognizer:replyGestureRecognizer];
            
            swipedCell.contentView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"swipe_options_bg.png"]];
            UISwipeGestureRecognizer *leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizeSwipe:)];
            [leftSwipeRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
            [swipedCell addGestureRecognizer:leftSwipeRecognizer];
            cell = swipedCell;
        }else {
            cell = swipedCell;
        }
    }else {
        cell = (MailTableCell *)[inboxTableView dequeueReusableCellWithIdentifier:@"normal"];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MailTableCell" owner:self options:nil] objectAtIndex:0];   
        }
    }

    NSMutableDictionary *mail = [[filteredMails objectAtIndex:indexPath.row] objectForKey:@"Mail"];
    NSMutableDictionary *sender = [[filteredMails objectAtIndex:indexPath.row] objectForKey:@"Sender"];
 
    if(swipedIndexPath == nil || indexPath.row != swipedIndexPath.row || swipeDirection == @"left"){
        MailTableCell *mailTableCell = (MailTableCell *)cell;
        mailTableCell.nameLabel.text = [sender objectForKey:@"name"];
        mailTableCell.subjectLabel.text = [mail objectForKey:@"subject"];
        mailTableCell.dateLabel.text = [TWAGInboxViewController getDateLabel:[mail objectForKey:@"created"]];
        ProfileRecord *profileRecord = [profileImages valueForKey:[sender objectForKey:@"id"]];
        
        if (!profileRecord.profileIcon){
            if (inboxTableView.dragging == NO && inboxTableView.decelerating == NO){
                [self startIconDownload:profileRecord forIndexPath:indexPath];
            }
            cell.imageView.image = [UIImage imageNamed:@"Placeholder.png"];                
        }else{
            cell.imageView.image = profileRecord.profileIcon;
        }
        
        
        UISwipeGestureRecognizer *rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizeSwipe:)];
        [rightSwipeRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [mailTableCell addGestureRecognizer:rightSwipeRecognizer];
        mailTableCell.contentView.backgroundColor =  [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"message_single_bg.png"]];
        mailTableCell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"message_single_bg_active.png"]];
        cell = mailTableCell;

    }
    return cell;
}

+ (NSString *) getDateLabel:(NSString *)date
{

    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *mailSentDateObj = [format dateFromString:date];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"hh:mm"];
    
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString *mailSentDate = [format stringFromDate:mailSentDateObj];
    NSString *mailSentTime = [timeFormat stringFromDate:mailSentDateObj];
    
    NSDateFormatter *dateOnlyformat = [[NSDateFormatter alloc] init];
    [dateOnlyformat setDateFormat:@"yyyy-MM-dd"];
    NSDate *now = [[NSDate alloc] init];
    NSString *todaysDate = [dateOnlyformat stringFromDate:now];
   
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSHourCalendarUnit) fromDate:[[NSDate alloc] init]];
    [components setHour:-24];
    NSDate *yesterday = [cal dateByAddingComponents:components toDate: now options:0];
    NSString *yesterdayDateString = [dateOnlyformat stringFromDate:yesterday];
    
    
    NSString *returnStr;
    
    if([mailSentDate isEqualToString:todaysDate]){
        returnStr = [@"Today, " stringByAppendingString:mailSentTime];
    }else if([mailSentDate isEqualToString:yesterdayDateString]){
        returnStr = @"Yesterday";
    }else {
        [format setDateFormat:@"dd/MM/yyyy"];
        returnStr = [format stringFromDate:mailSentDateObj];
    }
    
    return returnStr;
}

- (void) recognizeDeleteTap:(UISwipeGestureRecognizer *)recognizer
{
    CGPoint swipeLocation = [recognizer locationInView:inboxTableView];
    NSIndexPath *index = [inboxTableView indexPathForRowAtPoint:swipeLocation];
    NSDictionary *dict = [filteredMails objectAtIndex:index.row];
    NSString *id = [[dict objectForKey:@"Mail"] objectForKey:@"id"];
    NSLog(@"deleting %@", id);
    [filteredMails removeObjectAtIndex:index.row];
    [inboxTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationTop];
    swipedIndexPath = nil;
    
    NSString *deleteURL = [NSString stringWithFormat:@"mails/delete_from_inbox/%@", id];
    NSURL *url = [NSURL URLWithString:[[TWAGConstants getServiceBaseURL] stringByAppendingString:deleteURL]] ;
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    NSError *requestError;
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if(error == nil){
            
        }else {
            NSLog(@"%@", requestError);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Connection to Server Failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
        }
    }];

}

- (void) recognizePlayTap:(UISwipeGestureRecognizer *)recognizer
{
    CGPoint swipeLocation = [recognizer locationInView:inboxTableView];
    NSIndexPath *index = [inboxTableView indexPathForRowAtPoint:swipeLocation];
    [self tableView:inboxTableView didSelectRowAtIndexPath:index];
}

- (void) recognizeReplyTap:(UISwipeGestureRecognizer *) recognizer
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Reply", @"Forward", nil];
    [sheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button %d", buttonIndex);
    NSString *email = [[swipedMail objectForKey:@"Sender"] objectForKey:@"email"];
    NSString *subject = [[swipedMail objectForKey:@"Mail"] objectForKey:@"subject"];
    NSString *mailId = [[swipedMail objectForKey:@"Mail"] objectForKey:@"id"];
    if(buttonIndex == 0){
        [self loadComposeScreen:email subject:subject sourceMail:mailId forType:@"reply"];
    }else if(buttonIndex == 1){
        [self loadComposeScreen:nil subject:subject sourceMail:mailId forType:@"forward"];
    }
}

- (void) recognizeSwipe:(UISwipeGestureRecognizer *)recognizer
{
    if(swipedIndexPath != nil)
    {
        swipeDirection = @"left";
        [inboxTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:swipedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    CGPoint swipeLocation = [recognizer locationInView:inboxTableView];
    swipedIndexPath = [inboxTableView indexPathForRowAtPoint:swipeLocation];
    swipedTableViewCell = [inboxTableView cellForRowAtIndexPath:swipedIndexPath];
    
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
        swipeDirection = @"right";
        NSLog(@"%i", swipedIndexPath.row);
        swipedMail = [filteredMails objectAtIndex:swipedIndexPath.row];

        [inboxTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:swipedIndexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
    else if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        swipeDirection = @"left";
        [inboxTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:swipedIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
        swipedIndexPath = nil;
    }
    
}

- (void) loadMail:(UITapGestureRecognizer *)recognizer
{
    CGPoint swipeLocation = [recognizer locationInView:inboxTableView];
    NSIndexPath *tappedIndexPath = [inboxTableView indexPathForRowAtPoint:swipeLocation];
    UITableViewCell *tappedTableViewCell = [inboxTableView cellForRowAtIndexPath:tappedIndexPath];
    tappedTableViewCell.contentView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"message_single_bg_active.png"]];
    if(compose == nil){
        compose = [TWAGComoseViewController alloc];
    }
    [self.navigationController pushViewController:compose animated:YES];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([filteredMails isKindOfClass:[NSNull class]])
        return 0;
    else {
        return [filteredMails count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (void) loadInbox
{
    NSLog(@"Loading Inbox");
    NSURL *url = [NSURL URLWithString:[[TWAGConstants getServiceBaseURL] stringByAppendingString:@"mails/inbox"]] ;
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    NSError *requestError;
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if(error == nil){
            NSMutableDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSString* responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@", responseStr);
            NSNumber *status = [jsonResponse objectForKey:@"status"];
            if([status intValue] == 200){
                mails = [jsonResponse objectForKey:@"result"];
                filteredMails = mails;
                
                for (NSDictionary *mail in filteredMails) {
                    ProfileRecord *profileRecord = [ProfileRecord alloc];
                    NSMutableDictionary *sender = [mail objectForKey:@"Sender"];
                    
                    NSString *url = [NSString stringWithFormat:@"img/%@.jpg", [sender objectForKey:@"id"]];
                    url = [[TWAGConstants getServiceBaseURL] stringByAppendingString:url];
                    [profileRecord setImageURLString:url];
                    [profileImages setValue:profileRecord forKey:[sender objectForKey:@"id"]];
                }
                
                [inboxTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                [inboxTableView performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];
            }else if ([status intValue] == 403) {
                [self performSelectorOnMainThread:@selector(showLaunchScreen) withObject:nil waitUntilDone:YES];
            }
            
        }else {
            NSLog(@"%@", requestError);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Connection to Server Failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [inboxTableView stopLoading];
            [alert show];
            
        }
    }];
    
}
            
- (void) showLaunchScreen{
    LaunchViewController *launchViewController = [[LaunchViewController alloc] initWithNibName:@"LaunchViewController" bundle:nil];
    UINavigationController *launchNav = [[UINavigationController alloc] initWithRootViewController:launchViewController];
    [self presentModalViewController:launchNav animated:YES];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if([searchText length] == 0)
    {
        filteredMails = mails;
        [inboxTableView reloadData];
    }else {
        NSMutableArray *filteredResults = [[NSMutableArray alloc] initWithCapacity:1];
        for (NSDictionary *obj in mails) {
            NSDictionary *sender = [obj objectForKey:@"Sender"];
            NSDictionary *mail = [obj objectForKey:@"Mail"];
            
            NSString *name = [[sender objectForKey:@"name"] lowercaseString];
            NSString *subject = [[mail objectForKey:@"subject"] lowercaseString];
            
            if([name hasPrefix:[searchText lowercaseString]] || [subject hasPrefix:[searchText lowercaseString]])
                [filteredResults addObject:obj];
            }
        filteredMails = filteredResults;
        [inboxTableView reloadData];
    }
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)sender
{
    [sender resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    playerController = [TWAGPlayerViewController alloc];
    NSDictionary *obj = [filteredMails objectAtIndex:indexPath.row];
    NSDictionary *mail = [obj objectForKey:@"Mail"];
    playerController.mailId = [mail objectForKey:@"id"];
    playerController.playerDelegate = self;
    //    [self.navigationController pushViewController:player animated:YES];
    //[self presentViewController:playerController animated:YES completion:nil];
    [self presentModalViewController:playerController animated:YES];
    
}

-(void)back
{
    NSLog(@"Back Button Request");
    [self dismissModalViewControllerAnimated:YES];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [inboxTableView scrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
    
	[inboxTableView scrollViewDidScroll:scrollView];
//    NSArray *visibleCells = inboxTableView.visibleCells;
//    for (MailTableCell *cell in visibleCells) {
//        [cell redisplay];
//    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
    [inboxTableView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    
}


- (void)refresh {
    [self loadInbox];
}



- (void)loadImagesForOnscreenRows
{
    if ([filteredMails count] > 0)
    {
        NSArray *visiblePaths = [inboxTableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            NSMutableDictionary *sender = [[filteredMails objectAtIndex:indexPath.row] objectForKey:@"Sender"];
            ProfileRecord *profileRecord = [profileImages objectForKey:[sender valueForKey:@"id"]];
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
        UITableViewCell *cell = [inboxTableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        
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

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}



@end
