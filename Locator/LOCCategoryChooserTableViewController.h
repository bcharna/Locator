//
//  LOCCategoryTableViewChooserController.h
//  Locator
//
//  Created by Brad Charna on 3/25/14.
//  Copyright (c) 2014 Brad Charna. All rights reserved.
//

#import "LOCCategoryTableViewController.h"
#import "LOCCategory.h"

@protocol LOCCategoryTableViewChooserControllerDelegate <NSObject>
- (void)didSelectCategory:(LOCCategory *) category;
@end

@interface LOCCategoryChooserTableViewController : LOCCategoryTableViewController

@property (nonatomic, weak) id <LOCCategoryTableViewChooserControllerDelegate> delegate;
@property (nonatomic, strong) LOCCategory *selectedCategory;

@end
