//
//  BGCAppDelegate.h
//  recoil
//
//  Created by Andrew Beinstein on 7/23/13.
//  Copyright (c) 2013 BGC. All rights reserved.
//

// Various enums
typedef NS_ENUM(NSInteger, BGCGender) {
    MALE,
    FEMALE,
    UNKNOWN
};

typedef NS_ENUM(NSInteger, BGCCasualityType) {
    DEATH,
    INJURY,
    OTHER
};

// Parse API key constants:
static NSString * const kBGCParseClassName = @"Casualty";

static NSString * const kBGCParseAddressKey = @"address";
static NSString * const kBGCParseAgeKey = @"age";
static NSString * const kBGCParseLocationKey = @"location";
static NSString * const kBGCParseNameKey = @"name";
static NSString * const kBGCParseURLKey = @"storyUrl";

#import <UIKit/UIKit.h>

@interface BGCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
