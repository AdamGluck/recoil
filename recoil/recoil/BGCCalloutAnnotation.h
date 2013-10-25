//
//  BGCCalloutAnnotation.h
//  recoil
//
//  Created by Adam Gluck on 10/21/13.
//  Copyright (c) 2013 BGC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "BGCCasualty.h"

@interface BGCCalloutAnnotation : NSObject <MKAnnotation>

@property (strong, nonatomic) BGCCasualty *casualty;
- (id)initWithCasualty:(BGCCasualty *)casualty;

@end
