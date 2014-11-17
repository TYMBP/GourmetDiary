//
//  TYSearchTableViewCell.m
//  GourmetDiary
//
//  Created by Tomohiko on 2014/11/13.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import "TYSearchTableViewCell.h"
#import "SearchData.h"

@implementation TYSearchTableViewCell {
  UILabel *_jenre;
  UILabel *_name;
  UILabel *_area;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    _jenre = [[UILabel alloc] initWithFrame:CGRectZero];
    _jenre.font = [UIFont fontWithName:FONT_HIRAKAKUW6 size:10];
    _name = [[UILabel alloc] initWithFrame:CGRectZero];
    _name.font = [UIFont fontWithName:FONT_HIRAKAKUW6 size:12];
    _name.text = @"name";
    _area = [[UILabel alloc] initWithFrame:CGRectZero];
    _area.font = [UIFont fontWithName:FONT_HIRAKAKUW6 size:10];
    _area.text = @"area";
    
    [self.contentView addSubview:_jenre];
    [self.contentView addSubview:_name];
    [self.contentView addSubview:_area];
    
  }
  return self;
}

- (void)setUpRowData:(SearchData *)rowdata
{
//  LOG(@"rowdata %@",rowdata);
  _jenre.text = rowdata.genre;
  _jenre.frame = CGRectMake(10, 10, 100, 20);
  _name.text = rowdata.shop;
  _name.frame = CGRectMake(110, 10, 180, 20);
  _area.text = rowdata.address;
  _area.frame = CGRectMake(290, 10, 70, 20);
  
}


@end
