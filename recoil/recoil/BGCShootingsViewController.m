//
//  BGCMainViewController.m
//  recoil
//
//  Created by Andrew Beinstein on 7/24/13.
//  Copyright (c) 2013 BGC. All rights reserved.
//

#import "BGCShootingsViewController.h"
#import "BGCRecoilNavigationBar.h"
#import "UIViewController+JASidePanel.h"
#import "BGCRecoilNavigationBar.h"
#import "BGCCasualty.h"
#import "BGCCasualtyLocation.h"
#import <Parse/Parse.h>

typedef enum mapState {
    MAP_STATE_DEATHS,
    MAP_STATE_INJURIES,
    MAP_STATE_HEAT
} BGCMapState;


@interface BGCShootingsViewController () <RecoilNavigationBarDelegate>
@property (nonatomic) BGCMapState currentMapState;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet BGCRecoilNavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UILabel *crimeCount;

@end

@implementation BGCShootingsViewController

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern.png"]];
    [self configureSlider];
    self.currentMapState = MAP_STATE_DEATHS;
    
    
    
}

-(void) viewDidAppear:(BOOL)animated
{
    [self configureNavBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self configureMap];
}

#pragma mark - Map stuff

#define CHICAGO_LATITUDE 41.8500
#define CHICAGO_LONGITUDE -87.6500
#define METERS_PER_MILE 1609.344
#define VIEW_REGION_RADIUS 15
-(void)configureMap
{
    // Set initial viewing region
    CLLocationCoordinate2D chicago;
    chicago.latitude = CHICAGO_LATITUDE;
    chicago.longitude = CHICAGO_LONGITUDE;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(chicago, VIEW_REGION_RADIUS*METERS_PER_MILE, VIEW_REGION_RADIUS*METERS_PER_MILE);
    [self.mapView setRegion:viewRegion];
    
    // Plot casualties
    [self plotCasualties];
    
}

-(void)plotCasualties
{
    // Fetches data from Parse, and plots markers!
    NSLog(@"About to plot casualties");
    // Set up query
    PFQuery *query = [PFQuery queryWithClassName:kBGCParseClassName];
    query.limit = 30;

    
    // Asynchronously plot objects
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // Do something with the found objects
            NSLog(@"Objects: %@", objects[0]);
            for (PFObject *object in objects) {
                BGCCasualty *casualty = [[BGCCasualty alloc] initWithPFObject:object];
                [self addMarkerForCasualty:casualty];
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}

-(void)addMarkerForCasualty:(BGCCasualty *)casualty
{
    BGCCasualtyLocation *annotation = [[BGCCasualtyLocation alloc] initWithCasualty:casualty];
    [self.mapView addAnnotation:annotation];
}

#pragma mark - MKAnnotation Delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"Casualty";
    if ([annotation isKindOfClass:[BGCCasualtyLocation class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!annotationView) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    
    return nil;
}

#pragma mark - UI Methods

- (void)configureSlider
{
    [self.slider setThumbImage:[UIImage imageNamed:@"toggle_control.png"] forState:UIControlStateNormal];
    [self.slider setMinimumTrackImage:[UIImage alloc] forState:UIControlStateNormal];
    [self.slider setMaximumTrackImage:[UIImage alloc] forState:UIControlStateNormal];
}

-(void)configureNavBar
{
    self.navBar.delegate = self;
    self.navBar.title = @"Map";
}

- (IBAction)sliderChanged:(UISlider *)sender {
    float newValue;
    if (sender.value <= 0.5) {
        self.currentMapState = MAP_STATE_DEATHS;
        newValue = 0;
    } else if (sender.value > 0.5 && sender.value < 1.5) {
        self.currentMapState = MAP_STATE_INJURIES;
        newValue = 1;
    } else {
        self.currentMapState = MAP_STATE_HEAT;
        newValue = 2;
    }
    [sender setValue:newValue animated:YES];
}

#pragma mark - navigation

-(void) menuPressed
{
    [self.sidePanelController toggleLeftPanel:nil];
}

-(void) notificationPressed
{
    [self.sidePanelController toggleRightPanel:nil];
}

#pragma mark - ticker functions

- (IBAction)listViewToggle:(id)sender {
}

- (IBAction)mapViewToggle:(id)sender {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}








@end
