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


-(void) basicConfiguration
{
    UIImageView * backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"org_list_bar"]];
    self.backgroundColor = [UIColor clearColor];
    [self setBackgroundView:backgroundImage];
    self.timeStampView.font = [UIFont fontWithName:@"OpenSans" size:10.0f];
    self.notificationDescriptionView.font = [UIFont fontWithName:@"OpenSans" size:10.0f];
}

-(void) prepareWithNotificationDescription: (NSString *) notificationDescription
                                 timeStamp: (NSString *) timeStamp
                          notificationType: (NotificationCellInfoType) notificationType
                              andColorType: (NotificationCellColorType) colorType
{
    [self basicConfiguration];
    self.timeStampView.text = timeStamp;
    UIImage * cellImage;
    NSAttributedString * fullNotificationDescription;
    switch (notificationType) {
        case NotificationTypeCrimeOccured:
            if (colorType == ColorTypeGray)
                cellImage = [UIImage imageNamed:@"ribbon_deactive"];
            else
                cellImage = [UIImage imageNamed:@"ribbon_active"];
            
            fullNotificationDescription = [self stringForCrimeOccuredFromName:notificationDescription andColor:colorType];
            break;
        case NotificationTypeNewOrganization:
            if (colorType == ColorTypeGray)
                cellImage = [UIImage imageNamed:@"hand_deactive"];
            else
                cellImage = [UIImage imageNamed:@"hand_active"];
            
            fullNotificationDescription = [self stringForOrganizationAddedFromName:notificationDescription andColor:colorType];
            break;
        default:
            break;
    }
    self.notificationDescriptionView.attributedText = fullNotificationDescription;
    self.notificationImageView.image = cellImage;
    [self setNeedsDisplay];
}

-(NSAttributedString *) stringForCrimeOccuredFromName:(NSString *) name andColor: (NotificationCellColorType) color
{
    NSMutableAttributedString * attNotificationDescription;
    if (!name.length) name = @"Not yet identified";
    if (color == ColorTypeGray){
        NSString * notificationString = [NSString stringWithFormat:@"%@ has died due to gun violence.", name];
        attNotificationDescription = [[NSMutableAttributedString alloc] initWithString:notificationString];
        [attNotificationDescription addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, notificationString.length)];
        return attNotificationDescription;
    } else {
        attNotificationDescription = [[NSMutableAttributedString alloc] initWithString:name];
        [attNotificationDescription addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, name.length)];
        NSMutableAttributedString * fullDescription = [[NSMutableAttributedString alloc] initWithString:@" has died due to gun violence."];
        [fullDescription addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, fullDescription.length)];
        [fullDescription insertAttributedString:attNotificationDescription atIndex:0];
        return [fullDescription copy];
    }
}

-(NSAttributedString *) stringForOrganizationAddedFromName:(NSString *) name andColor: (NotificationCellColorType) color
{
    NSMutableAttributedString * attNotificationDescription;
    if (color == ColorTypeGray){
        NSString * notificationString = [NSString stringWithFormat:@"A new organization, %@, has been addded to Recoil.", name];
        attNotificationDescription = [[NSMutableAttributedString alloc] initWithString:notificationString];
        [attNotificationDescription addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, notificationString.length)];
        return [attNotificationDescription copy];
    } else {
        attNotificationDescription = [[NSMutableAttributedString alloc] initWithString:name];
        [attNotificationDescription addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, name.length)];
        NSMutableAttributedString * fullDescription = [[NSMutableAttributedString alloc] initWithString:@"A new organization, , has been added to Recoil."];
        [fullDescription addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, fullDescription.length)];
        [fullDescription insertAttributedString:attNotificationDescription atIndex:@"A new organization,".length + 1];
        return [fullDescription copy];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
