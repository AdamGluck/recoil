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
}

-(void) configureLeftBarButtonItem{
    UIImage * image = [UIImage imageNamed:@"menu_icon.png"];
    UIButton * leftButton = [[UIButton alloc] initWithFrame:CGRectMake(17.5, 0, image.size.width, image.size.height)];
    leftButton.center = CGPointMake(leftButton.center.x, self.center.y);
    [leftButton setBackgroundImage:image forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(menuPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftButton];
}

-(void) configureRightBarButtonItem{
    UIImage * image = [UIImage imageNamed:@"notification.png"];
    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - image.size.width - 17.5, 0, image.size.width, image.size.height)];
    [rightButton setBackgroundImage:image forState:UIControlStateNormal];
    rightButton.center = CGPointMake(rightButton.center.x, self.center.y);
    [rightButton addTarget:self action:@selector(notificationPressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightButton];
}

-(void) setTitle:(NSString *)title
{
    _title = [title copy];
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
