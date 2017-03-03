
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
#import "MenuItemCoordinates.h"

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



static float const kAnimationInterval = 0.5;


typedef enum {
    NewItemTypeLeft,
    NewItemTypeRight
} NewItemType;



@interface MenuBarView ()

@property (strong, nonatomic) NSMutableArray *visibleItems;
@property (strong, nonatomic) NSMutableArray *itemsSizeList;

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
    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeAction:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:leftSwipe];
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeAction:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:rightSwipe];
    
    self.selectedItemIndex = 2;
    self.visibleItems = [NSMutableArray new];
    self.itemsSizeList = [NSMutableArray new];
    
    //calculating points and size of items
    for (int i = 0; i < 5; i++) {
        MenuItemCoordinates *coordinate = [MenuItemCoordinates new];
        switch (i - self.selectedItemIndex) {
            case -2:
                coordinate.bounds = CGRectMake(0, 0, kSmallItemWidth, kSmallItemHigth);
                coordinate.center = CGPointMake(kLeftSmallItemX, kSmallItemY);
                coordinate.fontSize = 8.0;
                break;
                
            case -1:
                coordinate.bounds = CGRectMake(0, 0, kMidleItemWidth, kMidleItemHight);
                coordinate.center = CGPointMake(kLeftMidleItemX, kMidleItemY);
                coordinate.fontSize = 9.0;
                break;
                
            case 0:
                coordinate.bounds = CGRectMake(0, 0, kBigItemWidth, kBigItemHight);
                coordinate.center = CGPointMake(self.frame.size.width / 2, kBigItemHight / 2);
                coordinate.fontSize = 11.0;
                break;
                
            case 1:
                coordinate.bounds = CGRectMake(0, 0, kMidleItemWidth, kMidleItemHight);
                coordinate.center = CGPointMake(kRightMidleItemX, kMidleItemY);
                coordinate.fontSize = 9.0;
                break;
                
            case 2:
                coordinate.bounds = CGRectMake(0, 0, kSmallItemWidth, kSmallItemHigth);
                coordinate.center = CGPointMake(kRightSmallItemX, kSmallItemY);
                coordinate.fontSize = 8.0;
                break;
        }
        [self.itemsSizeList addObject:coordinate];
    }
    
    
    [self updateInterface];
}


#pragma mark - Actions
- (void)updateInterface
{
    NSInteger count = [self.dataSource numberOfMenuItems];
    count = count < 5 ? 5 : count;
    for (int i = (int)self.selectedItemIndex - 2; i < count; i++) {
        MenuItem *item = [[MenuItem alloc] init];
        item.tag = i;
        [item setupItemWithTitle:[self.dataSource titleForItemByIndex:i]
                      titleColor:[self.dataSource titleColorForItemByIndex:i]
                            icon:[self.dataSource iconForItemByIndex:i]];
        UITapGestureRecognizer *tapGestore = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressedMenuItem:)];
        [item addGestureRecognizer:tapGestore];
        
        MenuItemCoordinates *coordinate = self.itemsSizeList[i];
        item.frame = coordinate.bounds;
        item.center = coordinate.center;
        [item changeTitleFontSize:coordinate.fontSize];
        
        [self.visibleItems addObject:item];
        [self addSubview:item];
    }
}

- (void)pressedMenuItem:(UITapGestureRecognizer *)recognizer
{
    self.selectedItemIndex = [recognizer view].tag;
    NSLog(@"TAPPED ITEM - %ld", (long)self.selectedItemIndex);
}

- (void)leftSwipeAction:(UISwipeGestureRecognizer *)recognizer
{
    self.selectedItemIndex ++;
    [self shiftAnimationLeftOnPosition:1];
}

- (void)rightSwipeAction:(UISwipeGestureRecognizer *)recognizer
{
    self.selectedItemIndex --;
    [self shiftAnimationRightOnPosition:0];
}

