//
//  TYUtil.m
//  GourmetDiary
//
//  Created by Tomohiko on 2014/11/14.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import "TYUtil.h"

@implementation TYUtil

+ (NSString *)checkKeyword:(NSString *)keyword
{
  if (keyword.length >= 20) {
    return @"キーワードは 20文字までで入力してください";
  }
  return nil;
}

@end
