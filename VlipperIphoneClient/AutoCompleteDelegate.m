//
//  AutoCompleteDelegate.m
//  VlipperIphoneClient
//
//  Created by Parag Sharma on 27/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AutoCompleteDelegate.h"

@implementation AutoCompleteDelegate

@synthesize suggestions;
@synthesize autoCompleteTableView;
@synthesize reciepientId;
@synthesize reciepientName;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return suggestions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *friend = [[suggestions objectAtIndex:indexPath.row] objectForKey:@"users"];
    NSString *text = [NSMutableString stringWithFormat:@"%@", [friend objectForKey:@"name"]];
    NSString *CellIdentifier = [NSMutableString stringWithFormat:text];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [UITableViewCell alloc];
        cell = [cell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        cell.imageView.image = [UIImage imageNamed:@"first.png"];
        
        cell.textLabel.text = text;
    }
    return cell;
}

-(NSString *) getLogString
{
    return @"Hello This is a log";
}


#pragma mark UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	NSString *substring = [NSString stringWithString:textField.text];
	substring = [substring stringByReplacingCharactersInRange:range withString:string];
    [self autoCompleteLocations:substring fromTextField:textField];
	return YES;
}

-(void) autoCompleteLocations:(NSString *) query fromTextField:(UITextField *) textField
{
    query = [query stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *base = [[TWAGConstants getServiceBaseURL] stringByAppendingString:@"users/friends/"];
    NSString *encodedURL = [[base stringByAppendingString:query] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL *url = [NSURL URLWithString:encodedURL] ;
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
    NSMutableDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:response1 options:NSJSONReadingMutableContainers error:nil];
//    NSString* responseStr = [[NSString alloc] initWithData:response1 encoding:NSUTF8StringEncoding];
//    NSLog(@"%@", jsonResponse);
    suggestions = [jsonResponse objectForKey:@"result"];
    NSLog(@"%@", jsonResponse);
    if(requestError != nil)
    {
        NSLog(@"%@", requestError);
    }
    
    //for (NSString* location in _suggestions) {
    //        NSLog(@"logging from autocompletetabledatasource");
    //        NSLog(@"%@", location);
    // }
    autoCompleteTableView.eventSource = textField;
    [autoCompleteTableView reloadData];
    autoCompleteTableView.hidden = NO;  
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *text = cell.textLabel.text;
    tableView.hidden = YES; 
    ((AutoCompleteTableView *)tableView).eventSource.text = text;
    [((AutoCompleteTableView *)tableView).eventSource resignFirstResponder];
    NSMutableDictionary *friend = [[suggestions objectAtIndex:indexPath.row] objectForKey:@"users"];
    NSString *friendId = [NSMutableString stringWithFormat:@"%@", [friend objectForKey:@"id"]];
    reciepientId = friendId;
    reciepientName = [NSMutableString stringWithFormat:@"%@", [friend objectForKey:@"name"]];
}

@end
