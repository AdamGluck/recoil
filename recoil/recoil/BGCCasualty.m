//
//  BGCCasualty.m
//  recoil
//
//  Created by Andrew Beinstein on 8/5/13.
//  Copyright (c) 2013 BGC. All rights reserved.
//

#import "BGCCasualty.h"

@interface BGCCasualty()

@end

@implementation BGCCasualty

#pragma mark - Init methods
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    if (self) {
        self.coordinate = coordinate;
    }
    return self;
}

- (id)initWithPFObject:(PFObject *)object {
    self.object = object;
    self.geopoint = [object objectForKey:kBGCParseLocationKey];
    [object fetchIfNeeded];
    
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.geopoint.latitude, self.geopoint.longitude);
    return [self initWithCoordinate:coordinate];
}

#pragma mark - Lazy instantiation

-(NSString *)victimName
{
    if (!_victimName) _victimName = [[NSString alloc] init];
    return _victimName;
}

-(NSString *)address
{
    if (!_address) _address = [[NSString alloc] init];
    return _address;
}

-(NSURL *)newsArticle
{
    if (!_newsArticle) _newsArticle = [[NSURL alloc] init];
    return _newsArticle;
}

@end
