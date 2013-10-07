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
#import "BGCNotificationsViewController.h"
#import <Parse/Parse.h>
#import "BGCAnnotationView.h"

typedef enum mapState {
    MAP_STATE_DEATHS,
    MAP_STATE_INJURIES,
    MAP_STATE_HEAT
} BGCMapState;


@interface BGCShootingsViewController () <RecoilNavigationBarDelegate, BGCAnnotationViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) BGCMapState currentMapState;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet BGCRecoilNavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UILabel *crimeCount;
@property (strong, nonatomic) NSMutableArray *casualties;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@end

@implementation BGCShootingsViewController

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureSlider];
    self.currentMapState = MAP_STATE_DEATHS;
    
    UIColor * pattern = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern.png"]];
    
    self.tableView.backgroundColor = pattern;
    self.tableView.alpha = .99f;
    self.headerView.backgroundColor = pattern;
    self.headerView.alpha = .99f;
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
    //query.limit = 30;
    //query.cachePolicy = kPFCachePolicyCacheElseNetwork;

    // Asynchronously plot objects
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"objects: %@", objects);
            // Do something with the found objects
            //NSLog(@"Objects: %@", objects[0]);
            for (PFObject *object in objects) {
                BGCCasualty *casualty = [[BGCCasualty alloc] initWithPFObject:object];
                [self addMarkerForCasualty:casualty];
                [self.casualties addObject:casualty];
            }
            [self.tableView reloadData];
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

#pragma mark - --MapKit Methods--
#pragma mark - MKAnnotation Delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"Casualty";
    if ([annotation isKindOfClass:[BGCCasualtyLocation class]]) {
        BGCAnnotationView *annotationView = (BGCAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!annotationView) {
            annotationView = [[BGCAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.delegate = self;
            annotationView.enabled = NO;
            annotationView.canShowCallout = NO;
            annotationView.selected = NO;
        } else {
            annotationView.annotation = annotation;
        }
        return annotationView;
    }
    return nil;
}

-(void)calloutTappedForView: (BGCAnnotationView *) view;
{
    NSLog(@"call out tapped");
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"selected");
    if ([view isKindOfClass:[BGCAnnotationView class]]){
        //view.selected = !view.selected;
    }
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"deselected");
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
    
    // Sort casualties by date
    NSArray *casualtyNotifs;
    casualtyNotifs = [self.casualties sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDate *first = ((BGCCasualty *)obj1).dateOccured;
        NSDate *second = ((BGCCasualty *)obj2).dateOccured;
        return [second compare:first];
    }];
    
    ((BGCNotificationsViewController *)self.sidePanelController.rightPanel).casualtyNotifs = [casualtyNotifs mutableCopy];
}

#pragma mark - ticker functions

- (IBAction)listViewToggle:(id)sender {
    self.headerView.hidden = NO;
    self.tableView.hidden = NO;
}

- (IBAction)mapViewToggle:(id)sender {
    self.headerView.hidden = YES;
    self.tableView.hidden = YES;
}

#pragma mark - -- UITableView Methods --
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.casualties.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    UIImageView * backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"org_list_bar"]];
    cell.backgroundColor = [UIColor clearColor];
    backgroundImage.frame = CGRectMake(backgroundImage.frame.origin.x, backgroundImage.frame.origin.y, backgroundImage.frame.size.width - 20, backgroundImage.frame.size.height);
    [cell setBackgroundView:backgroundImage];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67.0;
}

#pragma mark - Lazy

- (NSMutableArray *)casualties {
    if (!_casualties) _casualties = [[NSMutableArray alloc] init];
    return _casualties;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}









@end
