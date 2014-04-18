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
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

@end
