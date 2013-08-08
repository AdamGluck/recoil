//
//  BGCCasualty.h
//  recoil
//
//  Created by Andrew Beinstein on 8/5/13.
//  Copyright (c) 2013 BGC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "BGCAppDelegate.h"


@interface BGCCasualty : NSObject

// Main properties
@property (strong, nonatomic) NSString *victimName;
@property (nonatomic) int victimAge;
@property (nonatomic) BGCGender victimGender;
@property (nonatomic) BGCCasualityType casualtyType;
@property (strong, nonatomic) NSURL *newsArticle;

// Mapping properties
@property (strong, nonatomic) NSString *address;
@property CLLocationCoordinate2D coordinate;

// Parse property
@property (strong, nonatomic) PFObject *object;
@property (strong, nonatomic) PFGeoPoint *geopoint;

// Init methods
//- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;
- (id)initWithPFObject:(PFObject *)object;



@end
