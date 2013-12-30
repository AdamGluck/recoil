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
#import "BGCCalloutView.h"
#import "BGCVictimViewController.h"
#import "BGCCalloutAnnotation.h"

typedef enum mapState {
    MAP_STATE_ADULTS,
    MAP_STATE_CHILDREN,
    MAP_STATE_ALL
} BGCMapState;


@interface BGCShootingsViewController () <RecoilNavigationBarDelegate, UITableViewDataSource, UITableViewDelegate>
{
    BOOL rightRevealed;
}

@property (nonatomic) BGCMapState currentMapState;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet BGCRecoilNavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UILabel *crimeCount;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;
@property (strong, nonatomic) BGCCasualty * selectedCasualty;
@property (strong, nonatomic) BGCCalloutAnnotation * callout;
@property (strong, nonatomic) NSMutableArray * childCasualties;
@property (strong, nonatomic) NSMutableArray * adultCasualties;

@end

@implementation BGCShootingsViewController

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureSlider];
    self.currentMapState = MAP_STATE_ALL;
    
    UIColor * pattern = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern.png"]];

    self.tableView.backgroundColor = pattern;
    self.tableView.alpha = .99f;
    self.headerView.backgroundColor = pattern;
    self.headerView.alpha = .98f;
    
    // enables tapping to select
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTapped:)];
    [self.slider addGestureRecognizer:gr];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNotificationReceived:) name:@"pushNotification" object:nil];

    // Fills self.casualty with killer data!
    // This is a sick joke
    [self fetchDataFromParse];
}


static UIImage * girlImage;
static UIImage * boyImage;
static UIImage * womanImage;
static UIImage * manImage;
static UIImage * babyImage;

+(void)initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        babyImage = [UIImage imageNamed:@"Baby_46x60"];
        girlImage = [UIImage imageNamed:@"Girl_46x60"];
        boyImage = [UIImage imageNamed:@"Boy_46x60"];
        manImage = [UIImage imageNamed:@"Man_46x60"];
        womanImage = [UIImage imageNamed:@"Woman_46x60"];
    });
}

-(void) viewDidAppear:(BOOL)animated
{
    self.crimeCount.font = [UIFont fontWithName:@"OpenSans-Bold" size:20.0f];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self configureMap];
    [self configureNavBar];
    [self plotCasualtiesForMapState:self.currentMapState];
}

-(void)pushNotificationRecieved:(NSNotification *)notification
{
    [self fetchDataFromParse];
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
}

-(void)fetchDataFromParse
{
    // Fetches data from Parse, and plots markers!
    PFQuery *query = [PFQuery queryWithClassName:kBGCParseClassName];
    query.limit = 1000;
    
    // Asynchronously plot objects
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // Do something with the found objects
            for (PFObject *object in objects) {
                BGCCasualty *casualty = [[BGCCasualty alloc] initWithPFObject:object];
                if ([casualty.cause  isEqual: @"Gunshot"]) {
                    [self.casualties addObject:casualty];
                    [self addMarkerForCasualty:casualty];
                    
                    if ([casualty isAdult]) {
                        [self.adultCasualties addObject:casualty];
                    } else {
                        [self.childCasualties addObject:casualty];
                    }
                }
            }
            self.casualtiesLoaded = YES;
#warning self.navBar is not set up to configure alert count according to incoming data
            //TODO: Fix this
            [self.navBar configureAlertCountAt:0];
            self.crimeCount.text = [NSString stringWithFormat:@"%i", self.casualties.count];
            [self.tableView reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}

-(void)plotCasualtiesForMapState:(BGCMapState)mapState
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    NSMutableArray *casualtiesToPlot = [[NSMutableArray alloc] init];
    switch (mapState) {
        case MAP_STATE_ALL:
            casualtiesToPlot = self.casualties;
            break;
        case MAP_STATE_ADULTS:
            casualtiesToPlot = self.adultCasualties;
            break;
        case MAP_STATE_CHILDREN:
            casualtiesToPlot = self.childCasualties;
            break;
        default:
            casualtiesToPlot = self.casualties;
            break;
    }
    
    for (BGCCasualty *casualty in casualtiesToPlot) {
        [self addMarkerForCasualty:casualty];
    }
    self.crimeCount.text = [NSString stringWithFormat:@"%i", casualtiesToPlot.count];
}

-(void)addMarkerForCasualty:(BGCCasualty *)casualty
{
    BGCCasualtyLocation *annotation = [[BGCCasualtyLocation alloc] initWithCasualty:casualty];
    [self.mapView addAnnotation:annotation];
}

#pragma mark - --MapKit Methods--
#pragma mark - MKAnnotation Utility Methods

-(void)makeAllMapAnnotationsEnabledState:(BOOL)enabled
{
    for (id mapAnnotation in self.mapView.annotations){
        if ([mapAnnotation isKindOfClass:[BGCCasualtyLocation class]]){
            BGCAnnotationView * view = (BGCAnnotationView *)[self.mapView viewForAnnotation:mapAnnotation];
            view.enabled = enabled;
        }
    }
}

