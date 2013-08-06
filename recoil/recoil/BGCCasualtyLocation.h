//
//  BGCCasualtyLocation.h
//  recoil
//
//  Created by Andrew Beinstein on 8/5/13.
//  Copyright (c) 2013 BGC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "BGCCasualty.h"

@interface BGCCasualtyLocation : NSObject <MKAnnotation>

@property (strong, nonatomic) BGCCasualty *casualty;
//@property (strong, nonatomic) NSString *title;
//@property (nonatomic) CLLocationCoordinate2D coordinate;


- (id)initWithCasualty:(BGCCasualty *)casualty;


@end
