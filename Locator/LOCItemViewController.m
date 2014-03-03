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
        self.title = @"Item Details";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    MKCoordinateRegion mapRegion;
    mapRegion.center = self.item.location.coordinate;
    mapRegion.span.latitudeDelta = 0.005;
    mapRegion.span.longitudeDelta = 0.005;
    [self.mapView setRegion:mapRegion animated: YES];
    self.nameLabel.text = self.item.name;
    self.creationDateLabel.text = [self.item creationDateStringFull];
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.subtitle = @"Open in Maps";
    [annotation setCoordinate:self.item.location.coordinate];
    [annotation setTitle:self.item.name];
    [self.mapView addAnnotation:annotation];
    self.mapView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        CLLocationCoordinate2D coordinate = [[view annotation] coordinate];
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [mapItem setName: self.item.name ];
        [mapItem openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving}];
    }
}

@end
