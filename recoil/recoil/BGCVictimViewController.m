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
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@%@", [self.casualty.victimName length] != 0 ? self.casualty.victimName : @"(Name unknown)", self.casualty.victimAge ? [NSString stringWithFormat:@", %i", self.casualty.victimAge] : @""];
    self.nameLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:20.0f];
    self.nameLabel.textColor = [UIColor colorWithRed:218.0/255.0 green:180.0/255.0 blue:105.0/255.0 alpha:1.0f];

    NSString *descriptionLabelText = @"";
    if ([self.casualty.victimName length] != 0) {
        descriptionLabelText = [descriptionLabelText stringByAppendingString:[NSString stringWithFormat:@"%@'s", self.casualty.victimName]];
    }
    if ([self.casualty.cause length] != 0) {
        descriptionLabelText = [descriptionLabelText stringByAppendingString:[NSString stringWithFormat:@" death was caused by %@", self.casualty.cause.lowercaseString]];
    }
    if ([self.casualty.locationType length] != 0) {
        descriptionLabelText = [descriptionLabelText stringByAppendingString:[NSString stringWithFormat:@" in a %@", self.casualty.locationType.lowercaseString]];
    }
    if ([self.casualty.neighborhood length] != 0) {
        descriptionLabelText = [descriptionLabelText stringByAppendingString:[NSString stringWithFormat:@" in the neighborhood of %@", self.casualty.neighborhood]];
    }
    
    // Trim whitespace and capitalize first letter
    descriptionLabelText = [descriptionLabelText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSLog(@"%@", descriptionLabelText);
    descriptionLabelText = [descriptionLabelText stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[descriptionLabelText substringToIndex:1] uppercaseString]];
    
    self.descriptionLabel.text = descriptionLabelText;
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

- (IBAction)backButtonPressed:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
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
