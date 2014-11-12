//
//  TYViewControllerManager.m
//  GourmetDiary
//
//  Created by Tomohiko on 2014/11/09.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import "TYViewControllerManager.h"

@interface TYViewControllerManager() {
}

@end

@implementation TYViewControllerManager

- (id)init
{
  self = [super init];
  if (self) {
  }
  return self;
}

// 修正前
//+ (TYTopViewController *)topViewController
//{
//  TYTopViewController *viewcnt = [[TYTopViewController alloc] initWithNibName:nil bundle:nil];
//  return viewcnt;
//}
//
//+ (TYSearchViewController *)searchViewController
//{
//  TYSearchViewController *viewcnt = [[TYSearchViewController alloc] initWithNibName:nil bundle:nil];
//  return viewcnt;
//}

+ (UINavigationController *)topViewController
{
  TYTopViewController *view = [[TYTopViewController alloc] init];
  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:view];
  return nav;
}

+ (UINavigationController *)searchViewController
{
  TYSearchViewController *view = [[TYSearchViewController alloc] init];
  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:view];
  return nav;
}

- (void)switchingTopViewController:(UIViewController *)parentViewController
{
  self.parentViewController = parentViewController;
  [self viewChange:[TYViewControllerManager topViewController]];
}

//- (void)switchingSearchViewController:(UIViewController *)parentViewController
//{
//  self.parentViewController = parentViewController;
//  [self viewChange:[TYViewControllerManager searchViewController]];
//}

- (void)viewChange:(UIViewController *)childViewController
{
  for (UIViewController *vc in [self.parentViewController childViewControllers]) {
    [vc.view removeFromSuperview];
    [vc removeFromParentViewController];
  }
  self.childViewController = childViewController;
  [self.parentViewController addChildViewController:self.childViewController];
  [self.parentViewController.view addSubview:self.childViewController.view];
  //アニメーション
  self.childViewController.view.alpha = 0.0;
  [UIView animateWithDuration:0.5
                        delay:0.0
                      options:UIViewAnimationOptionCurveEaseInOut
                   animations:^{
                     self.childViewController.view.alpha = 1.0;
                   }
                   completion:^(BOOL finished){
                     
                   }];
  if ([self.childViewController class] == [TYTopViewController class]) {
    TYTopViewController *vc = (TYTopViewController *)self.childViewController;
    vc.delegate = self;
//  } else if ([self.childViewController class] == [TYSearchViewController class]) {
//    TYSearchViewController *vc = (TYSearchViewController *)self.childViewController;
//    vc.delegate = self;
  }
  
}

- (void)topViewControllerSearchStart
{
  LOG()
//  [self viewChange:[TYViewControllerManager searchViewController]];
}

- (void)searchViewControllerGoTop
{
  LOG()
  [self viewChange:[TYViewControllerManager topViewController]];
}



@end
