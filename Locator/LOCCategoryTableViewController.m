//
//  LOCCategoryTableViewController.m
//  Locator
//
//  Created by Brad Charna on 3/25/14.
//  Copyright (c) 2014 Brad Charna. All rights reserved.
//

#import "LOCCategoryTableViewController.h"
#import "LOCCategoryCell.h"
#import "LOCCategory.h"

@interface LOCCategoryTableViewController ()
@property (nonatomic, strong) NSIndexPath *bottomIndexPath;
@property (nonatomic, strong) LOCCategory *editingCategory;
@property (nonatomic, strong) UIAlertView *editAlert;
@end

@implementation LOCCategoryTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.editAlert = [[UIAlertView alloc] initWithTitle:@"Edit Category..." message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSError *error = nil;
    [[self fetchedResultsController] performFetch:&error];
    [self setupNavbar];
    [self.tableView registerNib:[UINib nibWithNibName:@"LOCCategoryCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CategoryCell"];
}

- (void) setupNavbar
{
    UIBarButtonItem *newItemButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(getNewCategory:)];
    self.navigationItem.rightBarButtonItem = newItemButton;
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed:)];
    self.navigationItem.leftBarButtonItem = doneButton;
    self.title = @"Categories";

}

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LOCCategory" inManagedObjectContext:self.managedObjectContext];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:15];
    NSFetchedResultsController *newFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root2"];
    self.fetchedResultsController = newFetchedResultsController;
    _fetchedResultsController.delegate = self;
    return _fetchedResultsController;
}

- (void) getNewCategory:(id) sender
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Add Category..." message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField = [alert textFieldAtIndex:0];
    textField.delegate = self;
    [alert show];
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (self.editAlert == alertView) {
        [self handleEditCategoryWithAlertView:alertView buttonIndex: buttonIndex];
    } else { // add category
        [self handleAddCategoryWithAlertView:alertView buttonIndex: buttonIndex];
    }
}

- (LOCCategory*) handleEditCategoryWithAlertView:(UIAlertView *)alertView buttonIndex: (NSInteger)buttonIndex
{
    NSString *input = [[alertView textFieldAtIndex:0] text];
    LOCCategory* cat = self.editingCategory;
    cat.name = input;
    NSError *error;
    [self.managedObjectContext save:&error];
    return cat;
}

- (LOCCategory*) handleAddCategoryWithAlertView:(UIAlertView *)alertView buttonIndex: (NSInteger)buttonIndex

{
    LOCCategory *cat;
    if(buttonIndex == 1)//OK button
    {
        NSString *input = [[alertView textFieldAtIndex:0] text];
        cat = [NSEntityDescription insertNewObjectForEntityForName:@"LOCCategory" inManagedObjectContext:self.managedObjectContext];
        cat.name = input;
        NSError *error = nil;
        [self.managedObjectContext save:&error];
    }
    if (self.bottomIndexPath) {
        [self.tableView scrollToRowAtIndexPath:self.bottomIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        self.bottomIndexPath = nil;
    }
    return cat;
}

- (void) donePressed:(id) sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


- (void)configureCell:(LOCCategoryCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    LOCCategory *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.nameLabel.text = item.name;
//    cell.creationDateLabel.text = [item creationDateStringShort];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CategoryCell";
    LOCCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) { // cannot edit None
        return;
    }
    self.editingCategory = [self.fetchedResultsController objectAtIndexPath:indexPath];
    self.editAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField = [self.editAlert textFieldAtIndex:0];
    textField.delegate = self;
    textField.text = self.editingCategory.name;
    [self.editAlert show];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) { // cannot delete None
        return NO;
    }
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    LOCCategory *cat = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cat deleteCategory];
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    LOCItem *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    [self.managedObjectContext deleteObject:item];
//    NSError *error = nil;
//    [self.managedObjectContext save:&error];
//}

#pragma mark - NSFetchedResultsController protocol methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            self.bottomIndexPath = newIndexPath;
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(LOCCategoryCell*)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

@end