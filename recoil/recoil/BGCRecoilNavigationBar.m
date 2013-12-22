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
@property (strong, nonatomic) UILabel * titleLabel;
@property (strong, nonatomic) UIButton * rightButton;
@property (strong, nonatomic) UIButton * leftButton;
@property (strong, nonatomic) UIImageView * notificationCountImage;

@end

@implementation BGCRecoilNavigationBar

@synthesize title = _title;

#pragma mark - Lifecycle methods

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
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
    [self configure];
}

#pragma mark - Custom Configuration

-(void) configure
{
    self.backgroundColor = [UIColor colorWithRed:26.0/255.0 green:23.0/255.0 blue:24.0/255.0 alpha:1.0f];
    [self configureLeftBarButtonItem];
    [self configureRightBarButtonItem];
    self.navigationItem.hidesBackButton = YES;
}

-(void) configureLeftBarButtonItem
{
    UIImage * image = [UIImage imageNamed:@"menu_btn.png"];
    UIButton * leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        leftButton.center = CGPointMake(leftButton.center.x, self.center.y);
    } else {
        leftButton.center = CGPointMake(leftButton.center.x, self.frame.origin.y + 2.5);
    }
    [leftButton setBackgroundImage:image forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(menuPressed) forControlEvents:UIControlEventTouchUpInside];
    self.leftButton = leftButton;
    [self addSubview:leftButton];
}

-(void) configureRightBarButtonItem
{
    NSLog(@"configure Right button");
    UIImage * image = [UIImage imageNamed:@"notification.png"];
    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - image.size.width - 15.0, 0, image.size.width, image.size.height)];
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        rightButton.center = CGPointMake(rightButton.center.x, self.center.y);
    } else {
        rightButton.center = CGPointMake(rightButton.center.x, self.frame.origin.y + 2.5);
    }
    [rightButton setBackgroundImage:image forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(notificationPressed) forControlEvents:UIControlEventTouchUpInside];
    if (!_rightButton){
        self.rightButton = rightButton;
        [self addSubview:rightButton];
    }
}

-(void) configureAlertCountAt: (NSInteger) count
{
    if (count){
        UIImage * alertCircle = [UIImage imageNamed:@"notifications_icon"];
        self.notificationCountImage = [[UIImageView alloc] initWithFrame:CGRectMake(292, self.rightButton.frame.origin.y - 13, 28, 28)];
        self.notificationCountImage.image = alertCircle;
        [self insertSubview:self.notificationCountImage atIndex:5];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
        label.text = [NSString stringWithFormat:@"%i", count];
        label.font = [UIFont fontWithName:@"OpenSans-Bold" size:7.0f];
        label.textColor = [UIColor whiteColor];
        [label sizeToFit];
        label.center = self.notificationCountImage.center;
        [self insertSubview:label aboveSubview:self.notificationCountImage];
    }
}

#pragma mark - setters and getters

-(void) setTitle:(NSString *)title
{
    _title = [title copy];
    if (_navigationItem){
        [self popNavigationItemAnimated:YES];
    }
    self.navigationItem = [[UINavigationItem alloc] initWithTitle:title];
    [self pushNavigationItem:self.navigationItem animated:NO];
}

-(NSString *) title
{
    if (!_title){
        _title = [[NSString alloc] init];
    }
    return _title;
}

-(UIButton *)rightButton
{
    if (!_rightButton){
        _rightButton = [[UIButton alloc] init];
    }
    return _rightButton;
}

-(UIButton *)leftButton
{
    if (!_leftButton){
        _leftButton = [[UIButton alloc] init];
    }
    return _leftButton;
}

#pragma mark - selectors

-(void)menuPressed
{
    [self callDelegateForOptionalSelector:@selector(menuPressed)];
}

-(void)notificationPressed
{
    [self callDelegateForOptionalSelector:@selector(notificationPressed)];
}

#pragma mark - delegate utilities

-(void)callDelegateForOptionalSelector:(SEL) selector
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    // delegate methods do not return allocated objects, so mem management will be fine
    if ([self.delegate respondsToSelector:selector]) [self.delegate performSelector:selector];
#pragma clang diagnostic pop
}




@end
