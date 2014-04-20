//
//  LOCEditItemFormViewController.m
//  Locator
//
//  Created by Brad Charna on 4/8/14.
//  Copyright (c) 2014 Brad Charna. All rights reserved.
//

#import "LOCEditItemFormViewController.h"
#import "LOCSwitchUpdateLocationCell.h"

@interface LOCEditItemFormViewController ()

@property (strong, nonatomic) LOCItem *item;
@property BOOL doesWantUpdateLocation;
@end

@implementation LOCEditItemFormViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSString *nibName = @"LOCEditItemFormViewController";
    self = [super initWithNibName:nibName bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Edit Item";
    }
    return self;
}

- (id) initWithManagedObjectContext: (id)context item: (LOCItem*)item
{
    self = [super initWithManagedObjectContext:context];
    if(self){
        [self didSelectCategory:item.category];
        self.field.text = item.name;
        self.item = item;
        [self.saveButton setEnabled:YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
}

- (void) cancelPressed:(id) sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.row < 2) {
        cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    } else {
        static NSString *CellIdentifier;
        CellIdentifier = @"SwitchUpdateLocationCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UISwitch* locSwitch = ((LOCSwitchUpdateLocationCell *) cell).updateLocationSwitch;
        [locSwitch addTarget:self action:@selector(updateLocationSwitchToggled:) forControlEvents:UIControlEventValueChanged];
    }
    return cell;
}

-(void) updateLocationSwitchToggled: (id) sender
{
    if ([sender isOn]) {
        if (!self.locationRetrieved) {
            [self.saveButton setEnabled:NO];
        }
        self.mapView.alpha = 1.0;
        self.doesWantUpdateLocation = YES;
        self.mapView.showsUserLocation = YES;
    } else {
        self.mapView.alpha = 0.5;
        self.doesWantUpdateLocation = NO;
    }
}

- (void)submit:(id) sender
{
    self.item.name = self.field.text;
    self.item.category = self.selectedCategory;
    if (self.doesWantUpdateLocation)
        self.item.location = self.mapView.userLocation.location;
    NSError *error = nil;
    [self.managedObjectContext save:&error];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (void)nameFieldDidChange:(UITextField *)textField
{
    if (([self nameEntered] && self.locationRetrieved) || !self.doesWantUpdateLocation)
        [self.saveButton setEnabled:YES];
    else
        [self.saveButton setEnabled:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

@end
