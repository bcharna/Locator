//
//  LOCCategoryTableViewController.h
//  Locator
//
//  Created by Brad Charna on 3/25/14.
//  Copyright (c) 2014 Brad Charna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LOCCategory.h"

@interface LOCCategoryTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, UITextFieldDelegate>

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSIndexPath *bottomIndexPath;

- (void) getNewCategory:(id) sender;
- (LOCCategory*) handleAddCategoryWithAlertView:(UIAlertView *)alertView buttonIndex: (NSInteger)buttonIndex;
- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;
- (NSIndexPath*) scrollToBottom;
@end
