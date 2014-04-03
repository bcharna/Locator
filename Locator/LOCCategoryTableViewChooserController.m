//
//  LOCCategoryTableViewChooserController.m
//  Locator
//
//  Created by Brad Charna on 3/25/14.
//  Copyright (c) 2014 Brad Charna. All rights reserved.
//

#import "LOCCategoryTableViewChooserController.h"
#import "LOCCategoryCell.h"
#import "LOCChooseCategoryCell.h"

@interface LOCCategoryTableViewChooserController ()
@property (nonatomic, strong) LOCCategoryCell *checkedCell;
@end

@implementation LOCCategoryTableViewChooserController

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

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    LOCCategory *cat =  [self handleAlertViewDidDismissWithAlertView:alertView buttonIndex: buttonIndex];
    self.selectedCategory = cat;
    self.checkedCell.accessoryType = UITableViewCellAccessoryNone;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
