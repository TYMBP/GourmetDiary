//
//  TYTableViewCell.h
//  GourmetDiary
//
//  Created by Tomohiko on 2014/11/12.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SearchData.h"

@interface TYTableViewCell : UITableViewCell

- (void)setUpRowData:(NSString *)rowdata rowIndexPath:(NSInteger)row;
- (void)setUpRowData:(SearchData *)rowdata;

@end
