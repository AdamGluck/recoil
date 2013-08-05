//
//  BGCSidebarViewController.m
//  recoil
//
//  Created by Andrew Beinstein on 7/25/13.
//  Copyright (c) 2013 BGC. All rights reserved.
//

#import "BGCSidebarViewController.h"

@interface BGCSidebarViewController ()

@end

@implementation BGCSidebarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#define LEFT_SIDEBAR_WIDTH 105
#define RIGHT_SIDEBAR_WIDTH 255
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.leftFixedWidth = LEFT_SIDEBAR_WIDTH;
    self.rightFixedWidth = RIGHT_SIDEBAR_WIDTH;
    self.recognizesPanGesture = YES;
    self.bounceOnSidePanelClose = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) awakeFromNib
{
    [self setLeftPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"leftViewController"]];
    [self setCenterPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"shootingsViewController"]];
    [self setRightPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"notificationsViewController"]];
}


@end
