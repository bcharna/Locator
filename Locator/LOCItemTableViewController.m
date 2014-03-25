//
//  LOCItemTableViewController.m
//  Locator
//
//  Created by Brad Charna on 2/24/14.
//  Copyright (c) 2014 Brad Charna. All rights reserved.
//

#import "LOCItemTableViewController.h"
#import "LOCNewItemFormViewController.h"
#import "LOCItemCell.h"
#import "LOCItemViewController.h"

@interface LOCItemTableViewController ()
@end

@implementation LOCItemTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Locator";
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LOCItem" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:15];
    NSFetchedResultsController *newFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root2"];
    self.fetchedResultsController = newFetchedResultsController;
    _fetchedResultsController.delegate = self;
    return _fetchedResultsController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSError *error = nil;
    [[self fetchedResultsController] performFetch:&error];
    UIBarButtonItem *newItemButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(getNewItem:)];
    self.navigationItem.rightBarButtonItem = newItemButton;
    [self.tableView registerNib:[UINib nibWithNibName:@"LOCItemCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ItemCell"];
}

- (void) getNewItem:(id) sender
{
    LOCNewItemFormViewController *form = [[LOCNewItemFormViewController alloc] init];
    form.managedObjectContext = self.managedObjectContext;
    [self.navigationController pushViewController:form animated:YES];
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


- (void)configureCell:(LOCItemCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    LOCItem *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.nameLabel.text = item.name;
    cell.creationDateLabel.text = [item creationDateStringShort];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ItemCell";
    LOCItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LOCItem *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    LOCItemViewController *viewController = [[LOCItemViewController alloc] init];
    viewController.item = item;
    [self.navigationController pushViewController:viewController animated:YES];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    LOCItem *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.managedObjectContext deleteObject:item];
    NSError *error = nil;
    [self.managedObjectContext save:&error];
}


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(LOCItemCell*)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
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
