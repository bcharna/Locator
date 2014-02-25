//
//  LOCItemViewController.m
//  Locator
//
//  Created by Brad Charna on 2/24/14.
//  Copyright (c) 2014 Brad Charna. All rights reserved.
//

#import "LOCItemViewController.h"

@interface LOCItemViewController ()

@end

@implementation LOCItemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MKCoordinateRegion mapRegion;
//  mapRegion.center = self.mapView.userLocation.coordinate;
    mapRegion.center = self.item.location.coordinate;
    mapRegion.span.latitudeDelta = 0.005;
    mapRegion.span.longitudeDelta = 0.005;
    [self.mapView setRegion:mapRegion animated: YES];
    self.nameLabel.text = self.item.name;
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:self.item.location.coordinate];
    [annotation setTitle:self.item.name];
    [self.mapView addAnnotation:annotation];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
