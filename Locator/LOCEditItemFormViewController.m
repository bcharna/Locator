//
//  LOCEditItemFormViewController.m
//  Locator
//
//  Created by Brad Charna on 4/8/14.
//  Copyright (c) 2014 Brad Charna. All rights reserved.
//

#import "LOCEditItemFormViewController.h"

@interface LOCEditItemFormViewController ()

@property (strong, nonatomic) LOCItem *item;
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

- (void)submit:(id) sender
{
    self.item.name = self.field.text;
    self.item.category = self.selectedCategory;
    self.item.location = self.mapView.userLocation.location;
    NSError *error = nil;
    [self.managedObjectContext save:&error];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
