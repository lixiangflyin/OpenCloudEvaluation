//
//  AppDelegate.h
//  evaTeac
//
//  Created by admin  on 13-10-29.
//  Copyright (c) 2013年 com.seuli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPRevealSideViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,PPRevealSideViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *homeNav;
@property (strong, nonatomic) UINavigationController *loginNav;

@property (strong, nonatomic) PPRevealSideViewController *revealSideViewController;
@end
