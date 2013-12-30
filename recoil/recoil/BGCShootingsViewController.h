//
//  BGCMainViewController.h
//  recoil
//
//  Created by Andrew Beinstein on 7/24/13.
//  Copyright (c) 2013 BGC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "JASidePanelController.h"

@interface BGCShootingsViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) NSMutableArray *casualties;
@property (assign, nonatomic) BOOL casualtiesLoaded;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
