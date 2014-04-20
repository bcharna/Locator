//
//  LOCNewItemFormViewController.m
//  Locator
//
//  Created by Brad Charna on 4/8/14.
//  Copyright (c) 2014 Brad Charna. All rights reserved.
//

#import "LOCNewItemFormViewController.h"

@interface LOCNewItemFormViewController ()

@end

@implementation LOCNewItemFormViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSString *nibName = @"LOCNewItemFormViewController";
    self = [super initWithNibName:nibName bundle:nibBundleOrNil];
    if (self) {
        self.title = @"New Item";
    }
    return self;
}

- (id) initWithManagedObjectContext: (id) context
{
    self = [super initWithManagedObjectContext:context];
    if(self){
        self.selectedCategory = [LOCCategory defaultCategoryUsingContext: context];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
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

@end
