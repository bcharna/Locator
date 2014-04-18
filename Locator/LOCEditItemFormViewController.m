//
//  LOCEditItemFormViewController.m
//  Locator
//
//  Created by Brad Charna on 4/8/14.
//  Copyright (c) 2014 Brad Charna. All rights reserved.
//

#import "LOCEditItemFormViewController.h"

@interface LOCEditItemFormViewController ()

@end

@implementation LOCEditItemFormViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Edit Item";
    }
    return self;
}

- (id) initWithManagedObjectContext: (id)context category: (LOCCategory*)category name: (NSString*)name
{
    self = [super initWithManagedObjectContext:context];
    if(self){
        [self didSelectCategory:category];
        self.field.text = name;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
