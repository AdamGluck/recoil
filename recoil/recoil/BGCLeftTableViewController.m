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
#import <FacebookSDK/FacebookSDK.h>

@interface BGCLeftTableViewController () <UITableViewDelegate, UITableViewDelegate>

@property (strong, nonatomic) UIColor * cellColor;

@end

@implementation BGCLeftTableViewController 



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

#define NOTIFICATION_CELL_HEIGHT 103.00
#define STATUS_BAR_OFFSET 20.0

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:26.0/255.0 green:23.0/255.0 blue:24.0/255.0 alpha:1.0f];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        // quick and dirty solution to add spacing to the top bar
        // see: http://stackoverflow.com/questions/18900428/ios-7-uitableview-shows-under-status-bar
        // for discussions of bugs with UITableViewController in relation to status bar
        self.tableView.contentInset = UIEdgeInsetsMake(STATUS_BAR_OFFSET, 0.0f, 0.0f, 0.0f);
    }
    
    [self configureFooter];
}

-(void)configureFooter
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGSize leftoverSize = CGSizeMake(screenSize.width, screenSize.height - (NOTIFICATION_CELL_HEIGHT * 3));
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, leftoverSize.height)];
    footerView.backgroundColor = self.cellColor;
    self.tableView.tableFooterView = footerView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ItemCell";
    UIImage *cellImage;
    UIImage *highlightedImage;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = self.cellColor;
    
    switch (indexPath.row) {
        case 0:
            highlightedImage = [UIImage imageNamed:@"shootings_btn_hover.png"];
            cellImage = [UIImage imageNamed:@"shootings_btn.png"];
            break;
        case 1:
            highlightedImage = [UIImage imageNamed:@"difference_btn_hover.png"];
            cellImage = [UIImage imageNamed:@"difference_btn.png"];
            break;
        case 2:
            highlightedImage = [UIImage imageNamed:@"settings_btn_hover.png"];
            cellImage = [UIImage imageNamed:@"settings_btn.png"];
            break;
        default:
            cellImage = nil;
            break;
    }
        
    UIImageView * imageView = (UIImageView*)[cell.contentView viewWithTag:1];
    imageView.image = cellImage;
    imageView.highlightedImage = highlightedImage;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        default:
            break;
    }
    [self.sidePanelController toggleLeftPanel:nil];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Lazy Instantiation

-(UIColor *)cellColor
{
    if (!_cellColor){
        _cellColor = [UIColor colorWithRed:39.0/255.0 green:35.0/255.0 blue:36.0/255.0 alpha:1.0f];
    }
    return _cellColor;
}

@end
