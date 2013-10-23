//
//  BGCAnnotationView.h
//  recoil
//
//  Created by Adam Gluck on 9/12/13.
//  Copyright (c) 2013 BGC. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "BGCAnnotationView.h"

@class BGCAnnotationView;
@protocol BGCAnnotationViewDelegate <NSObject>

-(void)calloutTappedForView: (BGCAnnotationView *) view;

@end

@interface BGCAnnotationView : MKAnnotationView

@property (assign, nonatomic) BOOL showingCallout;
-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;

@end
