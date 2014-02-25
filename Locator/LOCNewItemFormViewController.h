//
//  LOCNewItemFormViewController.h
//  Locator
//
//  Created by Brad Charna on 2/24/14.
//  Copyright (c) 2014 Brad Charna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LOCItem.h"

@interface LOCNewItemFormViewController : UIViewController <MKMapViewDelegate, UITextFieldDelegate>

//@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) UIBarButtonItem *saveButton;
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@end
