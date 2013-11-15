//
//  BGCRecoilNavigationBar.h
//  recoil
//
//  Created by Adam Gluck on 8/1/13.
//  Copyright (c) 2013 BGC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RecoilNavigationBarDelegate <NSObject>

@optional
-(void) menuPressed;
-(void) notificationPressed;

@end

@interface BGCRecoilNavigationBar : UINavigationBar

@property (weak, nonatomic) id <RecoilNavigationBarDelegate> delegate;
@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) UINavigationItem * navItem;
-(void) configureAlertCountAt: (NSInteger) count;

@end
