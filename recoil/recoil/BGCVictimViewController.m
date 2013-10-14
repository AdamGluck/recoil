//
//  BGCVictimViewController.m
//  recoil
//
//  Created by Adam Gluck on 10/14/13.
//  Copyright (c) 2013 BGC. All rights reserved.
//

#import "BGCVictimViewController.h"

@interface BGCVictimViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation BGCVictimViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern.png"]];
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@, %i", self.casualty.victimName, self.casualty.victimAge];
    self.nameLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:20.0f];
    self.nameLabel.textColor = [UIColor colorWithRed:218.0/255.0 green:180.0/255.0 blue:105.0/255.0 alpha:1.0f];
    
    self.descriptionLabel.text = [NSString stringWithFormat:@"%@'s death was caused by %@ in a %@ in the neighborhood of %@", self.casualty.victimName, self.casualty.cause.lowercaseString, self.casualty.locationType.lowercaseString, self.casualty.neighborhood];
    self.descriptionLabel.font = [UIFont fontWithName:@"OpenSans" size:12.0f];
    
    if (self.casualty.victimAge <= 1){
        self.imageView.image = [UIImage imageNamed:@"baby_profile"];
    } else if (self.casualty.victimGender == MALE){
        if (self.casualty.victimAge < 18){
            self.imageView.image = [UIImage imageNamed:@"boy_profile"];
        } else {
            self.imageView.image = [UIImage imageNamed:@"man_profile"];
        }
    } else if (self.casualty.victimGender == FEMALE){
        if (self.casualty.victimAge < 18){
            self.imageView.image = [UIImage imageNamed:@"girl_profile"];
        } else {
            self.imageView.image = [UIImage imageNamed:@"woman_profile"];
        }
    }
    
    self.navigationController.navigationBar.topItem.title = @"VICTIM";
    self.navigationController.navigationBar.topItem.titleView.tintColor = [UIColor whiteColor];
}

- (IBAction)readArticlePressed:(id)sender
{
    [[UIApplication sharedApplication] openURL:self.casualty.newsArticle];
}

-(BGCCasualty *) casualty
{
    if (!_casualty)
        _casualty = [[BGCCasualty alloc] init];
    
    return _casualty;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
