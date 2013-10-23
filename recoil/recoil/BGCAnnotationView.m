//
//  BGCAnnotationView.m
//  recoil
//
//  Created by Adam Gluck on 9/12/13.
//  Copyright (c) 2013 BGC. All rights reserved.
//

#import "BGCAnnotationView.h"
#import "BGCCalloutView.h"
@interface BGCAnnotationView() <UIGestureRecognizerDelegate>

@end

@implementation BGCAnnotationView

#define CALLOUT_HEIGHT 62.000000
#define CALLOUT_WIDTH 219.000000
- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.image = [UIImage imageNamed:@"death_pin"];
    }
    return self;
}

@end
