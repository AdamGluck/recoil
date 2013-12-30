//
//  BGCNotificationsViewController.m
//  recoil
//
//  Created by Adam Gluck on 8/5/13.
//  Copyright (c) 2013 BGC. All rights reserved.
//

#import "BGCNotificationsViewController.h"
#import "BGCNotificationCell.h"
#import <Parse/Parse.h>
#import "BGCCasualty.h"
#import "BGCVictimViewController.h"
#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"
#import "BGCShootingsViewController.h"

@interface BGCNotificationsViewController ()
@property (strong, nonatomic) BGCCasualty * selectedCasualty;
@property (strong, nonatomic) NSDate * lastViewed;
@property (strong, nonatomic) NSOperationQueue * operationQueue;
@end

@implementation BGCNotificationsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern.png"]];
    if (!self.casualties.count){
        [self checkForCasualtiesInBackground];
    }
}

-(void)checkForCasualtiesInBackground
{
    __weak typeof(self) weakSelf = self;
    NSBlockOperation *operation =
    
    [NSBlockOperation blockOperationWithBlock:
     ^{
         if ([weakSelf.sidePanelController.centerPanel isKindOfClass:[BGCShootingsViewController class]]){
             BGCShootingsViewController * victimController = (BGCShootingsViewController *) weakSelf.sidePanelController.centerPanel;
             while (!victimController.casualtiesLoaded); // block thread until victims load
             [[NSOperationQueue mainQueue] addOperationWithBlock:
              ^{
                  self.casualties = victimController.casualties;
                  NSArray * casualties;
                  casualties = [self.casualties sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                      NSDate *first = ((BGCCasualty *)obj1).dateOccured;
                      NSDate *second = ((BGCCasualty *)obj2).dateOccured;
                      return [second compare:first];
                  }];
                  self.casualties = [casualties mutableCopy];
                  [self.tableView reloadData];
              }];
         }
     }];
    
    [self.operationQueue addOperation:operation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

-(void)reload
{
    [self.tableView reloadData];
}

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
    static NSString *CellIdentifier = @"Cell";
    BGCNotificationCell *cell = (BGCNotificationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    BGCCasualty *casualty = self.casualties[indexPath.row];
    
    if (self.lastViewed){
        if ([self.lastViewed earlierDate:[NSDate date]]){
            [cell prepareWithNotificationDescription:casualty.victimName timeStamp:[casualty.dateOccured stringDaysAgoAgainstMidnight:NO] notificationType:NotificationTypeCrimeOccured andColorType:ColorTypeGray];
        } else {
            [cell prepareWithNotificationDescription:casualty.victimName timeStamp:[casualty.dateOccured stringDaysAgoAgainstMidnight:NO] notificationType:NotificationTypeCrimeOccured andColorType:ColorTypeColor];
        }
    } else {
        [cell prepareWithNotificationDescription:casualty.victimName timeStamp:[casualty.dateOccured stringDaysAgoAgainstMidnight:NO] notificationType:NotificationTypeCrimeOccured andColorType:ColorTypeColor];
    }
    
    if (indexPath.row == self.casualties.count){
        [self makeLastViewedUserDefaultMostRecentEvent];
    }
    
    return cell;
}

#pragma mark - Data Source Helper Methods

// this method assums an ordered casualty list by date descending
// this assumption is emphasized in the header under the casualties property
-(void)makeLastViewedUserDefaultMostRecentEvent
{
    if (_casualties){
        BGCCasualty * mostRecentCasualty = self.casualties[0];
        NSUserDefaults * defaults = [[NSUserDefaults alloc] init];
        [defaults setObject:mostRecentCasualty.dateOccured forKey:@"last_notification_viewed"];
    }
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BGCCasualty * casualty = (BGCCasualty *)self.casualties[indexPath.row];
    self.selectedCasualty = casualty;
    [self performSegueWithIdentifier:@"notificationCrimeInfo" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"notificationCrimeInfo"]){
        UINavigationController * nav = (UINavigationController *)segue.destinationViewController;
        BGCVictimViewController * dst = (BGCVictimViewController *)nav.topViewController;
        dst.casualty = self.selectedCasualty;
    }
}

#pragma mark -- Lazy instantiation

-(NSDate *)lastViewed
{
    if (!_lastViewed){
        NSUserDefaults * defauts = [[NSUserDefaults alloc] init];
        if ([defauts objectForKey:@"last_notification_viewed"]){
            _lastViewed = (NSDate *) [defauts objectForKey:@"last_notification_viewed"];
        } else {
            _lastViewed = nil;
        }
    }
    return _lastViewed;
}

-(BGCCasualty *)selectedCasualty
{
    if (!_selectedCasualty)
        _selectedCasualty = [[BGCCasualty alloc] init];
    return _selectedCasualty;
}

- (NSMutableArray *)casualties
{
    if (!_casualties)
        _casualties = [[NSMutableArray alloc] init];
    return _casualties;
}

-(NSOperationQueue *)operationQueue
{
    if (!_operationQueue){
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.name = @"Checking for Loaded Queue";
    }
    return _operationQueue;
}

@end