#pragma mark - MKAnnotation Delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"Casualty";
    if ([annotation isKindOfClass:[BGCCasualtyLocation class]]) {
        BGCAnnotationView *annotationView = (BGCAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!annotationView) {
            annotationView = [[BGCAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = NO;
            annotationView.selected = NO;
        } else {
            annotationView.annotation = annotation;
        }
        return annotationView;
    }
    
    if ([annotation isKindOfClass:[BGCCalloutAnnotation class]]){
        // add a callout to the map
        self.callout = (BGCCalloutAnnotation *)annotation;
        BGCCalloutView * calloutView = [[BGCCalloutView alloc] initWithCasualty:self.callout.casualty andAnnotation:annotation];
        return calloutView;
    }
    
    return nil;
}

#define CALLOUT_HEIGHT 62.000000
#define CALLOUT_WIDTH 219.000000

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view isKindOfClass:[BGCCalloutView class]]){
        BGCCalloutAnnotation * annotation = ((BGCCalloutView *) view).annotation;
        self.selectedCasualty = annotation.casualty;
        [self performSegueWithIdentifier:@"crimeInfo" sender:self];
        return;
    }
    
    if ([view isKindOfClass:[BGCAnnotationView class]]){
        if (_callout){
            [self.mapView removeAnnotation:self.callout];
            self.callout = nil;
        }
        BGCCasualtyLocation * annotation = (BGCCasualtyLocation *)view.annotation;
        BGCCalloutAnnotation * callout = [[BGCCalloutAnnotation alloc] initWithCasualty:annotation.casualty];
        [self.mapView addAnnotation:callout];
        // so that callout can be selected and gesture isn't overriden by other pins
        [self makeAllMapAnnotationsEnabledState:NO];
        return;
    }
}


-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if ([view isKindOfClass:[BGCAnnotationView class]]){
        // once it is deselected make it so that other pins can be selected
        [self makeAllMapAnnotationsEnabledState:YES];
        // this gives time for didSelectAnnotationView to trigger and properly reformat
        [self performSelector:@selector(handleDeselect) withObject:nil afterDelay:.01];
    }

    if ([view isKindOfClass:[BGCCalloutView class]] && !self.presentedViewController){
        if (_callout){
            [self.mapView removeAnnotation:_callout];
            self.callout = nil;
        }
    }
}

-(void)handleDeselect
{
    // makes it so that if the _callout is still there then it deselects
    if (_callout){
        [self.mapView removeAnnotation:_callout];
    }
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
    self.navBar.title = @"SHOOTINGS";
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"OpenSans-Bold" size:16.0f], NSFontAttributeName, nil];
    self.navBar.titleTextAttributes = attributes;
}

- (void)sliderTapped:(UIGestureRecognizer *)g {
    UISlider* s = (UISlider*)g.view;
    if (g.state == UIGestureRecognizerStateEnded){
        CGPoint pt = [g locationInView: s];
        CGFloat percentage = pt.x / s.bounds.size.width;
        CGFloat delta = percentage * (s.maximumValue - s.minimumValue);
        CGFloat value = s.minimumValue + delta;
        
        float newValue;
        if (value <= 0.5) {
            self.currentMapState = MAP_STATE_ALL;
            newValue = 0;
        } else if (value > 0.5 && value < 1.5) {
            self.currentMapState = MAP_STATE_ADULTS;
            newValue = 1;
        } else {
            self.currentMapState = MAP_STATE_CHILDREN;
            newValue = 2;
        }
        [s setValue:newValue animated:YES];
        [self plotCasualtiesForMapState:self.currentMapState];
        [self.tableView reloadData];
        // in case there is currently a callout
        [self makeAllMapAnnotationsEnabledState:YES];
    }
}

- (IBAction)sliderChanged:(UISlider *)sender {
    float newValue;
    if (sender.value <= 0.5) {
        self.currentMapState = MAP_STATE_ALL;
        newValue = 0;
    } else if (sender.value > 0.5 && sender.value < 1.5) {
        self.currentMapState = MAP_STATE_ADULTS;
        newValue = 1;
    } else {
        self.currentMapState = MAP_STATE_CHILDREN;
        newValue = 2;
    }
    [sender setValue:newValue animated:YES];
    [self plotCasualtiesForMapState:self.currentMapState];
    [self.tableView reloadData];
    // in case there is currently a callout
    [self makeAllMapAnnotationsEnabledState:YES];
}

#pragma mark - navigation

-(void) menuPressed
{
    [self.sidePanelController toggleLeftPanel:nil];
}

-(void) notificationPressed
{
    if (rightRevealed){
        NSUserDefaults * defaults = [[NSUserDefaults alloc] init];
        [defaults setObject:[NSDate date] forKey:@"last_notification_viewed"];
    }
    [self.sidePanelController toggleRightPanel:nil];
    
    rightRevealed = !rightRevealed;

    NSArray *casualties;
    casualties = [self.casualties sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDate *first = ((BGCCasualty *)obj1).dateOccured;
        NSDate *second = ((BGCCasualty *)obj2).dateOccured;
        return [second compare:first];
    }];
    
    if (self.sidePanelController.rightPanel){
        ((BGCNotificationsViewController *)self.sidePanelController.rightPanel).casualties = [casualties mutableCopy];
        [((BGCNotificationsViewController *)self.sidePanelController.rightPanel) reload];
    }
}

