//
//  TYViewController.m
//  GourmetDiary
//
//  Created by Tomohiko on 2014/11/09.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import "TYViewController.h"

@implementation TYViewController {
}
- (void)viewDidLoad
{
  LOG()
  [super viewDidLoad];
  [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
  self.vcntManager = [[TYViewControllerManager alloc] init];
  
  [self.vcntManager switchingTopViewController:self];
//  [self.vcntManager switchingSearchViewController:self];
  
}


@end
