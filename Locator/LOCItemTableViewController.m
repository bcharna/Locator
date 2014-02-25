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

@interface LOCItemTableViewController () <LOCItemProtocol>
@property (nonatomic,strong) NSMutableArray* items;
@end

@implementation LOCItemTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
      self.items = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *newItemButton = [[UIBarButtonItem alloc] initWithTitle:@"New Item" style:UIBarButtonItemStylePlain target:self action:@selector(getNewItem:)];
    self.navigationItem.rightBarButtonItem = newItemButton;
    [self.tableView registerNib:[UINib nibWithNibName:@"LOCItemCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ItemCell"];
}

- (void) getNewItem:(id) sender
{
  LOCNewItemFormViewController *form = [[LOCNewItemFormViewController alloc] init];
  form.delegate = self;
  [self.navigationController pushViewController:form animated:YES];
}

- (void) receivedNewItem:(LOCItem *)item
{
  [self.items addObject:item];
  [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    // Return the number of sections.
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ItemCell";
    LOCItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    LOCItem *item = [self.items objectAtIndex:indexPath.row];
    cell.nameLabel.text = item.name;
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  LOCItem *item = [self.items objectAtIndex:indexPath.row];
  LOCItemViewController *viewController = [[LOCItemViewController alloc] init];
  viewController.item = item;
  [self.navigationController pushViewController:viewController animated:YES];
  
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
