//
//  ViewController.m
//  menuBar
//
//  Created by Ozzy   on 3/2/17.
//  Copyright © 2017 WallTree. All rights reserved.
//

#import "ViewController.h"
#import "MenuBarView.h"


#define RGB_TO_UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]


@interface ViewController () <MenuBarViewDataSource, MenuBarViewDelete>

@property (weak, nonatomic) IBOutlet MenuBarView *menuView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.menuView.dataSource = self;
    [self.menuView updateInterface];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - MenuBarViewDataSource
- (NSInteger)numberOfMenuItems
{
    return 5;
}

- (NSString *)titleForItemByIndex:(NSInteger)index
{
    NSString *result = @"";
    switch (index) {
        case 0:
            result = @"Add Effect";
            break;
            
        case 1:
            result = @"Add Image";
            break;
            
        case 2:
            result = @"Add Text";
            break;
            
        case 3:
            result = @"Add Music";
            break;
            
        case 4:
            result = @"Cut Video";
            break;
    }
    return result;
}

- (UIColor *)titleColorForItemByIndex:(NSInteger)index
{
    return RGB_TO_UIColor(114, 66, 85);
}

- (UIImage *)iconForItemByIndex:(NSInteger)index
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"%ld", index]];
}


@end
