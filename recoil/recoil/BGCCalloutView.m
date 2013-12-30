//
//  BGCCalloutView.m
//  recoil
//
//  Created by Adam Gluck on 9/12/13.
//  Copyright (c) 2013 BGC. All rights reserved.
//

#import "BGCCalloutView.h"

@interface BGCCalloutView() <UIGestureRecognizerDelegate>

@end

@implementation BGCCalloutView

-(id)initWithCasualty:(BGCCasualty *)casualty andAnnotation:(id<MKAnnotation>)annotation
{
    self = [super initWithAnnotation:annotation reuseIdentifier:nil];
    if (self){
        self.image = [UIImage imageNamed:@"victim_bubble"];
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.image = [UIImage imageNamed:@"victim_bubble"];
        [self addSubview:imageView];
        
        UILabel * name = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + 60, imageView.frame.origin.y + 6, 100, 40)];
        name.text = [NSString stringWithFormat:@"%@, %i", casualty.victimName, casualty.victimAge];
        name.numberOfLines = 2;
        name.textColor = [UIColor whiteColor];
        name.font = [UIFont fontWithName:@"OpenSans-Bold" size:14.0f];
        name.backgroundColor = [UIColor clearColor];
        [self insertSubview:name aboveSubview:imageView];
        
        UIImageView * personIcon = [[UIImageView alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + 17, imageView.frame.origin.y + 10, 25, 36)];
        
        if (casualty.victimAge <= 1){
            personIcon.image = [UIImage imageNamed:@"Baby_50x72"];
        } else if (casualty.victimGender == MALE){
            if (casualty.victimAge < 18){
                personIcon.image = [UIImage imageNamed:@"Boy_50x72"];
            } else {
                personIcon.image = [UIImage imageNamed:@"Man_50x72"];
            }
        } else if (casualty.victimGender == FEMALE){
            if (casualty.victimAge < 18){
                personIcon.image = [UIImage imageNamed:@"Girl_50x72"];
            } else {
                personIcon.image = [UIImage imageNamed:@"Woman_50x72"];
            }
        }
        
        self.centerOffset = CGPointMake(-2.0, -52.5);
        
        personIcon.center = CGPointMake(personIcon.center.x, imageView.center.y - 5);
        [self insertSubview:personIcon aboveSubview:imageView];
        
        self.image = nil;
        self.userInteractionEnabled = YES;

    }
    
    return self;
}

/*
-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self){
        self.image = [UIImage imageNamed:@"victim_bubble"];
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.image = [UIImage imageNamed:@"victim_bubble"];
        [self addSubview:imageView];
        
        UILabel * name = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + 50, imageView.frame.origin.y + 10, 30, 30)];
        name.text = @"Test";
        name.numberOfLines = 2;
        name.textColor = [UIColor whiteColor];
        name.font = [UIFont fontWithName:@"OpenSans-Bold" size:12.0f];
        [self insertSubview:name aboveSubview:imageView];
        
        self.image = nil;
        
        UIButton * calloutButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [calloutButton setBackgroundImage:[UIImage imageNamed:@"victim_bubble"] forState:UIControlStateNormal];
        calloutButton.adjustsImageWhenHighlighted = NO;
        calloutButton.frame = self.bounds;
        [calloutButton addTarget:self action:@selector(calloutTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:calloutButton];
        self.image = nil;
        
        
        
        self.userInteractionEnabled = YES;
        self.centerOffset = CGPointMake(-2.0, -52.5);
    }
    return self;
}
 
*/

@end
