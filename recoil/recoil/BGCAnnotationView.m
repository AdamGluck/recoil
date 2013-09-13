//
//  BGCAnnotationView.m
//  recoil
//
//  Created by Adam Gluck on 9/12/13.
//  Copyright (c) 2013 BGC. All rights reserved.
//

#import "BGCAnnotationView.h"
#import "BGCCalloutView.h"
@interface BGCAnnotationView() <BGCCalloutViewDelegate>

@end

@implementation BGCAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.image = [UIImage imageNamed:@"death_pin"];
        UIButton * pinButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [pinButton setBackgroundImage:[UIImage imageNamed:@"death_pin"] forState:UIControlStateNormal];
        pinButton.adjustsImageWhenHighlighted = NO;
        pinButton.frame = self.bounds;
        [pinButton addTarget:self action:@selector(pinTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:pinButton];
        self.image = nil;
    }
    return self;
}

-(void)prepareForReuse
{
    [self removeCalloutView];
}

-(void)pinTapped:(UIButton *) button
{
    button.selected = !button.selected;
    if (button.selected){
        BGCCalloutView * callOutView = [[BGCCalloutView alloc] initWithFrame:CGRectZero andCasualty:[[BGCCasualty alloc] init]];
        callOutView.center = CGPointMake(self.bounds.origin.x + (self.bounds.size.width / 2) - 2, self.bounds.origin.y - self.bounds.size.height + 7);
        callOutView.delegate = self;
        [self addSubview:callOutView];
    } else {
        [self removeCalloutView];
    }
    
}

-(void)calloutWasTapped
{
    [self.delegate calloutTappedForView:self];
}

-(void)removeCalloutView
{
    NSLog(@"%@", self.subviews);
    for (id view in self.subviews){
        if ([view isKindOfClass:BGCCalloutView.class]){
            [view removeFromSuperview];
        }
    }
    NSLog(@"%@", self.subviews);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
