//
//  MenuItem.m
//  menuBar
//
//  Created by Ozzy   on 3/2/17.
//  Copyright © 2017 WallTree. All rights reserved.
//

#import "MenuItem.h"

@interface MenuItem ()

@property (weak) IBOutlet UILabel *titleLabel;
@property (weak) IBOutlet UIImageView *iconImageView;


@end

@implementation MenuItem
#pragma mark - Life Cycle
- (id)init {
    self = [super init];
    if (self) {
        [self initializeSubviews];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //[self initializeSubviews];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeSubviews];
    }
    return self;
}

-(void)initializeSubviews {
    UIView* view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                  owner:self
                                                options:nil] objectAtIndex:0];
    view.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.titleLabel = [view viewWithTag:111];
    self.iconImageView = [view viewWithTag:222];
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0 constant:0];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0f constant:0];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                       attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0 constant:0];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeTop
                                                                       multiplier:1.0f constant:0];
    
    [self addConstraints:@[leftConstraint, topConstraint, rightConstraint, bottomConstraint]];
    
    [self addSubview:view];
}


#pragma mark - Public fuction
- (void)setupItemWithTitle:(NSString *)title titleColor:(UIColor *)color icon:(UIImage *)icon
{
    self.titleLabel.textColor = color;
    self.titleLabel.text = title;
    self.iconImageView.image = icon;
}


- (void)changeTitleFontSize:(float)fontSize
{
    self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
}


@end
