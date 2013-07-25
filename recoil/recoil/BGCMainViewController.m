//
//  BGCMainViewController.m
//  recoil
//
//  Created by Andrew Beinstein on 7/24/13.
//  Copyright (c) 2013 BGC. All rights reserved.
//

#import "BGCMainViewController.h"

typedef enum mapState {
    MAP_STATE_DEATHS,
    MAP_STATE_INJURIES,
    MAP_STATE_HEAT
} BGCMapState;


@interface BGCMainViewController ()


@property (nonatomic) BGCMapState currentMapState;

@end

@implementation BGCMainViewController

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
	// Do any additional setup after loading the view.
    self.currentMapState = MAP_STATE_DEATHS;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)sliderChanged:(UISlider *)sender {
    float newValue;
    if (sender.value <= 0.5) {
        self.currentMapState = MAP_STATE_DEATHS;
        newValue = 0;
    } else if (sender.value > 0.5 && sender.value < 1.5) {
        self.currentMapState = MAP_STATE_INJURIES;
        newValue = 1;
    } else {
        self.currentMapState = MAP_STATE_HEAT;
        newValue = 2;
    }
    [sender setValue:newValue animated:YES];
    
}




@end
