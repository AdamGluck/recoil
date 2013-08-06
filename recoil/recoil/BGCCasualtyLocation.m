//
//  BGCCasualtyLocation.m
//  recoil
//
//  Created by Andrew Beinstein on 8/5/13.
//  Copyright (c) 2013 BGC. All rights reserved.
//

#import "BGCCasualtyLocation.h"

@implementation BGCCasualtyLocation

#pragma mark - Init methods
- (id)initWithCasualty:(BGCCasualty *)casualty
{
    self = [super init];
    if (self) {
        self.casualty = casualty;
    }
    return self;
}

#pragma mark - MKAnnotation Protocol

- (CLLocationCoordinate2D)coordinate
{
    return self.casualty.coordinate;
}

- (NSString *)title
{
    NSLog(@"Returning annotation title: %@", self.casualty.victimName);
    return self.casualty.victimName;
}

#pragma mark - Lazy instantiation
- (BGCCasualty *)casualty
{
    if (!_casualty) _casualty = [[BGCCasualty alloc] init];
    return _casualty;
}


@end
