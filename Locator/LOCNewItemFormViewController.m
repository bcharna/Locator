//
//  LOCNewItemFormViewController.m
//  Locator
//
//  Created by Brad Charna on 2/24/14.
//  Copyright (c) 2014 Brad Charna. All rights reserved.
//

#import "LOCNewItemFormViewController.h"
#import "LOCCategoryTableViewChooserController.h"
#import "LOCChooseCategoryCell.h"

@interface LOCNewItemFormViewController ()
@property (nonatomic,strong) UITextField *field;
@property (nonatomic,strong) LOCCategory *selectedCategory;
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

- (id) initWithManagedObjectContext: (id) context
{
    self = [super init];
    if(self){
        self.managedObjectContext = context;
        self.selectedCategory = [LOCCategory defaultCategoryUsingContext: self.managedObjectContext];
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

- (void)didSelectCategory:(LOCCategory *) category
{
    LOCChooseCategoryCell *cell = (LOCChooseCategoryCell*)[self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
//    NSLog(@"%@" ,cell.categoryLabel);
//    NSLog(@"chee");
    cell.categoryLabel.text = category.name;
    [self.table reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:NO];
    self.selectedCategory = category;
}

- (void)submit:(id) sender
{
    LOCItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"LOCItem" inManagedObjectContext:self.managedObjectContext];
    item.name = self.field.text;
    item.category = self.selectedCategory;
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
        
//        [cell.contentView addSubview:self.field];
    }
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        LOCCategoryTableViewChooserController *catVC = [[LOCCategoryTableViewChooserController alloc] initWithStyle:UITableViewStylePlain];
        catVC.managedObjectContext = self.managedObjectContext;
        catVC.delegate = self;
        if (self.selectedCategory != nil)
            catVC.selectedCategory = self.selectedCategory;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:catVC];
        [self presentViewController:nav animated:YES completion:nil];
 
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}


@end
