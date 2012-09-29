//
//  TWAGSignupInProgressViewController.m
//  VlipperIphoneClient
//
//  Created by Parag Sharma on 16/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TWAGSignupInProgressViewController.h"

@interface TWAGSignupInProgressViewController ()

@end

@implementation TWAGSignupInProgressViewController
@synthesize signupInProgressTableView;

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
    signupInProgressTableView.dataSource = self;
}

- (void)viewDidUnload
{
    [self setSignupInProgressTableView:nil];
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSMutableString stringWithFormat:@"Cell-", indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) 
    {
        NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"Cells" owner:self options:nil];
        cell = [nibObjects objectAtIndex:3];
    }
    return cell;
}

@end
