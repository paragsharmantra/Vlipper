//
//  TWAGSentViewController.m
//  VlipperIphoneClient
//
//  Created by Parag Sharma on 17/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TWAGSentViewController.h"
#import "TWAGInboxViewController.h"
#import "MailTableCell.h"
#import "TWAGComoseViewController.h"
#import "TWAGUIImageView.h"
#import "TWAGPlayerViewController.h"
#import "TWAGConstants.h"

@interface TWAGSentViewController ()

@end

@implementation TWAGSentViewController
@synthesize mails;
@synthesize outboxTableView;
@synthesize searchBar;
@synthesize filteredMails;
@synthesize deleteImgView;
@synthesize swipedTableViewCell;
@synthesize swipedIndexPath;
@synthesize swipeDirection;
@synthesize playerController;
@synthesize profileImages;
@synthesize outboxDelegate;

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
    imageDownloadsInProgress = [NSMutableDictionary dictionary];
    
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

- (void) loadComposeScreen
{
    TWAGComoseViewController *compose = [TWAGComoseViewController alloc];
    [outboxDelegate windComposeWithOutboxViews:compose];
    UINavigationController *composeNav = [[UINavigationController alloc] initWithRootViewController:compose];
    [self presentModalViewController:composeNav animated:YES];
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
    
    for (int section = 0; section < [outboxTableView numberOfSections]; section++) {
        for (int row = 0; row < [outboxTableView numberOfRowsInSection:section]; row++) {
            NSIndexPath* cellPath = [NSIndexPath indexPathForRow:row inSection:section];
            MailTableCell* cell = (MailTableCell *)[outboxTableView cellForRowAtIndexPath:cellPath];
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Reloading data for outbox");
    NSString *CellIdentifier = [NSMutableString stringWithFormat:@"Cell-", indexPath.row];
    MailTableCell *cell = (MailTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) 
    {
        if(indexPath.row == swipedIndexPath.row && swipeDirection == @"right")
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MailTableCell" owner:self options:nil] objectAtIndex:1];
            cell.contentView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"swipe_options_bg.png"]];
            UISwipeGestureRecognizer *leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizeSwipe:)];
            [leftSwipeRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
            [cell addGestureRecognizer:leftSwipeRecognizer];
        }
        else 
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MailTableCell" owner:self options:nil] objectAtIndex:0];
        }
    }
    
    NSMutableDictionary *mail = [[filteredMails objectAtIndex:indexPath.row] objectForKey:@"Mail"];
    NSMutableDictionary *recipient = [[filteredMails objectAtIndex:indexPath.row] objectForKey:@"Recipient"];
    
    if(swipedIndexPath == nil || indexPath.row != swipedIndexPath.row || swipeDirection == @"left")
    {
        cell.nameLabel.text = [recipient objectForKey:@"name"];
        cell.subjectLabel.text = [mail objectForKey:@"subject"];
        cell.dateLabel.text = [TWAGInboxViewController getDateLabel:[mail objectForKey:@"created"]];
        NSString *recipientId = (NSString *)[recipient objectForKey:@"id"];
        
//        if([profileImages objectForKey:recipientId] == nil){
//            NSString *url = [NSString stringWithFormat:@"img/%@.jpg", recipientId];
//            NSURL *imageURL = [NSURL URLWithString:[[TWAGConstants getServiceBaseURL] stringByAppendingString:url]];
//            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
//            UIImage *image = [UIImage imageWithData:imageData];
//            [profileImages setValue:image forKey:recipientId];
//        }
        
        
//        cell.profileImage.image = [profileImages objectForKey:recipientId];
        ProfileRecord *profileRecord = [profileImages valueForKey:[recipient objectForKey:@"id"]];
        
        if (!profileRecord.profileIcon){
            if (outboxTableView.dragging == NO && outboxTableView.decelerating == NO){
                [self startIconDownload:profileRecord forIndexPath:indexPath];
            }
            cell.imageView.image = [UIImage imageNamed:@"Placeholder.png"];                
        }else{
            cell.imageView.image = profileRecord.profileIcon;
        }
        
        UISwipeGestureRecognizer *rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizeSwipe:)];
        [rightSwipeRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [cell addGestureRecognizer:rightSwipeRecognizer];
        cell.contentView.backgroundColor =  [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"message_single_bg.png"]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"message_single_bg_active.png"]];
        
        if(uploadInProgress && indexPath.row == 0){
            cell.progressView.hidden = NO;
            cell.dateLabel.hidden = YES;
            dateLabel = cell.dateLabel;
            progressView = cell.progressView;
        }
        
    }
    
    return cell;
}

