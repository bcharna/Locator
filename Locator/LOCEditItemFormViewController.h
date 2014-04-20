//
//  LOCEditItemFormViewController.h
//  Locator
//
//  Created by Brad Charna on 4/8/14.
//  Copyright (c) 2014 Brad Charna. All rights reserved.
//

#import "LOCItemFormViewController.h"

@interface LOCEditItemFormViewController : LOCItemFormViewController
- (id) initWithManagedObjectContext: (id)context item: (LOCItem*)item;
@end
