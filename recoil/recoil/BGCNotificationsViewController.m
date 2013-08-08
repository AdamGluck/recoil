//
//  BGCNotificationsViewController.m
//  recoil
//
//  Created by Adam Gluck on 8/5/13.
//  Copyright (c) 2013 BGC. All rights reserved.
//

#import "BGCNotificationsViewController.h"
#import "BGCNotificationCell.h"

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
    //[self.tableView registerClass:[BGCNotificationCell class] forCellReuseIdentifier:@"Cell"];
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
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    BGCNotificationCell *cell = (BGCNotificationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    switch (indexPath.row) {
        case 0:
            [cell prepareWithNotificationDescription:@"Aleksandra Hawkins" timeStamp:@"2 MINS AGO" notificationType:NotificationTypeCrimeOccured andColorType:ColorTypeColor];
            break;
        case 1:
            [cell prepareWithNotificationDescription:@"Tanishia Williams" timeStamp:@"2 MINS AGO" notificationType:NotificationTypeCrimeOccured andColorType:ColorTypeColor];
            break;
        case 2:
            [cell prepareWithNotificationDescription:@"Cease Fire Illinois" timeStamp:@"1 DAYS AGO" notificationType:NotificationTypeNewOrganization andColorType:ColorTypeColor];
            break;
        case 3:
            break;
        case 4:
            break;
        case 5:
            break;
        default:
            break;
    }
    
    return cell;
}


@end
