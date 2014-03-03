//
//  LOCNewItemFormViewController.m
//  Locator
//
//  Created by Brad Charna on 2/24/14.
//  Copyright (c) 2014 Brad Charna. All rights reserved.
//

#import "LOCNewItemFormViewController.h"

@interface LOCNewItemFormViewController ()
@property (nonatomic,strong) UITextField *field;
@property BOOL locationRetrieved;
@end

@implementation LOCNewItemFormViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"New Item";
        CGRect myFrame = [self.view frame];
        self.field = [[UITextField alloc] initWithFrame:CGRectMake([self.table separatorInset].left, 0, myFrame.size.width - 25, 60)];
        self.field.placeholder = @"Name";
        self.field.returnKeyType = UIReturnKeyDone;
        self.field.delegate = self;
        self.field.autocorrectionType = UITextAutocorrectionTypeNo;
        self.field.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.field.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.field addTarget:self action:@selector(nameFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.scrollEnabled = NO;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.table reloadData];
    self.nameField.delegate = self;
    self.saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(submit:)];
    [self.saveButton setEnabled:NO];
    self.navigationItem.rightBarButtonItem = self.saveButton;
}

- (BOOL)nameEntered
{
    NSString *trimmed = [self.field.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([trimmed isEqualToString:@""])
        return NO;
    return YES;
}

- (void)nameFieldDidChange:(UITextField *)textField
{
    if ([self nameEntered] && self.locationRetrieved)
        [self.saveButton setEnabled:YES];
    else
        [self.saveButton setEnabled:NO];
}

- (void)submit:(id) sender
{
    LOCItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"LOCItem" inManagedObjectContext:self.managedObjectContext];
    item.name = self.field.text;
    item.location = self.mapView.userLocation.location;
    NSError *error = nil;
    [self.managedObjectContext save:&error];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion mapRegion;
    mapRegion.center = mapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.005;
    mapRegion.span.longitudeDelta = 0.005;
    [mapView setRegion:mapRegion animated: YES];
    if ([self nameEntered])
        [self.saveButton setEnabled:YES];
    self.locationRetrieved = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - TableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    [cell.contentView addSubview:self.field];
    return cell;
}

@end
