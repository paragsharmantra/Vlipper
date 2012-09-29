//
//  AddContactsViewController.m
//  VlipperIphoneClient
//
//  Created by Parag Sharma on 30/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddContactsViewController.h"

@interface AddContactsViewController ()

@end

@implementation AddContactsViewController
@synthesize addContactsDelegate;

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
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topbar.png"] forBarMetrics:UIBarMetricsDefault];
    
    UIImageView *cancelImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cancel_button.png"]];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithCustomView:cancelImgView];
    cancelImgView.userInteractionEnabled = YES;
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UITapGestureRecognizer *cancelTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissThisView)];
    [cancelImgView addGestureRecognizer:cancelTapRecognizer];
    
    UIImageView *saveImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"send.png"]];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithCustomView:saveImgView];
    saveImgView.userInteractionEnabled = YES;
    self.navigationItem.rightBarButtonItem = saveButton;
    
    UITapGestureRecognizer *saveTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saveTheContact)];
    [saveImgView addGestureRecognizer:saveTapRecognizer];

}

- (void) dismissThisView{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) saveTheContact{
    [self addFriend];
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

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"add contacts view appeared");
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topbar.png"] forBarMetrics:UIBarMetricsDefault];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"email"];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AddContactCells" owner:self options:nil] objectAtIndex:0];
        emailTextField = (UITextField *)[cell viewWithTag:1];
    }
    return cell;
}

- (void) addFriend
{
    NSString *urlString = [[[[TWAGConstants getServiceBaseURL] stringByAppendingString:@"users/add_friend"] stringByAppendingString:@"?email="] stringByAppendingString:emailTextField.text];
    NSURL *url = [NSURL URLWithString:urlString] ;
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    NSError *requestError;
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if(error == nil){
            NSMutableDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSString* responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@", responseStr);
            [addContactsDelegate contactAdded];
            [self performSelectorOnMainThread:@selector(dismissThisView) withObject:nil waitUntilDone:YES];
        }else {
            NSLog(@"%@", requestError);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Connection to Server Failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
        }
    }];
    
}


@end
