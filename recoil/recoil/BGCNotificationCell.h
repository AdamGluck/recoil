//
//  BGCNotificationCell.h
//  recoil
//
//  Created by Adam Gluck on 8/8/13.
//  Copyright (c) 2013 BGC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NotificationCellColorType){
    ColorTypeGray,
    ColorTypeColor
};

typedef NS_ENUM(NSInteger, NotificationCellInfoType){
    InfoTypeNewOrganization,
    InfoTypeCrimeOccured
};

@interface BGCNotificationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *notificationDescription;
@property (weak, nonatomic) IBOutlet UITextView *timeStamp;
@property (weak, nonatomic) IBOutlet UIImageView *notificationImage;
@property (assign) NotificationCellInfoType notificationType;
@property (assign) NotificationCellColorType colorType;

@end
