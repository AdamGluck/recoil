//
//  BGCLeftTableViewController.m
//  recoil
//
//  Created by Andrew Beinstein on 7/25/13.
//  Copyright (c) 2013 BGC. All rights reserved.
//

#import "BGCLeftTableViewController.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"

@interface BGCLeftTableViewController () <UITableViewDelegate, UITableViewDelegate>

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
    return 3;
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
        default:
            cellIdentifier = nil;
            cellImage = nil;
            break;

    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (cell){
        cell.imageView.image = cellImage;
        cell.imageView.highlightedImage = highlightedImage;
    }
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toShootings"]) {
        //blank
    } else if ([segue.identifier isEqualToString:@"toDifference"]) {
        //blank
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    switch (indexPath.row) {
        case 0:
            
            [self.sidePanelController toggleLeftPanel:nil];
            break;
            
        case 1:
            [self.sidePanelController setCenterPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"differenceViewController"]];
            [self.sidePanelController toggleLeftPanel:nil];
            break;

        default:
            break;
    }
}

@end
