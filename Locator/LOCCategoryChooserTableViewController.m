//
//  LOCCategoryTableViewChooserController.m
//  Locator
//
//  Created by Brad Charna on 3/25/14.
//  Copyright (c) 2014 Brad Charna. All rights reserved.
//

#import "LOCCategoryChooserTableViewController.h"
#import "LOCCategoryCell.h"
#import "LOCChooseCategoryCell.h"

@interface LOCCategoryChooserTableViewController ()
@property (nonatomic, strong) LOCCategoryCell *checkedCell;
@end

@implementation LOCCategoryChooserTableViewController

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
    // Do any additional setup after loading the view.
}

- (void) setupNavbar
{
    UIBarButtonItem *newItemButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(getNewCategory:)];
    self.navigationItem.rightBarButtonItem = newItemButton;
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed:)];
    self.navigationItem.leftBarButtonItem = doneButton;
    self.title = @"Category";
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // add category
    LOCCategory *cat = [self handleAddCategoryWithAlertView:alertView buttonIndex: buttonIndex];
    self.checkedCell.accessoryType = UITableViewCellAccessoryNone;
    self.selectedCategory = cat;
    [self.tableView reloadRowsAtIndexPaths:@[self.bottomIndexPath] withRowAnimation:NO];
}

- (void)configureCell:(LOCCategoryCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    LOCCategory *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.nameLabel.text = item.name;
    if ([self.selectedCategory isEqual:item]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.checkedCell = cell;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)donePressed:(id)sender
{
    [self.delegate didSelectCategory:self.selectedCategory];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedCategory = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [tableView reloadSections: [NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:NO];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO; // can never delete categories in chooser.
}

@end
