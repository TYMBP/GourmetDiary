//
//  AppDelegate.m
//  GourmetDiary
//
//  Created by Tomohiko on 2014/11/09.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import "TYAppDelegate.h"
#import "TYViewController.h"

@implementation TYAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  LOG_METHOD
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
  
  _application = [[TYApplication alloc] init];
  TYViewController *viewController = [[TYViewController alloc] init];
  
//  UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:viewController];
//  self.window.rootViewController = navigation;
  
  self.window.rootViewController = viewController;
  [self.window makeKeyAndVisible];
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
