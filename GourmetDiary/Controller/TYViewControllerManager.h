//
//  TYViewControllerManager.h
//  GourmetDiary
//
//  Created by Tomohiko on 2014/11/09.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYTopViewController.h"
#import "TYSearchViewController.h"

@interface TYViewControllerManager : NSObject

@property (nonatomic, weak) UIViewController *parentViewController;
@property (nonatomic, weak) UIViewController *childViewController;

//ビューコントローラ-切替
- (void)switchingTopViewController:(UIViewController *)parentViewController;
//- (void)switchingSearchViewController:(UIViewController *)parentViewController;
+ (TYTopViewController *)topViewController;
+ (TYSearchViewController *)searchViewController;
- (void)viewChange:(UIViewController *)childViewController;

@end
