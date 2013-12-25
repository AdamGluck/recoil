//
//  BGCSettingsViewController.m
//  recoil
//
//  Created by Adam Gluck on 12/25/13.
//  Copyright (c) 2013 BGC. All rights reserved.
//

#import "BGCSettingsViewController.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface BGCSettingsViewController () <MFMailComposeViewControllerDelegate, UINavigationControllerDelegate>

@end

@implementation BGCSettingsViewController

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
    return 4;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"About" message:@"\n Recoil is a homicide tracker that encourages users to make a difference by getting involved in local organizations and spreading awareness of Chicago gun violence." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alert show];
    } else if (indexPath.row == 1){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Push Notifications" message:@"You can change push notifications in the Settings -> Notification Center by selecting Recoil under the section labeled include." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alert show];
    } else if (indexPath.row == 2){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Terms of Service" message:@"1. Recoil is not affiliated, associated, authorized, endorsed by, or in any way officially connected with organizations listed within “make a difference” section. You expressly agree that use of the service is at your sole risk. The official Recoil web site is available at www.recoil-app.com. \n \n 2. While Recoil uses reasonable efforts to include accurate and up-to-date information, we make no warranties or representations as to the accuracy of the content and assume no liability or responsibility for any error or omission in the content. You expressly agree that use of the service is at your sole risk." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alert show];
    } else {
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setToRecipients:@[@"info@recoil-app.com"]];
        [controller setSubject:@""];
        [controller setMessageBody:@"" isHTML:NO];
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)back:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
