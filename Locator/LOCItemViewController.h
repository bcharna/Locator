//
//  LOCItemViewController.h
//  Locator
//
//  Created by Brad Charna on 2/24/14.
//  Copyright (c) 2014 Brad Charna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LOCItem.h"
#import <QuartzCore/QuartzCore.h>

@interface LOCItemViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) LOCItem *item;
@property (strong, nonatomic) IBOutlet UILabel *creationDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *categoryLabel;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@end
