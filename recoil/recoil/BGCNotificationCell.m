//
//  BGCNotificationCell.m
//  recoil
//
//  Created by Adam Gluck on 8/8/13.
//  Copyright (c) 2013 BGC. All rights reserved.
//

#import "BGCNotificationCell.h"

@implementation BGCNotificationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

-(void) prepareForReuse
{
    
}

-(void) basicConfiguration
{
    UIImageView * backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"org_list_bar"]];
    self.backgroundColor = [UIColor clearColor];
    [self setBackgroundView:backgroundImage];
    self.timeStampView.font = [UIFont fontWithName:@"OpenSans-Regular.ttf" size:12.0f];
    self.notificationDescriptionView.font = [UIFont fontWithName:@"OpenSans-Regular.ttf" size:12.0f];
}

-(void) prepareWithNotificationDescription: (NSString *) notificationDescription
                                 timeStamp: (NSString *) timeStamp
                          notificationType: (NotificationCellInfoType) notificationType
                              andColorType: (NotificationCellColorType) colorType
{
    [self basicConfiguration];
    self.timeStampView.text = timeStamp;
    UIImage * cellImage;
    
    NSMutableAttributedString * fullNotificationDescription;
    NSMutableAttributedString * attNotificationDescription = [[NSMutableAttributedString alloc] initWithString:notificationDescription];
    [attNotificationDescription addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, notificationDescription.length)];
    
    switch (notificationType) {
        case NotificationTypeCrimeOccured:
            if (colorType == ColorTypeGray)
                cellImage = [UIImage imageNamed:@"ribbon_deactive"];
            else
                cellImage = [UIImage imageNamed:@"ribbon_active"];
            
            fullNotificationDescription = [NSString stringWithFormat:@"%@, has died due to gun violence.", attNotificationDescription];
            break;
        case NotificationTypeNewOrganization:
            if (colorType == ColorTypeGray)
                cellImage = [UIImage imageNamed:@"hand_deactive"];
            else
                cellImage = [UIImage imageNamed:@"hand_active"];
            
            //fullNotificationDescription = [NSMutableAttributedString ]
            
            //[NSString stringWithFormat:@"A new organization, %@, has been added to recoil.", attNotificationDescription];
            break;
        default:
            break;
    }
    self.notificationDescriptionView.attributedText = attNotificationDescription;
    self.notificationImageView.image = cellImage;
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