#pragma mark - Animations
- (void)shiftAnimationLeftOnPosition:(NSInteger)count
{
    MenuItem *removeItem = self.visibleItems[0];
    [UIView animateWithDuration:kAnimationInterval animations:^{
        removeItem.frame = CGRectMake(- 30, self.frame.size.height + 30, removeItem.frame.size.width, removeItem.frame.size.height);
        
        MenuItem *item1 = self.visibleItems[1];
        MenuItemCoordinates *coordinate0 = self.itemsSizeList[0];
        item1.frame = coordinate0.bounds;
        item1.center = coordinate0.center;
        [item1 changeTitleFontSize:coordinate0.fontSize];
        
        MenuItem *item2 = self.visibleItems[2];
        MenuItemCoordinates *coordinate1 = self.itemsSizeList[1];
        item2.frame = coordinate1.bounds;
        item2.center = coordinate1.center;
        [item2 changeTitleFontSize:coordinate1.fontSize];
        
        MenuItem *item3 = self.visibleItems[3];
        MenuItemCoordinates *coordinate2 = self.itemsSizeList[2];
        item3.frame = coordinate2.bounds;
        item3.center = coordinate2.center;
        [item3 changeTitleFontSize:coordinate2.fontSize];
        
        MenuItem *item4 = self.visibleItems[4];
        MenuItemCoordinates *coordinate3 = self.itemsSizeList[3];
        item4.frame = coordinate3.bounds;
        item4.center = coordinate3.center;
        [item4 changeTitleFontSize:coordinate3.fontSize];
        
        MenuItem *item5 = [self newItemBy:NewItemTypeRight];
        MenuItemCoordinates *coordinate4 = self.itemsSizeList[4];
        item5.frame = coordinate4.bounds;
        item5.center = coordinate4.center;
        [item5 changeTitleFontSize:coordinate4.fontSize];
        [self.visibleItems addObject:item5];
        [self setNeedsLayout];
        
    } completion:^(BOOL finished) {
        [removeItem removeFromSuperview];
        [self.visibleItems removeObjectAtIndex:0];
    }];
}

- (void)shiftAnimationRightOnPosition:(NSInteger)count
{
    MenuItem *removeItem = self.visibleItems.lastObject;

    [UIView animateWithDuration:kAnimationInterval animations:^{
        removeItem.frame = CGRectMake(self.frame.size.width + 30, self.frame.size.height + 30, removeItem.frame.size.width, removeItem.frame.size.height);
        
        MenuItem *item0 = self.visibleItems[0];
        MenuItemCoordinates *coordinate1 = self.itemsSizeList[1];
        item0.frame = coordinate1.bounds;
        item0.center = coordinate1.center;
        [item0 changeTitleFontSize:coordinate1.fontSize];
        
        MenuItem *item1 = self.visibleItems[1];
        MenuItemCoordinates *coordinate2 = self.itemsSizeList[2];
        item1.frame = coordinate2.bounds;
        item1.center = coordinate2.center;
        [item1 changeTitleFontSize:coordinate2.fontSize];
        
        MenuItem *item2 = self.visibleItems[2];
        MenuItemCoordinates *coordinate3 = self.itemsSizeList[3];
        item2.frame = coordinate3.bounds;
        item2.center = coordinate3.center;
        [item2 changeTitleFontSize:coordinate3.fontSize];
        
        MenuItem *item3 = self.visibleItems[3];
        MenuItemCoordinates *coordinate4 = self.itemsSizeList[4];
        item3.frame = coordinate4.bounds;
        item3.center = coordinate4.center;
        [item3 changeTitleFontSize:coordinate4.fontSize];
        
        MenuItem *item5 = [self newItemBy:NewItemTypeRight];
        MenuItemCoordinates *coordinate0 = self.itemsSizeList[0];
        item5.frame = coordinate0.bounds;
        item5.center = coordinate0.center;
        [item5 changeTitleFontSize:coordinate0.fontSize];
        [self.visibleItems insertObject:item5 atIndex:0];
        
        [self setNeedsLayout];
        
    } completion:^(BOOL finished) {
        [removeItem removeFromSuperview];
        [self.visibleItems removeLastObject];
    }];
}

- (MenuItem *)newItemBy:(NewItemType)type
{
    MenuItem *item = [[MenuItem alloc] init];
    
    if (type == NewItemTypeLeft) {
        item.tag = self.selectedItemIndex + 2;
        [item setupItemWithTitle:[self.dataSource titleForItemByIndex:item.tag]
                      titleColor:[self.dataSource titleColorForItemByIndex:item.tag]
                            icon:[self.dataSource iconForItemByIndex:item.tag]];
        item.frame = CGRectMake(0, 0, item.frame.size.width, item.frame.size.height);
        item.center = CGPointMake(- 300, self.frame.size.height + 300);
    } else {
        item.tag = self.selectedItemIndex - 2;
        [item setupItemWithTitle:[self.dataSource titleForItemByIndex:item.tag]
                      titleColor:[self.dataSource titleColorForItemByIndex:item.tag]
                            icon:[self.dataSource iconForItemByIndex:item.tag]];
        item.frame = CGRectMake(0, 0, item.frame.size.width, item.frame.size.height);
        item.center = CGPointMake(self.frame.size.width + 30, self.frame.size.height + 30);
    }
    
    UITapGestureRecognizer *tapGestore = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressedMenuItem:)];
    [item addGestureRecognizer:tapGestore];
    
    [self addSubview:item];
    
    return item;
}









@end
