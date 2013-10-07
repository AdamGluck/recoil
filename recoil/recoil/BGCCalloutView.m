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

-(id)initWithFrame: (CGRect)frame andCasualty:(BGCCasualty *)casualty
{
    UIImage * callOutImage = [UIImage imageNamed:@"victim_bubble"];
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, callOutImage.size.width, callOutImage.size.height)];
    if (self){
        UIImageView * calloutImageView = [[UIImageView alloc] initWithImage:callOutImage];
        [self addSubview:calloutImageView];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    NSLog(@"should receive");
    return YES;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"shouldBegin");
    return YES;
}

-(void)tapped:(UIGestureRecognizer *) recognizer
{
    NSLog(@"tapped: in calloutView class called");
    [self.delegate calloutWasTapped];
}

@end
