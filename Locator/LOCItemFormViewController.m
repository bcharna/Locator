//
//  LOCItemFormViewController.m
//  Locator
//
//  Created by Brad Charna on 2/24/14.
//  Copyright (c) 2014 Brad Charna. All rights reserved.
//

#import "LOCItemFormViewController.h"
#import "LOCCategoryChooserTableViewController.h"
#import "LOCChooseCategoryCell.h"

@interface LOCItemFormViewController ()
@property BOOL locationRetrieved;
@property (nonatomic, strong) LOCCategoryChooserTableViewController *categoryChooserTVC;
@end

@implementation LOCItemFormViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSString *nibName = @"LOCItemFormViewController";
    self = [super initWithNibName:nibName bundle:nibBundleOrNil];
    if (self) {
        CGRect myFrame = [self.view frame];
        self.field = [[UITextField alloc] initWithFrame:CGRectMake([self.table separatorInset].left, 0, myFrame.size.width - 25, 60)];
        self.field.placeholder = @"Name";
        self.field.returnKeyType = UIReturnKeyDone;
        self.field.delegate = self;
        self.field.autocapitalizationType = UITextAutocapitalizationTypeWords;
        self.field.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.field addTarget:self action:@selector(nameFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}

- (id) initWithManagedObjectContext: (id) context
{
    self = [super init];
    if(self){
        self.managedObjectContext = context;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    [self.table registerNib:[UINib nibWithNibName:@"LOCChooseCategoryCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ChooseCategoryCell"];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.scrollEnabled = NO;
    [self.table reloadData];
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

- (void)didSelectCategory:(LOCCategory *) category
{
    LOCChooseCategoryCell *cell = (LOCChooseCategoryCell*)[self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell.categoryLabel.text = category.name;
    [self.table reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:NO];
    self.selectedCategory = category;
}

- (void)submit:(id) sender
{
    // Subclass determines behavior
    return;
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
    return 2;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    static NSString *CellIdentifier;
    if (indexPath.row == 0) {
        CellIdentifier = @"Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell.contentView addSubview:self.field];
    }
    else {
        CellIdentifier = @"ChooseCategoryCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        LOCCategoryChooserTableViewController *catVC = [self categoryChooserTVC];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:catVC];
        [self presentViewController:nav animated:YES completion:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(LOCCategoryChooserTableViewController*) categoryChooserTVC
{
    if (_categoryChooserTVC)
        return _categoryChooserTVC;
    _categoryChooserTVC = [[LOCCategoryChooserTableViewController alloc] initWithStyle:UITableViewStylePlain];
    _categoryChooserTVC.managedObjectContext = self.managedObjectContext;
    _categoryChooserTVC.delegate = self;
    _categoryChooserTVC.selectedCategory = self.selectedCategory;
    return _categoryChooserTVC;
}


@end
