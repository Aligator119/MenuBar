
//
//  MenuBarView.m
//  menuBar
//
//  Created by Ozzy   on 3/2/17.
//  Copyright © 2017 WallTree. All rights reserved.
//

#import "MenuBarView.h"
#import "MenuItem.h"
#import <UIKit/UIKit.h>

#define RGB_TO_UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

#define kSpaceSize (self.frame.size.width * 0.05)

#define kBigItemWidth (self.frame.size.width * 0.188)
#define kBigItemHight (kBigItemWidth + (kBigItemWidth * 0.2))

#define kMidleItemWidth (self.frame.size.width * 0.142)
#define kMidleItemHight (kMidleItemWidth + (kMidleItemWidth * 0.2))

#define kSmallItemWidth (self.frame.size.width * 0.116)
#define kSmallItemHigth (kSmallItemWidth + (kSmallItemWidth * 0.2))

#define kTopItemX self.frame.size / 2
#define kTopItemY kBigItemHight / 2

#define kLeftMidleItemX ((2 * kSpaceSize) + kSmallItemWidth + (kMidleItemWidth / 2))
#define kRightMidleItemX self.frame.size.width - kLeftMidleItemX
#define kMidleItemY (self.frame.size.height / 2)

#define kLeftSmallItemX (kSpaceSize + (kSmallItemWidth / 2))
#define kRightSmallItemX self.frame.size.width - kLeftSmallItemX
#define kSmallItemY (self.frame.size.height - ((kSmallItemHigth / 2) + kSpaceSize))




struct MBItemPath {
    CGFloat level;
    CGFloat index;
};
typedef struct MBItemPath MBItemPath;

static MBItemPath MBItemPathMake(int level, int index) {
    MBItemPath path;
    path.level = level;
    path.index = index;
    return path;
}

@interface MenuBarView ()

@property (strong, nonatomic) NSMutableArray *itemsList;

@property (nonatomic) NSInteger selectedItemIndex;

@end

@implementation MenuBarView


-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initializeSubviews];
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
    //    UIView* view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
    //                                                         owner:self
    //                                                       options:nil] objectAtIndex:0];
    //    view.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    //    [self addSubview:view];
    
    self.selectedItemIndex = 2;
    self.itemsList = [NSMutableArray new];
    [self updateInterface];
}


#pragma mark - Actions
- (void)updateInterface
{
    NSInteger count = [self.dataSource numberOfMenuItems];
    count = count < 5 ? 5 : count;
    for (int i = 0; i < count; i++) {
        MenuItem *item = [[MenuItem alloc] init];
        item.tag = i;
        [item setupItemWithTitle:[self.dataSource titleForItemByIndex:i]
                      titleColor:[self.dataSource titleColorForItemByIndex:i]
                            icon:[self.dataSource iconForItemByIndex:i]];
        UITapGestureRecognizer *tapGestore = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressedMenuItem:)];
        [item addGestureRecognizer:tapGestore];
        [self setupFrameForItem:item atIndex:i];
        [self.itemsList addObject:item];
        [self addSubview:item];
    }
}


- (void)setupFrameForItem:(MenuItem *)item atIndex:(NSInteger)index
{
    CGRect resultRect = CGRectMake(0, 0, 0, 0);
    CGPoint centerPoint = CGPointMake(0, 0);
    switch (index - self.selectedItemIndex) {
        case -2:
            resultRect = CGRectMake(0, 0, kSmallItemWidth, kSmallItemHigth);
            centerPoint = CGPointMake(kLeftSmallItemX, kSmallItemY);
            break;
            
        case -1:
            resultRect = CGRectMake(0, 0, kMidleItemWidth, kMidleItemHight);
            centerPoint = CGPointMake(kLeftMidleItemX, kMidleItemY);
            break;
            
        case 0:
            resultRect = CGRectMake(0, 0, kBigItemWidth, kBigItemHight);
            centerPoint = CGPointMake(self.frame.size.width / 2, kBigItemHight / 2);
            break;
            
        case 1:
            resultRect = CGRectMake(0, 0, kMidleItemWidth, kMidleItemHight);
            centerPoint = CGPointMake(kRightMidleItemX, kMidleItemY);
            break;
            
        case 2:
            resultRect = CGRectMake(0, 0, kSmallItemWidth, kSmallItemHigth);
            centerPoint = CGPointMake(kRightSmallItemX, kSmallItemY);
            break;
    }
    
    item.frame = resultRect;
    item.center = centerPoint;
}

- (void)pressedMenuItem:(UITapGestureRecognizer *)recognizer
{
    self.selectedItemIndex = [recognizer view].tag;
    NSLog(@"TAPPED ITEM - %ld", (long)self.selectedItemIndex);
}

@end
