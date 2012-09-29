//
//  EditFieldViewController.m
//  VlipperIphoneClient
//
//  Created by Parag Sharma on 22/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EditFieldViewController.h"

@interface EditFieldViewController ()

@end

@implementation EditFieldViewController
@synthesize valueTextField;
@synthesize key;
@synthesize value;
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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iphone_bg6.png"]];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(dismissThisView)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveTheValue)];
    self.navigationItem.rightBarButtonItem = saveButton;
}
                                     
- (void) dismissThisView{
    [self dismissViewControllerAnimated:YES completion:nil];
}  

- (void) saveTheValue{
    [profileEditDelegate notifyChangeForKey:key WithValue:editFieldCell.valueTextField.text];
    [self dismissThisView];
}  

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    editFieldCell = (EditFieldCell *)[[[NSBundle mainBundle] loadNibNamed:@"ViewProfileTableCell" owner:self options:nil] objectAtIndex:5];
    editFieldCell.valueTextField.text = value;
    return editFieldCell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (void)viewDidUnload
{
    [self setValueTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
