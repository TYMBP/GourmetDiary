//
//  TYTopViewController.h
//  GourmetDiary
//
//  Created by Tomohiko on 2014/11/09.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYSearchViewController.h"

@interface TYTopViewController : UIViewController <TYSearchViewControllerDelegate>

@property (weak, nonatomic) id delegate;
@property (strong, nonatomic) UITextView *textView;

@end

//デリゲートメソッド
@protocol TYTopViewControllerDelegate <NSObject>
- (void)topViewControllerSearchStart;
@end
