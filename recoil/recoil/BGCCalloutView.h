//
//  BGCCalloutView.h
//  recoil
//
//  Created by Adam Gluck on 9/12/13.
//  Copyright (c) 2013 BGC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BGCCasualtyLocation.h"

@interface BGCCalloutView : MKAnnotationView

-(id)initWithCasualty:(BGCCasualty *)casualty andAnnotation:(id<MKAnnotation>)annotation;

@end
