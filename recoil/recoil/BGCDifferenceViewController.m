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
#import "BGCOrganizationViewController.h"

@interface BGCDifferenceViewController () <RecoilNavigationBarDelegate>

@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet BGCRecoilNavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UITextView *emphaticQuestionView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionView;
@property (strong, nonatomic) NSIndexPath * indexPath;
@property (strong, nonatomic) NSArray * imageStrings;


@end

@implementation BGCDifferenceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern.png"]];
    self.infoView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern.png"]];
    self.emphaticQuestionView.font = [UIFont fontWithName:@"OpenSans-Bold" size:14.0f];
    self.descriptionView.font = [UIFont fontWithName:@"OpenSans" size:12.0f];
    self.imageStrings = @[@"org_Ceasefire_icon", @"org_STOP_icon", @"org_ProjectSafe_icon", @"org_BeyondBullets_icon", @"org_IllinoisCouncil_icon", @"org_STOP_icon", @"org_United_icon", @"org_Safer_icon", @"org_TeamEnglewood_icon", @"org_CAP_profile", @"org_YouthGuidance_icon", @"org_CYC_icon", @"org_YouthOutreach_icon"];
}

-(void)viewDidAppear:(BOOL)animated
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
    
    // Font is too small here, and overflows if I make it bigger
//    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"OpenSans-Bold" size:12.0f], NSFontAttributeName, nil];
//    self.navBar.titleTextAttributes = attributes;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 13;
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
            [self configureCell:cell withTitleText:@"Ceasefire Illinois" descriptionText:@"Treating Violence as an Infectious Disease." andImage:[UIImage imageNamed:@"org_Ceasefire_icon"]];
            break;
        case 1:
            [self configureCell:cell withTitleText:@"Stop Handgun Violence" descriptionText:@"A non-profit organization committed to the prevention of gun violence." andImage:[UIImage imageNamed:@"org_STOP_icon"]];
            
            break;
        case 2:
            [self configureCell:cell withTitleText:@"Project Safe Neighborhoods" descriptionText:@"America's network against gun violence - Chicago." andImage:[UIImage imageNamed:@"org_ProjectSafe_icon"]];
            break;
        case 3:
            [self configureCell:cell withTitleText:@"Beyond Bullets" descriptionText:@"Americans using media to stop gun violence." andImage:[UIImage imageNamed:@"org_BeyondBullets_icon"]];
            break;
        case 4:
            [self configureCell:cell withTitleText:@"Illinois Council Against Handgun Violence" descriptionText:@"Hangun violence prevention." andImage:[UIImage imageNamed:@"org_IllinoisCouncil_icon"]];
            break;
        case 5:
            [self configureCell:cell withTitleText:@"Coalition to Stop Gun Violence" descriptionText:@"We seek to secure freedom from gun violence through research, strategic engagement and effective policy advocacy." andImage:[UIImage imageNamed:@"org_StopGV_icon"]];
            break;
        case 6:
            [self configureCell:cell withTitleText:@"States United to Prevent Gun Violence" descriptionText:@"Empowering state advocates to save lives." andImage:[UIImage imageNamed:@"org_United_icon"]];
            break;
        case 7:
            [self configureCell:cell withTitleText:@"Safer Foundation" descriptionText:@"Promoting successful reentry and reducing recidivism." andImage:[UIImage imageNamed:@"org_Safer_icon"]];
            break;
        case 8:
            [self configureCell:cell withTitleText:@"Teamwork Englewood" descriptionText:@"Together, each achieves more." andImage:[UIImage imageNamed:@"org_TeamEnglewood_icon"]];
            break;
        case 9:
            [self configureCell:cell withTitleText:@"Chicago Area Project" descriptionText:@"Strengthening neighborhoods. Helping young people." andImage:[UIImage imageNamed:@"org_CAP_profile"]];
            break;
        case 10:
            [self configureCell:cell withTitleText:@"Youth Guidance" descriptionText:@"Guiding kids to bright futures." andImage:[UIImage imageNamed:@"org_YouthGuidance_icon"]];
            break;
        case 11:
            [self configureCell:cell withTitleText:@"Chicago Youth Centers’" descriptionText:@"Investing in youth." andImage:[UIImage imageNamed:@"org_CYC_icon"]];
            break;
        case 12:
            [self configureCell:cell withTitleText:@"Youth Outreach Services" descriptionText:@"Committed to caring. Inspiring change." andImage:[UIImage imageNamed:@"org_YouthOutreach_icon"]];
            break;
        default:
            break;
    }
    
    return cell;
}

typedef NS_ENUM(NSInteger, SubViewTags){
    TitleViewTag = 1,
    DescriptionViewTag = 2,
    ImageViewTag = 3,
};

-(void) configureCell:(UITableViewCell*) cell withTitleText: (NSString *) titleText descriptionText: (NSString *) descriptionText andImage: (UIImage *) image
{
    UITextView * titleView = (UITextView *)[cell viewWithTag:TitleViewTag];
    titleView.text = titleText;
    titleView.font = [UIFont fontWithName:@"OpenSans-Bold" size:14.0f];
    titleView.backgroundColor = [UIColor clearColor];
    UITextView * descriptionView = (UITextView *)[cell viewWithTag:DescriptionViewTag];
    descriptionView.text = descriptionText;
    descriptionView.font = [UIFont fontWithName:@"OpenSans" size:12.0f];
    descriptionView.backgroundColor = [UIColor clearColor];
    UIImageView * imageView = (UIImageView *)[cell viewWithTag:ImageViewTag];
    imageView.image = image;
    
}

#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.indexPath = indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"presentOrg" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"presentOrg"]){
        NSArray * links = @[@"http://cureviolence.org/",
                            @"http://www.stophandgunviolence.org/‎",
                            @"http://www.psnchicago.org/",
                            @"http://www.beyondbullets.org/",
                            @"http://www.ichv.org/",
                            @"http://www.csgv.org/",
                            @"http://www.supgv.org/",
                            @"http://www.saferfoundation.org/",
                            @"http://www.teamworkenglewood.org",
                            @"http://www.chicagoareaproject.org",
                            @"http://www.youth-guidance.org/",
                            @"http://www.chicagoyouthcenters.org/",
                            @"http://www.yos.org/"];
        
        NSArray * contacts = @[@"patb@uic.edu",
                               @"shv@stophandgunviolence.com",
                               @"",
                               @"stephanie@dctvny.org",
                               @"info@ichv.org",
                               @"",
                               @"info@supgv.org",
                               @"",
                               @"",
                               @"info@chicagoareaproject.org",
                               @"info@youth-guidance.org",
                               @"Beth.Carona@ChicagoYouthCenters.org",
                               @"rickv@yos.org"];
        
        // a little sloppy here but it gets the job done
        // scalable solution = core data model
        UINavigationController * nav = (UINavigationController *)segue.destinationViewController;
        BGCOrganizationViewController * dst = (BGCOrganizationViewController *)nav.topViewController;
        UITableViewCell * selectedCell = [self.tableView cellForRowAtIndexPath:self.indexPath];
        dst.organizationName = ((UITextView *)[selectedCell viewWithTag:TitleViewTag]).text;
        dst.subtext = ((UITextView *)[selectedCell viewWithTag:DescriptionViewTag]).text;
        dst.organizationIcon = self.imageStrings[self.indexPath.row];
        dst.organizationURL = links[self.indexPath.row];
        dst.organizationContact = contacts[self.indexPath.row];
    }
    
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
