//
//  ViewController.m
//  Carpin
//
//  Created by Stuart Farmer on 4/16/15.
//  Copyright (c) 2015 Stuart Farmer. All rights reserved.
//

#import "ViewController.h"
#import "UIButton+Bootstrap.h"
#import "NSString+FontAwesome.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <MapKit/MapKit.h>

@interface ViewController () <CLLocationManagerDelegate, MKMapViewDelegate> {
    CLLocationManager *locationManager;
    CLLocation *pinLocation;
    CLLocation *lastLocation;
    int count;
    BOOL isPin;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize location services. Mundane stuff
    locationManager = [[CLLocationManager alloc] init];
    [locationManager requestAlwaysAuthorization];
    locationManager.delegate = self;
    
    // Accuracy constants here. These should be tested for battery optimization.
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    
    [locationManager startUpdatingLocation];
    
    NSLog(@"%@", locationManager.location);
    
    [self.setPin defaultStyle];
    [self.locateCar defaultStyle];
    [self.resetPin defaultStyle];
    
    isPin = NO;
    [self toggleButtonsFor:isPin];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)setPinPressed:(id)sender {
    isPin = YES;
    [self toggleButtonsFor:isPin];
    NSLog(@"%@", locationManager.location);
    pinLocation = locationManager.location;
    NSLog(@"%@", pinLocation);
}

- (IBAction)locateCarPressed:(id)sender {
//    double lat = pinLocation.coordinate.latitude;
//    double lon = pinLocation.coordinate.longitude;
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/?ll=%f,%f", lat, lon]]];
    
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:pinLocation.coordinate
                                                   addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    [mapItem setName:@"My Place"];
    // Pass the map item to the Maps app
    [mapItem openInMapsWithLaunchOptions:nil];
}

- (IBAction)resetPinPressed:(id)sender {
    isPin = NO;
    [self toggleButtonsFor:isPin];
    pinLocation = nil;
    NSLog(@"%@", pinLocation);
}

- (void)toggleButtonsFor:(BOOL)boo {
    if (boo) {
        [self.setPin setEnabled:NO];
        [self.setPin setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [self.locateCar setEnabled:YES];
        [self.locateCar setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [self.resetPin setEnabled:YES];
        [self.resetPin setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    } else {
        [self.setPin setEnabled:YES];
        [self.setPin setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [self.locateCar setEnabled:NO];
        [self.locateCar setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [self.resetPin setEnabled:NO];
        [self.resetPin setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    // Get past two locations and see if their timestamps are between 3 seconds. If so, fire a timer for 1 - 2 seconds that will enable the set pin button if another location is not updated (i.e. the person has stopped moving and the phone has calibrated.)
    if (!lastLocation) {
        // Check if there is a comparable location
        lastLocation = locations[0];
    } else {
        // Set it
        CLLocationDistance distance = [lastLocation distanceFromLocation:locations[0]];
        NSLog(@"%@, %@", lastLocation, locations[0]);
        NSLog(@"%f", distance);
        lastLocation = locations[0];
        
        // If the distance is less than 5 meters, you're good.
        if (distance < 5) pinLocation = locations[0];
    }
}
@end
