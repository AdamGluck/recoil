//
//  BGCLeftTableViewController.m
//  recoil
//
//  Created by Andrew Beinstein on 7/25/13.
//  Copyright (c) 2013 BGC. All rights reserved.
//

#import "BGCLeftTableViewController.h"
#import "BGCShootingsViewController.h"
#import "BGCDifferenceViewController.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"
#import <Sterling/CloseFriendsDataAccess.h>
#import <Sterling/FriendSuggestionViewController.h>
#import <FacebookSDK/FacebookSDK.h>

@interface BGCLeftTableViewController () <UITableViewDelegate, UITableViewDelegate, CloseFriendsDataAccessDelegate>

@end

@implementation BGCLeftTableViewController 

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern.png"]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier;
    UIImage *cellImage;
    UIImage *highlightedImage;

    switch (indexPath.row) {
        case 0:
            highlightedImage = [UIImage imageNamed:@"shootings_btn_hover.png"];
            cellIdentifier = @"Shootings";
            cellImage = [UIImage imageNamed:@"shootings_btn.png"];
            break;
        case 1:
            highlightedImage = [UIImage imageNamed:@"difference_btn_hover.png"];
            cellIdentifier = @"Difference";
            cellImage = [UIImage imageNamed:@"difference_btn.png"];
            break;
        case 2:
            highlightedImage = [UIImage imageNamed:@"settings_btn_hover.png"];
            cellIdentifier = @"Settings";
            cellImage = [UIImage imageNamed:@"settings_btn.png"];
            break;
        case 3:
            highlightedImage = [UIImage imageNamed:@"inform_btn.png"];
            cellIdentifier = @"Share";
            cellImage = [UIImage imageNamed:@"inform_btn.png"];
            break;
        default:
            cellIdentifier = nil;
            cellImage = nil;
            break;

    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:39.0/255.0 green:35.0/255.0 blue:36.0/255.0 alpha:1.0f];
    if (cell){
        UIImageView * imageView = (UIImageView*)[cell.contentView viewWithTag:1];
        imageView.image = cellImage;
        imageView.highlightedImage = highlightedImage;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL shouldToggle = YES;
    switch (indexPath.row) {
        case 0:
            if ([self.sidePanelController.centerPanel class] != [BGCShootingsViewController class]){
                [self.sidePanelController setCenterPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"shootingsViewController"]];
            }
            break;
        case 1:
            if ([self.sidePanelController.centerPanel class] != [BGCDifferenceViewController class]){
                [self.sidePanelController setCenterPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"differenceViewController"]];
            }
        
            break;
        case 2:
            break;
        case 3:
            shouldToggle = NO;
            if ([CloseFriendsDataAccess loggedIn]){
                [self configureAndPresentFriendsController];
            } else {
                if (!FBSession.activeSession.isOpen){
                    [FBSession openActiveSessionWithReadPermissions:@[@"read_stream"] allowLoginUI:YES completionHandler:^(FBSession * session, FBSessionState status, NSError * error){
                        if (!error){
                            [CloseFriendsDataAccess sharedSterling].delegate = self;
                            [[CloseFriendsDataAccess sharedSterling] sterlingUserLogin];
                        } else {
                            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error with your FBLogin, please login to share." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                            [alert show];
                        }
                    }];
                }
            }
            break;
        default:
            break;
    }
    if (shouldToggle) [self.sidePanelController toggleLeftPanel:nil];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)sterlingServerResponse:(SterlingRequestServerResponse)response
{
    NSLog(@"sterlingserverresponse");
    if (response != SterlingFacebookSessionFailedToOpen && response != SterlingFacebookSessionIsNotTokenLoaded)
    {
        [self configureAndPresentFriendsController];
    }
}

-(void)configureAndPresentFriendsController
{
    FriendSuggestionViewController * dst = [FriendSuggestionViewController initializeFriendSuggestionViewController];
    dst.navigationBar.barTintColor = [UIColor colorWithRed:26.0/255.0 green:23.0/255.0 blue:24.0/255.0 alpha:1.0f];
    dst.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor whiteColor]};
    dst.backgroundView.backgroundColor = [UIColor colorWithRed:26.0/255.0 green:23.0/255.0 blue:24.0/255.0 alpha:1.0f];
    dst.cancelButton.tintColor = [UIColor whiteColor];
    dst.searchButton.tintColor = [UIColor whiteColor];
    dst.selectionColors = @[[UIColor grayColor], [UIColor lightGrayColor],[UIColor colorWithRed:26.0/255.0 green:23.0/255.0 blue:24.0/255.0 alpha:1.0f]];
    [self presentViewController: dst animated:YES completion:nil];
}



@end