- (void) recognizeSwipe:(UISwipeGestureRecognizer *)recognizer
{
    if(swipedIndexPath != nil)
    {
        swipeDirection = @"left";
        [outboxTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:swipedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    CGPoint swipeLocation = [recognizer locationInView:outboxTableView];
    swipedIndexPath = [outboxTableView indexPathForRowAtPoint:swipeLocation];
    swipedTableViewCell = [outboxTableView cellForRowAtIndexPath:swipedIndexPath];
    
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
        swipeDirection = @"right";
        [outboxTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:swipedIndexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
    else if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        swipeDirection = @"left";
        [outboxTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:swipedIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
    
}

- (void) loadMail:(UITapGestureRecognizer *)recognizer
{
    CGPoint swipeLocation = [recognizer locationInView:outboxTableView];
    NSIndexPath *tappedIndexPath = [outboxTableView indexPathForRowAtPoint:swipeLocation];
    UITableViewCell *tappedTableViewCell = [outboxTableView cellForRowAtIndexPath:tappedIndexPath];
    tappedTableViewCell.contentView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"message_single_bg_active.png"]];
    TWAGComoseViewController *compose = [TWAGComoseViewController alloc];
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

- (void) loadOutbox
{
    NSLog(@"Loading Outbox");
    NSURL *url = [NSURL URLWithString:[[TWAGConstants getServiceBaseURL] stringByAppendingString:@"mails/sent_mails"]] ;
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    NSError *requestError;
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if(error == nil){
//            NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            NSLog(@"%@", json_string);
            NSMutableDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSNumber *status = [jsonResponse objectForKey:@"status"];
            if([status intValue] == 200){
                mails = [jsonResponse objectForKey:@"result"];
                NSLog(@"%@", jsonResponse);
                filteredMails = mails;
                
                for (NSDictionary *mail in filteredMails) {
                    ProfileRecord *profileRecord = [ProfileRecord alloc];
                    NSMutableDictionary *sender = [mail objectForKey:@"Recipient"];
                    
                    NSString *url = [NSString stringWithFormat:@"img/%@.jpg", [sender objectForKey:@"id"]];
                    url = [[TWAGConstants getServiceBaseURL] stringByAppendingString:url];
                    [profileRecord setImageURLString:url];
                    [profileImages setValue:profileRecord forKey:[sender objectForKey:@"id"]];
                }
                
                [outboxTableView reloadData];
            }else if([status intValue] == 403){
            
            }
            
        }else {
            NSLog(@"%@", requestError);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Connection to Server Failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];

}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if([searchText length] == 0)
    {
        filteredMails = mails;
        [outboxTableView reloadData];
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
        [outboxTableView reloadData];
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
    
    [outboxTableView scrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
    
	[outboxTableView scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[outboxTableView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}


- (void)refresh {
    [self loadOutbox];
}

-(void)displayJustSentMailWithSubject:(NSString *)subject forRecipientId:(NSString *) recipientId forRecipientName:(NSString *) recipientName
{
    NSLog(@"displayJustSentMail invoked");
    NSDictionary *mailObj = [NSMutableDictionary dictionaryWithCapacity:1];
    [mailObj setValue:@"default" forKey:@"created"];
    [mailObj setValue:subject forKey:@"subject"];

    NSDictionary *recipientObj = [NSMutableDictionary dictionaryWithCapacity:1];
    [recipientObj setValue:recipientName forKey:@"name"];
    [recipientObj setValue:recipientId forKey:@"id"];
    
    NSDictionary *obj = [NSMutableDictionary dictionaryWithCapacity:1];
    [obj setValue:mailObj forKey:@"Mail"];
    [obj setValue:recipientObj forKey:@"Recipient"];
    
    if(filteredMails == nil || [filteredMails count] == 0){
        filteredMails = [NSMutableArray arrayWithCapacity:1];
    }
    [filteredMails insertObject:obj atIndex:0];
    NSArray *indexPath = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
    uploadInProgress = YES;
    [outboxTableView insertRowsAtIndexPaths:indexPath withRowAnimation:UITableViewRowAnimationTop];
}

-(void)updateUploadCellToProgressPercentage:(float) percentage
{
    [progressView setProgress:percentage animated:YES];
    if(percentage == 1){
        uploadInProgress = NO;
        progressView.hidden = YES;
        NSDate *now = [NSDate date];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSString *dateStr = [TWAGInboxViewController getDateLabel:[format stringFromDate:now]];
        dateLabel.text = dateStr;
        dateLabel.hidden = NO;
    }
}


- (void)loadImagesForOnscreenRows
{
    if ([filteredMails count] > 0)
    {
        NSArray *visiblePaths = [outboxTableView indexPathsForVisibleRows];
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
        UITableViewCell *cell = [outboxTableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        
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
