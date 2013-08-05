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

#define LEFT_SIDEBAR_WIDTH 107
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.leftFixedWidth = LEFT_SIDEBAR_WIDTH;
    self.recognizesPanGesture = NO;

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
    [self setRightPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"rightViewController"]];
}

//- (UIBarButtonItem *)leftButtonForCenterPanel
//{
//    UIImage *buttonImage = [UIImage imageNamed:@"menu_icon.png"];
//    UIImage *buttonImage_hover = [UIImage imageNamed:@"menu_icon.png"];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [button setImage:buttonImage forState:UIControlStateNormal];
//    [button setImage:buttonImage_hover forState:UIControlStateHighlighted];
//    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    return barButton;
//    
//}

//- (UIBarButtonItem *)leftButtonForCenterPanel {
//    UIImage *buttonImage = [UIImage imageNamed:@"menu_icon.png"];
//    UIImage *buttonImage_hover = [UIImage imageNamed:@"menu_icon_hover.png"];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [button setImage:buttonImage forState:UIControlStateNormal];
//    [button setImage:buttonImage_hover forState:UIControlStateHighlighted];
//    
////    UIImageView *buttonImageView = [[UIImageView alloc] initWithImage:buttonImage highlightedImage:buttonImage_hover];
////
////    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:buttonImageView];
////    [barButton setStyle:UIBarButtonItemStylePlain];
////    [barButton setTarget:self];
////    [barButton setAction:@selector(toggleLeftPanel:)];
////     
////    return barButton;
//    return [[UIBarButtonItem alloc] initWithImage:buttonImage style:UIBarButtonItemStylePlain target:self action:@selector(toggleLeftPanel:)];
//}


@end
