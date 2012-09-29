//
//  TWAGSignupViewController.m
//  VlipperIphoneClient
//
//  Created by Parag Sharma on 13/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TWAGSignupViewController.h"
#import "TWAGConstants.h"

@interface TWAGSignupViewController ()

@end

@implementation TWAGSignupViewController
@synthesize signupTableView;
@synthesize fullNameTextField;
@synthesize emailTextField;
@synthesize passwordTextField;
@synthesize signupViewDelegate;

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
    signupTableView.dataSource = self;
}

- (void)viewDidUnload
{
    [self setSignupTableView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSMutableString stringWithFormat:@"Cell-", indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) 
    {
        NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"Cells" owner:self options:nil];
        if(indexPath.row == 0)
        {
            cell = [nibObjects objectAtIndex:indexPath.row];
            fullNameTextField = (UITextField *) [cell viewWithTag:2];
            [fullNameTextField setDelegate:self];
        }
        else if(indexPath.row == 1)
        {
            cell = [nibObjects objectAtIndex:indexPath.row];
            emailTextField = (UITextField *) [cell viewWithTag:2];
            [emailTextField setDelegate:self];
        }
        else if(indexPath.row == 2)
        {
            cell = [nibObjects objectAtIndex:indexPath.row];
            passwordTextField = (UITextField *) [cell viewWithTag:2];
            [passwordTextField setDelegate:self];
        }
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"By tapping \"Signup\" above, you are agreeing to the Terms of Service and Privacy Policy";
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField 
{
    if(textField == fullNameTextField)
    {
         if(textField.text.length == 0)
             return NO;
    }
    else if(textField == emailTextField)
    {
        NSString *emailString = textField.text;
        NSString *regExPattern = @"^[A-Z0-9._%+-]+@[A-Z0-9.-]+.[A-Z]{2,4}$";
        NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
        NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
        if (regExMatches == 0) 
            return NO;
    }
    else if(textField == passwordTextField)
    {
        if(passwordTextField.text.length < 6){
            return NO;
        }else {
            self.navigationController.navigationBar.topItem.rightBarButtonItem.enabled = YES;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;

}

- (void) initiateSignup
{
    NSString *fullName = [fullNameTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *email = emailTextField.text;
    NSString *password = passwordTextField.text;
    
    NSString *post = [NSString stringWithFormat:@"data[User][name]=%@&data[User][email]=%@&data[User][password]=%@", fullName, email, password];
    NSString *url = [[TWAGConstants getServiceBaseURL] stringByAppendingString:@"users/add"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPBody:[NSData dataWithBytes:[post UTF8String] length:[post length]]];
    [request setHTTPMethod:@"POST"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
        if ([data length] > 0 && error == nil){
//            NSString* response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSString *result =[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            [signupViewDelegate signupSuccess];
            NSLog(@"%@", result);
        }else if (error != nil){
            NSLog(@"%@", error);
        }
    }];
    [signupViewDelegate signupInProgress];
}

@end
