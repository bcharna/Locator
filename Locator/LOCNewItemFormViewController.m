//
//  LOCNewItemFormViewController.m
//  Locator
//
//  Created by Brad Charna on 2/24/14.
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
//      self.locationManager = [[CLLocationManager alloc] init];
      // look at CoreLocation constants documentation for different accuracy definitions
//      self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
      // possible since we conform to the CLLocationManagerDelegate protocol
//      self.locationManager.delegate = self;
//      [self.locationManager startUpdatingLocation];
      self.title = @"New Item";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.nameField.delegate = self;

    self.saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(submit:)];

    [self.saveButton setEnabled:NO];
    self.navigationItem.rightBarButtonItem = self.saveButton;
}

- (void)submit:(id) sender
{  
  LOCItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"LOCItem" inManagedObjectContext:self.managedObjectContext];
  item.name = self.nameField.text;
  item.location = self.mapView.userLocation.location;
  
  NSError *error = nil;
  [self.managedObjectContext save:&error];
  [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return NO;
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
  MKCoordinateRegion mapRegion;
  mapRegion.center = mapView.userLocation.coordinate;
  mapRegion.span.latitudeDelta = 0.005;
  mapRegion.span.longitudeDelta = 0.005;
  [mapView setRegion:mapRegion animated: YES];
  [self.saveButton setEnabled:YES];
}

//- (void)locationManager:(CLLocationManager *)locationManager didUpdateLocations:(NSArray *)locations
//{
//  CLLocation *location = [locations objectAtIndex:0];
//  self.currentLocation = location;
//  [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
//  [self.submitButton setEnabled:YES];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
