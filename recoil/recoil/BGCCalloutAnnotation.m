//
//  BGCCalloutAnnotation.m
//  recoil
//
//  Created by Adam Gluck on 10/21/13.
//  Copyright (c) 2013 BGC. All rights reserved.
//

#import "BGCCalloutAnnotation.h"

@implementation BGCCalloutAnnotation
#pragma mark - Init methods
- (id)initWithCasualty:(BGCCasualty *)casualty
{
    self = [super init];
    if (self) {
        self.casualty = casualty;
    }
    return self;
}

#pragma mark - protocol
- (CLLocationCoordinate2D)coordinate
{
    return self.casualty.coordinate;
}

#pragma mark - Lazy instantiation
- (BGCCasualty *)casualty
{
    if (!_casualty) _casualty = [[BGCCasualty alloc] init];
    return _casualty;
}

@end
