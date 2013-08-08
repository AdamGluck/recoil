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
        UIImageView * backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"org_list_bar"]];
        self.backgroundColor = [UIColor clearColor];
        [self setBackgroundView:backgroundImage];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
