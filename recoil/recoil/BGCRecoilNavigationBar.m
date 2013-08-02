//
//  BGCRecoilNavigationBar.m
//  recoil
//
//  Created by Adam Gluck on 8/1/13.
//  Copyright (c) 2013 BGC. All rights reserved.
//

#import "BGCRecoilNavigationBar.h"

@interface BGCRecoilNavigationBar()

@property (strong, nonatomic) UINavigationItem * navigationItem;

@end

@implementation BGCRecoilNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColor(context, CGColorGetComponents([UIColor clearColor].CGColor));
    CGContextFillRect(context, rect);
}

-(void) layoutSubviews
{
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern.png"]];
    [self configureLeftBarButtonItem];
    [self configureRightBarButtonItem];
}

-(void) configureLeftBarButtonItem{
    UIImage * image = [UIImage imageNamed:@"menu_icon.png"];
    UIButton * leftButton = [[UIButton alloc] initWithFrame:CGRectMake(17.5, 0, image.size.width, image.size.height)];
    leftButton.center = CGPointMake(leftButton.center.x, self.center.y);
    [leftButton setBackgroundImage:image forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(menuPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftButton];
}

-(void)menuPressed
{
    NSLog(@"left item pressed");
}

-(void) configureRightBarButtonItem{
    UIImage * image = [UIImage imageNamed:@"notification.png"];
    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - image.size.width - 17.5, 0, image.size.width, image.size.height)];
    [rightButton setBackgroundImage:image forState:UIControlStateNormal];
    rightButton.center = CGPointMake(rightButton.center.x, self.center.y);
    [rightButton addTarget:self action:@selector(notificationPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightButton];
}

-(void)notificationPressed
{
    NSLog(@"notification pressed");
}

-(UINavigationItem *) navigationItem
{
    if (!_navigationItem){
        for (id view in self.subviews){
            if ([view class] == [UINavigationItem class])
                _navigationItem = (UINavigationItem *) view;
        }
    }
    
    return _navigationItem;
}



@end
