//
//  MenuBarView.h
//  menuBar
//
//  Created by Ozzy   on 3/2/17.
//  Copyright © 2017 WallTree. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuBarViewDataSource <NSObject>

@required
- (NSInteger)numberOfMenuItems;
- (NSString *)titleForItemByIndex:(NSInteger)index;
- (UIColor *)titleColorForItemByIndex:(NSInteger)index;
- (UIImage *)iconForItemByIndex:(NSInteger)index;

@end

@protocol MenuBarViewDelete <NSObject>

@optional
- (void)touchesMenuItemAtIndex:(NSInteger)index;

@end

@interface MenuBarView : UIView

@property (strong, nonatomic) id<MenuBarViewDataSource> dataSource;
@property (strong, nonatomic) id<MenuBarViewDelete> delega;

- (void)updateInterface;

@end
