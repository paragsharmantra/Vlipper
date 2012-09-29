//
//  TWAGComoseViewController.m
//  VlipperIphoneClient
//
//  Created by Parag Sharma on 18/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TWAGComoseViewController.h"
#import "TWAGRecordingViewController.h"
#import "TWAGConstants.h"

@interface TWAGComoseViewController ()

@end

@implementation TWAGComoseViewController
@synthesize recordImageView;
@synthesize videoUrl;
@synthesize toTextField;
@synthesize subjectTextField;
@synthesize composeDelegate;
@synthesize mailId;
@synthesize type;
@synthesize email;
@synthesize subject;
@synthesize autoCompleteTableView;

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
    
    UIImageView *sendImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"send.png"]];
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithCustomView:sendImgView];
    sendImgView.userInteractionEnabled = YES;
    self.navigationItem.rightBarButtonItem = sendButton;
    
    UITapGestureRecognizer *sendTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendThisMessage)];
    [sendImgView addGestureRecognizer:sendTapRecognizer];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startRecording)];
    [recordImageView setUserInteractionEnabled:YES];
    [recordImageView addGestureRecognizer:tapRecognizer];
    
    autoCompleteTableView = [[AutoCompleteTableView alloc] initWithFrame:CGRectMake(0, 60, 320, 120) style:UITableViewStylePlain];
    autoCompleteDelegate = [[AutoCompleteDelegate alloc] init];
    autoCompleteTableView.tag = 12;
    autoCompleteTableView.delegate = autoCompleteDelegate;
    autoCompleteTableView.dataSource = autoCompleteDelegate;
    autoCompleteTableView.scrollEnabled = YES;
    autoCompleteTableView.hidden = YES;  
    autoCompleteDelegate.autoCompleteTableView = autoCompleteTableView;
    [self.view addSubview:autoCompleteTableView];
}

- (void) dismissThisView{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) sendThisMessage{
    //code to send the message
    NSData *webData = [NSData dataWithContentsOfURL:videoUrl];
    NSLog(@"%@", videoUrl);
    if(mailId == nil) mailId = @"";
    if(type == nil) type = @"";
    if(webData != nil && autoCompleteDelegate.reciepientId != nil){
//        NSLog(@"Recipient Id is : %@", autoCompleteDelegate.reciepientId);
        NSDictionary *dict = [[NSDictionary alloc]initWithObjects:[NSArray arrayWithObjects:webData, autoCompleteDelegate.reciepientId, subjectTextField.text, mailId, type, nil] forKeys:[NSArray arrayWithObjects:@"media", @"to", @"subject", @"mailId", @"type", nil]];
//        NSLog(@"%@", dict);
        [self post:dict];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (NSData *)generatePostDataForData:(NSDictionary *)uploadData
{
    NSData *media = [uploadData objectForKey:@"media"];
    NSString *to = [uploadData objectForKey:@"to"];
    NSString *subject = [uploadData objectForKey:@"subject"];
    
    // Generate the post header:
    NSString *stringBoundary = @"0xKhTmLbOuNdArY---This_Is_ThE_BoUnDaRyy---pqo";
    NSMutableData *postData = [NSMutableData data];
    
    //Add the fields
    [postData appendData: [[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"to\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[to dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]]; 
    
    [postData appendData: [[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"subject\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[subject dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]]; 
    
    // Add the media:
    [postData appendData: [[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"media\"; filename=\"%@\"\r\n", @"media.MOV"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"Content-Type: application/octet-stream\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData: media];
    [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]]; 
    
    // Add the closing boundry:
    [postData appendData: [[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]];
    
    // Return the post data:
    return postData;
}

- (void)post:(NSDictionary *)fileData
{
    NSLog(@"POSTING");
    // Generate the postdata:
    NSData *postData = [self generatePostDataForData: fileData];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSString *stringBoundary = @"0xKhTmLbOuNdArY---This_Is_ThE_BoUnDaRyy---pqo";
    NSString *headerBoundary = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
    
    // Setup the request:
    NSURL *url = [NSURL URLWithString:[[TWAGConstants getServiceBaseURL] stringByAppendingString:@"mails/send"]] ;
    NSMutableURLRequest *uploadRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy: NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    [uploadRequest setHTTPMethod:@"POST"];
    [uploadRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [uploadRequest setValue:headerBoundary forHTTPHeaderField:@"Content-Type"];
    [uploadRequest setHTTPBody:postData];
    
    // Execute the reqest: 
    [NSURLConnection connectionWithRequest:uploadRequest delegate:self];
    
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    [NSURLConnection sendAsynchronousRequest:uploadRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
//     {
//         if ([data length] > 0 && error == nil){
//             NSString* response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//             NSLog(@"%@", response);
//             NSString *result =[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//             NSLog(@"%@", result);
//         }else if (error != nil){
//             NSLog(@"%@", error);
//         }
//     }];

    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Response Recieved");

}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    if(!uploadInProgress){
        NSLog(@"invoking displayJustSentMail");
        [composeDelegate displayJustSentMailWithSubject:subjectTextField.text forRecipientId:autoCompleteDelegate.reciepientId forRecipientName:autoCompleteDelegate.reciepientName];
        uploadInProgress = YES;
    }
    float progress = ((float)totalBytesWritten)/((float)totalBytesExpectedToWrite);
    [composeDelegate updateUploadCellToProgressPercentage:progress];
    if(totalBytesWritten == totalBytesExpectedToWrite)
        uploadInProgress = NO;
    
    NSLog(@"Upload Progress, Written %i of %i", totalBytesWritten, totalBytesExpectedToWrite);
    NSLog(@"Progress : %f", progress);
}

- (void) startRecording
{
    NSLog(@"record start request");
    TWAGRecordingViewController *recorder = [TWAGRecordingViewController alloc];
    recorder.recorderDelegate = self;
    [self.navigationController pushViewController:recorder animated:YES];
}

- (void)viewDidUnload
{
    [self setRecordImageView:nil];
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
    NSString *CellIdentifier = [NSMutableString stringWithFormat:@"Cell-", indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) 
    {
        if(indexPath.row == 0){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ComposeScreenCells" owner:self options:nil] objectAtIndex:0];
            toTextField = (UITextField *)[cell viewWithTag:1];
            toTextField.text = email;
            toTextField.delegate = autoCompleteDelegate;
        }else {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ComposeScreenCells" owner:self options:nil] objectAtIndex:1];
            subjectTextField = (UITextField *)[cell viewWithTag:1];
            subjectTextField.text = subject;
        }
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(void)cancel
{
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topbar.png"] forBarMetrics:UIBarMetricsDefault];
}

-(void)videoReady:(NSURL *) url
{
    videoUrl = url;
    [recordImageView setImage:[UIImage imageNamed:@"video_message_uploaded.png"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"view appeared");
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topbar.png"] forBarMetrics:UIBarMetricsDefault];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
}

@end
