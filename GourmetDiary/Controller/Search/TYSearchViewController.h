//
//  TYSearchViewController.h
//  GourmetDiary
//
//  Created by Tomohiko on 2014/11/09.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TYSearchViewControllerDelegate <NSObject>

- (void)searchDidFinish;

@end

@interface TYSearchViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
@property (assign, nonatomic) id delegate;
@property (weak, nonatomic) id <TYSearchViewControllerDelegate> modalDelegate;
@end

