//
//  ProfileEditController.m
//  VlipperIphoneClient
//
//  Created by Parag Sharma on 22/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileEditController.h"

@interface ProfileEditController ()

@end

@implementation ProfileEditController
@synthesize profileImageTableView;
@synthesize profileDetailsTableView;
@synthesize profile;
@synthesize profileImage;
@synthesize profileEditDelegate;

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
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(dismissThisView)];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iphone_bg6.png"]];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveProfile)];
    self.navigationItem.rightBarButtonItem = saveButton;
}


- (void) dismissThisView{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) saveProfile{
    NSString *imgURL = @"img url";
//    NSData *webData = [NSData dataWithContentsOfURL:imgURL];
    NSLog(@"%@", imgURL);
    
    NSDictionary *dict = [[NSDictionary alloc]initWithObjects:[NSArray arrayWithObjects:[profile objectForKey:@"id"], nameCell.nameLabel.text, aboutMeCell.aboutMeLabel.text, locationCell.locationLabel.text, webCell.webLabel.text, nil] forKeys:[NSArray arrayWithObjects:@"id", @"name", @"about_me", @"location", @"web", nil]];
    [self post:dict];
//    [self dismissThisView];
}


- (NSData *)generatePostDataForData:(NSDictionary *)uploadData
{
//    NSData *media = [uploadData objectForKey:@"media"];
    NSString *name = [uploadData objectForKey:@"name"];
    NSString *about_me = [uploadData objectForKey:@"about_me"];
    NSString *location = [uploadData objectForKey:@"location"];
    NSString *web = [uploadData objectForKey:@"web"];
    
    [profile setValue:name forKey:@"name"];
    [profile setValue:about_me forKey:@"about_me"];
    [profile setValue:location forKey:@"location"];
    [profile setValue:web forKey:@"web"];
    
    // Generate the post header:
    NSString *stringBoundary = @"0xKhTmLbOuNdArY---This_Is_ThE_BoUnDaRyy---pqo";
    NSMutableData *postData = [NSMutableData data];
    
    //Add the fields
    [postData appendData: [[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"name\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[name dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]]; 
    
    //about_me
    [postData appendData: [[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"about_me\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[about_me dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]]; 
    
    //location
    [postData appendData: [[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"location\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[location dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]]; 
    
    //web
    [postData appendData: [[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"web\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[web dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]]; 
    
    
    if(profileImageUpdated)
    {
        // Add the media:
        [postData appendData: [[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"media\"; filename=\"%@\"\r\n", [NSString stringWithFormat:@"%@.jpg",[profile objectForKey:@"id"]]] dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:[@"Content-Type: application/octet-stream\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        NSData *profileImageData = [NSData dataWithData:UIImageJPEGRepresentation(profileImage, 0.5)];
        [postData appendData: profileImageData];
        [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"profile image data added");
//        NSLog(@"profile image data length %i", [profileImageData length]);
    }
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
//    NSLog(@"full request length %i", [postData length]);
    
    NSString *stringBoundary = @"0xKhTmLbOuNdArY---This_Is_ThE_BoUnDaRyy---pqo";
    NSString *headerBoundary = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
    
    // Setup the request:
    NSURL *url = [NSURL URLWithString:[[TWAGConstants getServiceBaseURL] stringByAppendingString:@"users/edit"]] ;
    NSMutableURLRequest *uploadRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy: NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    [uploadRequest setHTTPMethod:@"POST"];
    [uploadRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [uploadRequest setValue:headerBoundary forHTTPHeaderField:@"Content-Type"];
    [uploadRequest setHTTPBody:postData];
    
    // Execute the reqest: 
    [NSURLConnection connectionWithRequest:uploadRequest delegate:self];
    alert = [[UIAlertView alloc] initWithTitle:@"In Progress" message:@"Updating your profile" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Response Recieved");
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSMutableDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSString* responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", responseStr);
    NSNumber *status = [jsonResponse objectForKey:@"status"];
    if([status intValue] == 200)
    {
        [profileEditDelegate notifyProfileUpdate:profile];
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        [self dismissThisView];
    }else{
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Profile could not be updated" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        if(tableView == profileImageTableView)
        {
            profileImageCell = (ProfileImageCell *)[[[NSBundle mainBundle] loadNibNamed:@"ViewProfileTableCell" owner:self options:nil] objectAtIndex:6];
            NSString *url = [NSString stringWithFormat:@"img/%@.jpg", [profile objectForKey:@"id"]];
            url = [[TWAGConstants getServiceBaseURL] stringByAppendingString:url];
            if(profileImage == nil)
                profileImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
            profileImageCell.profileImageView.image = profileImage;
            NSLog(@"profile image set");
            cell = profileImageCell;
        }else {
            if(indexPath.row == 0){
                nameCell = (NameCell *)[[[NSBundle mainBundle] loadNibNamed:@"ViewProfileTableCell" owner:self options:nil] objectAtIndex:4];
                nameCell.nameLabel.text = ([profile objectForKey:@"name"] != [NSNull null]) ?[profile objectForKey:@"name"] : @"";
                cell = nameCell;
            }else if (indexPath.row == 1) {
                aboutMeCell = (AboutMeEditCell *)[[[NSBundle mainBundle] loadNibNamed:@"ViewProfileTableCell" owner:self options:nil] objectAtIndex:3];
                aboutMeCell.aboutMeLabel.text = ([profile objectForKey:@"about_me"] != [NSNull null]) ? [profile objectForKey:@"about_me"] : @"";
                cell = aboutMeCell;
            }else if (indexPath.row == 2) {
                locationCell = (LocationCell *)[[[NSBundle mainBundle] loadNibNamed:@"ViewProfileTableCell" owner:self options:nil] objectAtIndex:1];
                locationCell.locationLabel.text = ([profile objectForKey:@"location"] != [NSNull null]) ? [profile objectForKey:@"location"] : @"";
                cell = locationCell;
            }else if (indexPath.row == 3) {
                webCell = (WebCell *)[[[NSBundle mainBundle] loadNibNamed:@"ViewProfileTableCell" owner:self options:nil] objectAtIndex:2];
                webCell.webLabel.text = ([profile objectForKey:@"web"] != [NSNull null]) ? [profile objectForKey:@"web"] : @"";
                cell = webCell;
            }
        }
        
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == profileImageTableView)
        return 1;
    else 
        return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == profileImageTableView)
        return 90;
    else 
        return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == profileImageTableView){
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose Existing Photo", nil];
        [sheet showInView:self.view];
    }else {
        EditFieldViewController *fieldController = [EditFieldViewController alloc];
        fieldController.profileEditDelegate = self;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if(indexPath.row == 0){
            fieldController.value = ((NameCell *)cell).nameLabel.text;
            fieldController.key = @"name";
        }else if (indexPath.row == 1) {
            fieldController.value = ((AboutMeEditCell *)cell).aboutMeLabel.text;
            fieldController.key = @"about_me";
        }else if (indexPath.row == 2) {
            fieldController.value = ((LocationCell *)cell).locationLabel.text;
            fieldController.key = @"location";
        }else if (indexPath.row == 3) {
            fieldController.value = ((WebCell *)cell).webLabel.text;
            fieldController.key = @"web";
        }
        
        UINavigationController *editNav = [[UINavigationController alloc] initWithRootViewController:fieldController];
        [self presentModalViewController:editNav animated:YES];
    }
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button %d", buttonIndex);
    if(buttonIndex == 0 || buttonIndex == 1) {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
    
        if(buttonIndex == 0) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])  {
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentModalViewController:picker animated:YES];
            }
        } else if(buttonIndex == 1) {
            picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self presentModalViewController:picker animated:YES];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	NSLog(@"%@", info);
    [picker dismissModalViewControllerAnimated:YES];
    profileImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    capturedProfileImageURL = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
    [profileImageTableView reloadData];
    profileImageUpdated = YES;
    
}

-(void)notifyChangeForKey:(NSString *)key WithValue:(NSString *)value
{
    if(key == @"name"){
        nameCell.nameLabel.text = value;
    }else if (key == @"about_me") {
        aboutMeCell.aboutMeLabel.text = value;
    }else if (key == @"location") {
        locationCell.locationLabel.text = value;
    }else if (key == @"web") {
        webCell.webLabel.text = value;
    }
}

- (void)viewDidUnload
{
    [self setProfileImageTableView:nil];
    [self setProfileDetailsTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
