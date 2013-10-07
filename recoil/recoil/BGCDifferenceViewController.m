//
//  BGCDifferenceViewController.m
//  recoil
//
//  Created by Adam Gluck on 8/1/13.
//  Copyright (c) 2013 BGC. All rights reserved.
//

#import "BGCDifferenceViewController.h"
#import "BGCRecoilNavigationBar.h"
#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"

@interface BGCDifferenceViewController () <RecoilNavigationBarDelegate>

@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet BGCRecoilNavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UITextView *emphaticQuestionView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionView;


@end

@implementation BGCDifferenceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern.png"]];
    self.infoView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern.png"]];
    self.emphaticQuestionView.font = [UIFont fontWithName:@"OpenSans-Bold" size:14.0f];
    self.descriptionView.font = [UIFont fontWithName:@"OpenSans" size:12.0f];
    
}

-(void) viewDidAppear:(BOOL)animated
{
    
    [self configureNavBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - configuration
-(void) configureNavBar
{
    self.navBar.delegate = self;
    self.navBar.title = @"Difference";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UIImageView * backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"org_list_bar"]];
    cell.backgroundColor = [UIColor clearColor];
    [cell setBackgroundView:backgroundImage];
    switch (indexPath.row) {
        case 0:
            [self configureCell:cell withTitleText:@"CHANGE.ORG" descriptionText:@"Empowering people everywhere to create the change they want to see." andImage:[UIImage imageNamed:@"org_change_icon"]];
            break;
        case 1:
            [self configureCell:cell withTitleText:@"CEASEFIRE ILLINOIS" descriptionText:@"Treating Violence as an Infectious Disease" andImage:[UIImage imageNamed:@"org_Ceasefire_icon"]];
            break;
        case 2:
            [self configureCell:cell withTitleText:@"STOP HANDGUN VIOLENCE" descriptionText:@"A non-profit organization committed to the prevention of gun violence" andImage:[UIImage imageNamed:@"org_STOP_icon"]];
            break;
        case 3:
            [self configureCell:cell withTitleText:@"CAUSES.COM - PUT THE GUNS DOWN" descriptionText:@"A Pledge to Stop Gun Violence in Your Community" andImage:[UIImage imageNamed:@"org_BeyondBullets_icon"]];
            break;
        default:
            break;
    }
    return cell;
}

-(void) configureCell:(UITableViewCell*) cell withTitleText: (NSString *) titleText descriptionText: (NSString *) descriptionText andImage: (UIImage *) image
{
    UITextView * titleView = (UITextView *)[cell viewWithTag:1];
    titleView.text = titleText;
    titleView.font = [UIFont fontWithName:@"OpenSans-Bold" size:12.0f];
    titleView.backgroundColor = [UIColor clearColor];
    UITextView * descriptionView = (UITextView *)[cell viewWithTag:2];
    descriptionView.text = descriptionText;
    descriptionView.font = [UIFont fontWithName:@"OpenSans" size:10.0f];
    descriptionView.backgroundColor = [UIColor clearColor];
    UIImageView * imageView = (UIImageView *)[cell viewWithTag:3];
    imageView.image = image;
    
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
}

#pragma mark - RecoilNavigationBarDelegate

-(void)menuPressed
{
    [self.sidePanelController toggleLeftPanel:nil];
}

-(void)notificationPressed
{
    [self.sidePanelController toggleRightPanel:nil];
}
@end
