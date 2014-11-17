//
//  TYTopViewController.m
//  GourmetDiary
//
//  Created by Tomohiko on 2014/11/09.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import "TYTopViewController.h"

@implementation TYTopViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    LOG()
    self.title = @"TOP";

  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor redColor];
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-90, 100, 180, 50)];
  label.text = @"検索TOP";
  label.font = [UIFont fontWithName:FONT_HIRAKAKUW6 size:30];
  label.textColor = [UIColor whiteColor];
  label.textAlignment = NSTextAlignmentCenter;
  [self.view addSubview:label];
  //検索ボタン
  UIButton *searchBtn = [self makeButton:CGRectMake(self.view.frame.size.width/2-90, 300, 180, 50) text:@"Search"];
  [searchBtn addTarget:self action:@selector(searchTop) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:searchBtn];
}

- (UIButton *)makeButton:(CGRect)rect text:(NSString *)text
{
  UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  btn.titleLabel.font = [UIFont fontWithName:FONT_HIRAKAKUW6 size:18];
  btn.layer.borderColor = [[UIColor whiteColor] CGColor];
  btn.layer.borderWidth = 1.0;
  btn.layer.cornerRadius = 10;
  [btn setFrame:rect];
  [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [btn setTitle:text forState:UIControlStateNormal];
  
  return btn;
}

- (void)searchTop
{
  LOG()
  TYSearchViewController *searchVc = [[TYSearchViewController alloc] initWithNibName:nil bundle:nil];
  searchVc.modalDelegate = self;
  UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:searchVc];
//  [self presentViewController:nv animated:YES completion:nil];
  [self.navigationController presentViewController:nv animated:YES completion:nil];
}

// 検索用ビューの破棄
- (void)searchDidFinish
{
  LOG()
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
