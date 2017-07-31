//
//  AppDelegate.m
//  HappyLife
//
//  Created by dq on 16/3/25.
//  Copyright © 2016年 dq. All rights reserved.
//

#import "AppDelegate.h"
#import <RESideMenu/RESideMenu.h>
#import "DQChosenLeftMenuTableViewController.h"
#import "DQChosenTableViewController.h"
#import "DQPicturesViewController.h"
#import "DQJokesTableViewController.h"
#import "DQNavi.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self configGlobalUI];
    
    DQChosenTableViewController *chosenVC = [[DQChosenTableViewController alloc]init];
    DQChosenLeftMenuTableViewController *chosenLeftVC = [[DQChosenLeftMenuTableViewController alloc]init];
    RESideMenu *chosenMenuVC = [[RESideMenu alloc]initWithContentViewController:chosenVC leftMenuViewController:chosenLeftVC rightMenuViewController:nil];
    chosenMenuVC.tabBarItem.image = [UIImage imageNamed:@"JX"];
    [self configSideMenu:chosenMenuVC];
    
    UINavigationController *picVC = [DQNavi standardTuWanNavi];
    picVC.tabBarItem.image = [UIImage imageNamed:@"MT"];
    
    DQJokesTableViewController *jokesTVC = [[DQJokesTableViewController alloc]init];
    jokesTVC.tabBarItem.image = [UIImage imageNamed:@"DZ"];
//    jokesTVC.tabBarItem.sel
    
    UITabBarController *tbC = [[UITabBarController alloc]init];
    [tbC addChildViewController:[[UINavigationController alloc]initWithRootViewController:chosenMenuVC]];
    [tbC addChildViewController: picVC];
    [tbC addChildViewController:[[UINavigationController alloc]initWithRootViewController:jokesTVC]];
    
    self.window = [[UIWindow alloc]init];
    self.window.rootViewController = tbC;
    [self.window makeKeyAndVisible];
    
    return YES;
}

//配置sideMenu
- (void)configSideMenu:(RESideMenu *)sideMenuVC {
    sideMenuVC.contentViewScaleValue = 0.8f;
    sideMenuVC.contentViewInPortraitOffsetCenterX = -20;
    sideMenuVC.backgroundImage = [UIImage imageNamed:@"bgImage_640x1136"];
    sideMenuVC.panGestureEnabled = YES;
    sideMenuVC.contentViewShadowColor = [UIColor colorWithRed:126/255.0 green:126/255.0 blue:126/255.0 alpha:1];
    sideMenuVC.contentViewShadowEnabled = YES;
    sideMenuVC.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
}

//对UI进行统一配置
-(void)configGlobalUI {
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:23/255.0 green:158/255.0 blue:117/255.0 alpha:1]];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"barSelectedImage"]];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:132/255.0 green:175/255.0 blue:109/255.0 alpha:1]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSFontAttributeName : [UIFont systemFontOfSize:20],
                                                           NSForegroundColorAttributeName : [UIColor whiteColor]
                                                           }];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
