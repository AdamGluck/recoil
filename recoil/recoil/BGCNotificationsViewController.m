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

@interface BGCNotificationsViewController ()
@property (strong, nonatomic) BGCCasualty * selectedCasualty;
@property (strong, nonatomic) NSDate * lastViewed;
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
    return self.casualtyNotifs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    BGCNotificationCell *cell = (BGCNotificationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    BGCCasualty *casualty = self.casualtyNotifs[indexPath.row];
    
    if (self.lastViewed){
        if ([self.lastViewed earlierDate:[NSDate date]]){
            [cell prepareWithNotificationDescription:casualty.victimName timeStamp:[casualty.dateOccured stringDaysAgo] notificationType:NotificationTypeCrimeOccured andColorType:ColorTypeGray];
        } else {
            [cell prepareWithNotificationDescription:casualty.victimName timeStamp:[casualty.dateOccured stringDaysAgo] notificationType:NotificationTypeCrimeOccured andColorType:ColorTypeColor];
        }
    } else {
        [cell prepareWithNotificationDescription:casualty.victimName timeStamp:[casualty.dateOccured stringDaysAgo] notificationType:NotificationTypeCrimeOccured andColorType:ColorTypeColor];
    }
    return cell;
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BGCCasualty * casualty = (BGCCasualty *)self.casualtyNotifs[indexPath.row];
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

- (NSMutableArray *)casualtyNotifs
{
    if (!_casualtyNotifs) _casualtyNotifs = [[NSMutableArray alloc] init];
    return _casualtyNotifs;
}



@end
