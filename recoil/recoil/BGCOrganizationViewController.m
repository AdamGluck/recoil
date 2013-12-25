//
//  BGCOrganizationViewController.m
//  recoil
//
//  Created by Adam Gluck on 10/24/13.
//  Copyright (c) 2013 BGC. All rights reserved.
//

#import "BGCOrganizationViewController.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface BGCOrganizationViewController () <MFMailComposeViewControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *orgNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtextLabel;

@end

@implementation BGCOrganizationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern.png"]];
    
    self.orgNameLabel.text = [NSString stringWithFormat:@"%@", self.organizationName];
    self.orgNameLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:20.0f];
    self.orgNameLabel.textColor = [UIColor colorWithRed:218.0/255.0 green:180.0/255.0 blue:105.0/255.0 alpha:1.0f];
    
    self.subtextLabel.text = [NSString stringWithFormat:@"%@", self.subtext];
    self.subtextLabel.font = [UIFont fontWithName:@"OpenSans" size:14.0f];
	
    self.imageView.image = [UIImage imageNamed:self.organizationIcon];
}

- (IBAction)visitWeb:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.organizationURL]];
}
- (IBAction)back:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)contactOrganizer:(id)sender {
    if (self.organizationContact.length != 0){
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setToRecipients:@[self.organizationContact]];
        [controller setSubject:@"How can I help out?"];
        [controller setMessageBody:@"Hello, \n I discovered your organization though an app called Recoil. I am a concerned citizen and I wish to make a difference any way I can. Let me know how I can help contribute to your organization. \n Thank you, \n" isHTML:NO];
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    } else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"No contact." message:@"Check out the website to figure out how to help out." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
