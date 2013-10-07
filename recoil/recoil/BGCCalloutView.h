//
//  BGCCalloutView.h
//  recoil
//
//  Created by Adam Gluck on 9/12/13.
//  Copyright (c) 2013 BGC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGCCasualtyLocation.h"

@protocol BGCCalloutViewDelegate <NSObject>

-(void)calloutWasTapped;

@end

@interface BGCCalloutView : UIButton

@property (weak, nonatomic) id <BGCCalloutViewDelegate> delegate;
-(id)initWithFrame:(CGRect)frame andCasualty:(BGCCasualty *)casualty;

@end
