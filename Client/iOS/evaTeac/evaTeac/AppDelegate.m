//
//  AppDelegate.m
//  evaTeac
//
//  Created by admin  on 13-10-29.
//  Copyright (c) 2013年 com.seuli. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "CourseViewController.h"

@implementation AppDelegate
@synthesize homeNav, loginNav;
@synthesize revealSideViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    //设定ip
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:COMMON_API forKey:@"ipAddress"];
    //判断是否已登陆
    BOOL isLogined = [defaults boolForKey:@"isLogined"];
    if (isLogined == YES){
        CourseViewController *course = [[CourseViewController alloc]init];
        homeNav = [[UINavigationController alloc]initWithRootViewController:course];
        
        revealSideViewController = [[PPRevealSideViewController alloc] initWithRootViewController:homeNav];
        revealSideViewController.delegate = self;
        
        //表示可以手势滑动
        [self.revealSideViewController setDirectionsToShowBounce:PPRevealSideDirectionNone];
        self.window.rootViewController = revealSideViewController;
    }
    else{
        LoginViewController *login = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        loginNav = [[UINavigationController alloc]initWithRootViewController:login];
        self.window.rootViewController = loginNav;
//        // self.window.rootViewController = login;
    }
    
    //[[UIApplication sharedApplication]setStatusBarHidden:YES];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
