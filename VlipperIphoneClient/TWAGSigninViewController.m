//
//  TWAGSigninViewController.m
//  VlipperIphoneClient
//
//  Created by Parag Sharma on 24/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TWAGSigninViewController.h"
#import "TWAGConstants.h"

@interface TWAGSigninViewController ()

@end

@implementation TWAGSigninViewController
@synthesize emailTextField;
@synthesize passwordTextField;
@synthesize signInViewDelegate;

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
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *loginButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(login)];
    self.navigationItem.rightBarButtonItem = loginButton;
}

- (void) cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) login
{
    NSString *email = emailTextField.text;
    NSString *password = passwordTextField.text;
    
    NSString *post = [NSString stringWithFormat:@"data[User][email]=%@&data[User][password]=%@&data[User][remember_me]=1", email, password];
    
    NSString *url = [[TWAGConstants getServiceBaseURL] stringByAppendingString:@"users/login"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPBody:[NSData dataWithBytes:[post UTF8String] length:[post length]]];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
//     {
//         if ([data length] > 0 && error == nil){
//             NSString* response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//             NSString *result =[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//             
//             NSDictionary *httpResponse = (NSDictionary *)response;
//             NSLog(@"%@", httpResponse);
//             NSEnumerator *enumerator = [httpResponse keyEnumerator];
//             NSLog(@"%@", enumerator.allObjects);
//             //NSString *cookie = [fields valueForKey:@"Set-Cookie"];
//             
//             //NSLog(@"%@", fields);
//            // NSLog(@"%@", cookie);
//         }else if (error != nil){
//             NSLog(@"%@", error);
//         }
//     }];

}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
    NSDictionary *fields = [HTTPResponse allHeaderFields];
    NSString *cookie = [fields valueForKey:@"Set-Cookie"];
    NSString *loginCookie =  [self stringBetweenString:@"CakeCookie[User][id]=" andString:@";" forSubject:cookie];
    if(loginCookie != nil)
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSLog(@"Login Cookie : %@", loginCookie);
        [prefs setObject:loginCookie forKey:@"LoginCookie"];
        [signInViewDelegate signinSuccess];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Login Failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(NSString*) stringBetweenString:(NSString *)start andString:(NSString *) end forSubject:(NSString *) subject {
    NSScanner* scanner = [NSScanner scannerWithString:subject];
    [scanner setCharactersToBeSkipped:nil];
    [scanner scanUpToString:start intoString:NULL];
    if ([scanner scanString:start intoString:NULL]) {
        NSString* result = nil;
        if ([scanner scanUpToString:end intoString:&result]) {
            return result;
        }
    }
    return nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSString* response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@", response);
    
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSMutableDictionary *user = [dict objectForKey:@"result"];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if([user objectForKey:@"name"] != nil)
        [prefs setObject:[user objectForKey:@"name"] forKey:@"LoginCookie"];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
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
            cell = [nibObjects objectAtIndex:1];
            emailTextField = (UITextField *) [cell viewWithTag:2];
            [emailTextField setDelegate:self];
        }
        else if(indexPath.row == 1)
        {
            cell = [nibObjects objectAtIndex:2];
            passwordTextField = (UITextField *) [cell viewWithTag:2];
            [passwordTextField setDelegate:self];
        }
    }
    return cell;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField 
{
    if(textField == emailTextField)
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

@end
