//
//  LOCItemFormViewController.h
//  Locator
//
//  Created by Brad Charna on 2/24/14.
//  Copyright (c) 2014 Brad Charna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LOCItem.h"
#import "LOCCategoryChooserTableViewController.h"

@interface LOCItemFormViewController : UIViewController <MKMapViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, LOCCategoryTableViewChooserControllerDelegate>

//@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) UIBarButtonItem *saveButton;
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (nonatomic,strong) LOCCategory *selectedCategory;

- (id) initWithManagedObjectContext: (id) context;
@end
