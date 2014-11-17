//
//  TYRegisterViewController.h
//  GourmetDiary
//
//  Created by Tomohiko on 2014/11/17.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShopMst;

@interface TYRegisterViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil para:(ShopMst *)para;

@end
