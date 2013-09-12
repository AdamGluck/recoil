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

@interface BGCNotificationsViewController ()



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
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.casualtyNotifs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    BGCNotificationCell *cell = (BGCNotificationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
//    switch (indexPath.row) {
//        case 0:
//            [cell prepareWithNotificationDescription:@"Aleksandra Hawkins" timeStamp:@"2 MINS AGO" notificationType:NotificationTypeCrimeOccured andColorType:ColorTypeColor];
//            break;
//        case 1:
//            [cell prepareWithNotificationDescription:@"Tanishia Williams" timeStamp:@"2 MINS AGO" notificationType:NotificationTypeCrimeOccured andColorType:ColorTypeColor];
//            break;
//        case 2:
//            [cell prepareWithNotificationDescription:@"Cease Fire Illinois" timeStamp:@"1 DAY AGO" notificationType:NotificationTypeNewOrganization andColorType:ColorTypeColor];
//            break;
//        case 3:
//            [cell prepareWithNotificationDescription:@"Change" timeStamp:@"5 DAYS AGO" notificationType:NotificationTypeNewOrganization andColorType:ColorTypeGray];
//            break;
//        case 4:
//            [cell prepareWithNotificationDescription:@"Lawrence Smith" timeStamp:@"7 DAYS AGO" notificationType:NotificationTypeCrimeOccured andColorType:ColorTypeGray];
//            break;
//        case 5:
//            [cell prepareWithNotificationDescription:@"Lawrence Smith Jr." timeStamp:@"7 DAYS AGO" notificationType:NotificationTypeCrimeOccured andColorType:ColorTypeGray];
//            break;
//        default:
//            break;
//    }
    BGCCasualty *casualty = self.casualtyNotifs[indexPath.row];
    [cell prepareWithNotificationDescription:casualty.victimName timeStamp:[casualty.dateOccured stringDaysAgo] notificationType:NotificationTypeCrimeOccured andColorType:ColorTypeColor];
    
    return cell;
}

#pragma mark -- Lazy instantiation
- (NSMutableArray *)casualtyNotifs
{
    if (!_casualtyNotifs) _casualtyNotifs = [[NSMutableArray alloc] init];
    return _casualtyNotifs;
}



@end
