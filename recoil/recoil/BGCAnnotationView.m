//
//  BGCAnnotationView.m
//  recoil
//
//  Created by Adam Gluck on 9/12/13.
//  Copyright (c) 2013 BGC. All rights reserved.
//

#import "BGCAnnotationView.h"
#import "BGCCalloutView.h"
@interface BGCAnnotationView() <BGCCalloutViewDelegate, UIGestureRecognizerDelegate>

@end

@implementation BGCAnnotationView

#define CALLOUT_HEIGHT 62.000000
#define CALLOUT_WIDTH 219.000000
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
        self.userInteractionEnabled = YES;
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
        
        /*
        // before
        NSLog(@"calloutView frame: %f, %f, %f, %f and calloutView bounds: %f, %f, %f, %f", callOutView.frame.origin.x, callOutView.frame.origin.y, callOutView.frame.size.width, callOutView.frame.size.height, callOutView.bounds.origin.x, callOutView.bounds.origin.y, callOutView.bounds.size.width, callOutView.bounds.size.height);
        NSLog(@"self.frame: %f, %f, %f, %f and self.bounds: %f, %f, %f, %f \n", self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height, self.bounds.origin.x, self.bounds.origin.y , self.bounds.size.width, self.bounds.size.height);
        
        
        // after
        NSLog(@"calloutView frame: %f, %f, %f, %f and calloutView bounds: %f, %f, %f, %f", callOutView.frame.origin.x, callOutView.frame.origin.y, callOutView.frame.size.width, callOutView.frame.size.height, callOutView.bounds.origin.x, callOutView.bounds.origin.y, callOutView.bounds.size.width, callOutView.bounds.size.height);
        NSLog(@"self.frame: %f, %f, %f, %f and self.bounds: %f, %f, %f, %f \n", self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height, self.bounds.origin.x, self.bounds.origin.y , self.bounds.size.width, self.bounds.size.height);
        */
    } else {
        [self removeCalloutView];
    }
    
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

-(void)calloutWasTapped
{
    NSLog(@"calloutView: in annotationView class called");

    [self.delegate calloutTappedForView:self];
}

-(void)removeCalloutView
{
    for (id view in self.subviews){
        if ([view isKindOfClass:BGCCalloutView.class]){
            [view removeFromSuperview];
        }
    }
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
