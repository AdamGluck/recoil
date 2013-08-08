//
//  BGCNotificationCell.h
//  recoil
//
//  Created by Adam Gluck on 8/8/13.
//  Copyright (c) 2013 BGC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NotificationCellColorType){
    ColorTypeColor,
    ColorTypeGray
};

typedef NS_ENUM(NSInteger, NotificationCellInfoType){
    NotificationTypeCrimeOccured,
    NotificationTypeNewOrganization
};

@interface BGCNotificationCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UITextView *notificationDescriptionView;
@property (strong, nonatomic) IBOutlet UITextView *timeStampView;
@property (strong, nonatomic) IBOutlet UIImageView *notificationImageView;
@property (assign) NotificationCellInfoType notificationType;
@property (assign) NotificationCellColorType colorType;

-(void) prepareWithNotificationDescription: (NSString *) notificationDescription
                                 timeStamp: (NSString *) timeStamp
                          notificationType: (NotificationCellInfoType) notificationType
                              andColorType: (NotificationCellColorType) colorType;

@end
