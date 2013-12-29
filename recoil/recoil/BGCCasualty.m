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
//- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
//{
//    self = [super init];
//    if (self) {
//        self.coordinate = coordinate;
//    }
//    return self;
//}

- (id)initWithPFObject:(PFObject *)object {
    self = [super init];
    
    if (self) {
        self.object = object;
        self.geopoint = [object objectForKey:kBGCParseLocationKey];
        [object fetchIfNeeded];
        
        // These will be nil if they don't exist -- and that's ok!
        self.coordinate = CLLocationCoordinate2DMake(self.geopoint.latitude, self.geopoint.longitude);
        self.victimAge = [[object objectForKey:kBGCParseAgeKey] intValue];
        self.victimName = [object objectForKey:kBGCParseNameKey];
        self.address = [object objectForKey:kBGCParseAddressKey];
        self.dateOccured = [object objectForKey:kBGCParseDateKey];
        self.locationType = [object objectForKey:kBGCLocationType];
        self.cause = [object objectForKey:kBGCCause];
        self.neighborhood = [object objectForKey:kBGCNeighborhood];
        self.genderString = [object objectForKey:@"gender"];
        if ([self.genderString isEqualToString:@"Male"]){
            self.victimGender = MALE;
        } else if ([self.genderString isEqualToString:@"Female"]){
            self.victimGender = FEMALE;
        } else {
            self.victimGender = UNKNOWN;
        }
        self.newsArticle = [NSURL URLWithString:[object objectForKey:@"storyUrl"]];
        
        NSLog(@"Gender string: %@", self.genderString);
        if ([self.genderString isEqualToString:@"Male"]) {
            self.victimGender = MALE;
        } else if ([self.genderString isEqualToString:@"Female"]) {
            self.victimGender = FEMALE;
        } else {
            self.victimGender = UNKNOWN;
        }
    }
    return self;
}

#pragma mark - Lazy instantiation

-(NSString *)victimName
{
    if (!_victimName) _victimName = [[NSString alloc] init];
    return _victimName;
}

-(NSString *)genderString
{
    if (!_genderString) _genderString = [[NSString alloc] init];
    return _genderString;
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
