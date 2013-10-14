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

typedef enum mapState {
    MAP_STATE_ADULTS,
    MAP_STATE_CHILDREN,
    MAP_STATE_ALL
} BGCMapState;


@interface BGCShootingsViewController () <RecoilNavigationBarDelegate, BGCAnnotationViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) BGCMapState currentMapState;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet BGCRecoilNavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UILabel *crimeCount;
@property (strong, nonatomic) NSMutableArray *casualties;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;
@property (strong, nonatomic) BGCCasualty * selectedCasualty;

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
    
    // Fills self.casualty with killer data! (pun intended)
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
        babyImage = [UIImage imageNamed:@"baby_profile"];
        girlImage = [UIImage imageNamed:@"girl_icon"];
        boyImage = [UIImage imageNamed:@"boy_profile"];
        manImage = [UIImage imageNamed:@"man_profile"];
        womanImage = [UIImage imageNamed:@"woman_icon"];
    });
}

-(void) viewDidAppear:(BOOL)animated
{
    [self configureNavBar];
    self.crimeCount.font = [UIFont fontWithName:@"OpenSans-Bold" size:20.0f];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [self configureMap];
    // Plot casualties
    [self plotCasualtiesForMapState:self.currentMapState];
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
    NSLog(@"About to plot casualties");
    // Set up query
    PFQuery *query = [PFQuery queryWithClassName:kBGCParseClassName];
    query.limit = 1000;
    //query.cachePolicy = kPFCachePolicyCacheElseNetwork;

    // Asynchronously plot objects
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"objects: %@", objects);
            // Do something with the found objects
            for (PFObject *object in objects) {
                BGCCasualty *casualty = [[BGCCasualty alloc] initWithPFObject:object];
                [self.casualties addObject:casualty];
                [self addMarkerForCasualty:casualty];
            }
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
    if (mapState == MAP_STATE_ALL) {
        for (BGCCasualty *casualty in self.casualties) {
            [self addMarkerForCasualty:casualty];
        }
    } else if (mapState == MAP_STATE_ADULTS) {
        for (BGCCasualty *casualty in self.casualties) {
            if (casualty.victimAge >= 18) {
                [self addMarkerForCasualty:casualty];
            }
        }
    } else if (mapState == MAP_STATE_CHILDREN) {
        for (BGCCasualty *casualty in self.casualties) {
            if (casualty.victimAge < 18) {
                [self addMarkerForCasualty:casualty];
            }
        }
    }
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
       // MKAnnotationView * annotationView = (MKAnnotationView*) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        BGCAnnotationView *annotationView = (BGCAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!annotationView) {
            /*
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            */
            
            annotationView = [[BGCAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.delegate = self;
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.selected = NO;
            
        } else {
            annotationView.annotation = annotation;
        }
        annotationView.image = [UIImage imageNamed:@"death_pin"];

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
    return self.casualties.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    UIImageView * backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"org_list_bar"]];
    cell.backgroundColor = [UIColor clearColor];
    backgroundImage.frame = CGRectMake(backgroundImage.frame.origin.x, backgroundImage.frame.origin.y, backgroundImage.frame.size.width - 20, backgroundImage.frame.size.height);
    [cell setBackgroundView:backgroundImage];
    
    BGCCasualty * casualty = self.casualties[indexPath.row];
    
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
    if (casualty.victimAge <= 1){
        imageView.image = babyImage;
    } else if (casualty.victimGender == MALE){
        if (casualty.victimAge < 18){
            imageView.image = boyImage;
        } else {
            imageView.image = manImage;
        }
    } else if (casualty.victimGender == FEMALE){
        if (casualty.victimAge < 18){
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
    NSLog(@"didSelectRow");
    
    BGCCasualty * casualty = self.casualties[indexPath.row];
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
    if (!_casualties) _casualties = [[NSMutableArray alloc] init];
    return _casualties;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}









@end