#pragma mark - ticker functions

- (IBAction)listViewToggle:(id)sender {
    [self.menuButton setImage:[UIImage imageNamed:@"list_btn_active"] forState:UIControlStateNormal];
    [self.mapButton setImage:[UIImage imageNamed:@"map_btn_deactive"] forState:UIControlStateNormal];
    self.headerView.hidden = NO;
    self.tableView.hidden = NO;
}

- (IBAction)mapViewToggle:(id)sender {
    [self.menuButton setImage:[UIImage imageNamed:@"list_btn_deactive"] forState:UIControlStateNormal];
    [self.mapButton setImage:[UIImage imageNamed:@"map_btn_active"] forState:UIControlStateNormal];
    self.headerView.hidden = YES;
    self.tableView.hidden = YES;
}

#pragma mark - -- UITableView Methods --
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.currentMapState == MAP_STATE_ALL) {
        return self.casualties.count;
    } else if (self.currentMapState == MAP_STATE_ADULTS) {
        return self.adultCasualties.count;
    } else if (self.currentMapState == MAP_STATE_CHILDREN) {
        return self.childCasualties.count; // fix!!
    } else {
        return self.casualties.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    UIImageView * backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"org_list_bar"]];
    cell.backgroundColor = [UIColor clearColor];
    backgroundImage.frame = CGRectMake(backgroundImage.frame.origin.x, backgroundImage.frame.origin.y, backgroundImage.frame.size.width - 20, backgroundImage.frame.size.height);
    [cell setBackgroundView:backgroundImage];
    
    BGCCasualty *casualty;
    
    switch (self.currentMapState) {
        case MAP_STATE_ALL:
            casualty = self.casualties[indexPath.row];
            break;
        case MAP_STATE_ADULTS:
            casualty = self.adultCasualties[indexPath.row];
            break;
        case MAP_STATE_CHILDREN:
            casualty = self.childCasualties[indexPath.row];
            break;
        default:
            casualty = self.casualties[indexPath.row];
            break;
    }
    
    
    UITextField * nameField = (UITextField *)[cell viewWithTag:1];    
    nameField.text = [NSString stringWithFormat:@"%@, %i", casualty.victimName, casualty.victimAge];
    nameField.font = [UIFont fontWithName:@"OpenSans" size:12.0f];
    nameField.textColor = [UIColor colorWithRed:218.0/255.0 green:180.0/255.0 blue:105.0/255.0 alpha:1.0f];
    
    UITextField * detailsField = (UITextField *)[cell viewWithTag:2];
    detailsField.text = casualty.address;
    detailsField.font = [UIFont fontWithName:@"OpenSans" size:10.0f];
    detailsField.textColor = [UIColor whiteColor];

    UIImageView * imageView = (UIImageView *)[cell viewWithTag:3];
    imageView.image = nil;
    if ([casualty isBaby]){
        imageView.image = babyImage;
    } else if (casualty.victimGender == MALE){
        if (![casualty isAdult]){
            imageView.image = boyImage;
        } else {
            imageView.image = manImage;
        }
    } else if (casualty.victimGender == FEMALE){
        if (![casualty isAdult]){
            imageView.image = girlImage;
        } else {
            imageView.image = womanImage;
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BGCCasualty *casualty;
    switch (self.currentMapState) {
        case MAP_STATE_ALL:
            casualty = self.casualties[indexPath.row];
            break;
        case MAP_STATE_ADULTS:
            casualty = self.adultCasualties[indexPath.row];
            break;
        case MAP_STATE_CHILDREN:
            casualty = self.childCasualties[indexPath.row];
            break;
        default:
            casualty = self.casualties[indexPath.row];
            break;
    }
    self.selectedCasualty = casualty;
    [self performSegueWithIdentifier:@"crimeInfo" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"crimeInfo"]){
        UINavigationController * nav = (UINavigationController *)segue.destinationViewController;
        BGCVictimViewController * dst = (BGCVictimViewController *)nav.topViewController;
        dst.casualty = self.selectedCasualty;
    }
}

#pragma mark - Lazy

-(BGCCasualty *) selectedCasualty
{
    if (!_selectedCasualty){
        _selectedCasualty = [[BGCCasualty alloc] init];
    }
    return _selectedCasualty;
}

- (NSMutableArray *)casualties {
    if (!_casualties){
        _casualties = [[NSMutableArray alloc] init];
    }
    return _casualties;
}

- (NSMutableArray *)adultCasualties {
    if (!_adultCasualties){
        _adultCasualties = [[NSMutableArray alloc] init];
    }
    return _adultCasualties;
}

- (NSMutableArray *)childCasualties {
    if (!_childCasualties){
        _childCasualties = [[NSMutableArray alloc] init];
    }
    return _childCasualties;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
