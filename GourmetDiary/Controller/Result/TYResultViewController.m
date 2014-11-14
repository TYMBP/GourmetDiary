//
//  TYResultViewController.m
//  GourmetDiary
//
//  Created by Tomohiko on 2014/11/14.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import "TYResultViewController.h"
#import "TYGourmetDiaryManager.h"
#import "TYSearchTableViewCell.h"
#import "TYKeywordSearch.h"
#import "TYApplication.h"

@implementation TYResultViewController {
  UITableView *_tableView;
  TYGourmetDiaryManager *_dataManager;
  NSArray *_searchData;
  NSUInteger _set;
  TYKeywordSearch *_connection;
  
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil set:(NSUInteger)set para:(NSMutableDictionary *)para
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _dataManager = [TYGourmetDiaryManager sharedmanager];
    _set = set;
    LOG(@"set: %lu", _set)
    if (para) {
      LOG(@"para %@", para)
    }
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor whiteColor];
  _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
  _tableView.autoresizesSubviews = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  _tableView.backgroundColor = [UIColor clearColor];
  _tableView.delegate = self;
  _tableView.dataSource = self;
  _tableView.rowHeight = 60.0;
  
  [self.view addSubview:_tableView];
  
  _searchData = [_dataManager fetchData];
  [_tableView reloadData];
}

- (void)runAPI
{
  LOG()
  [_dataManager resetData];
  @synchronized (self) {
    _connection = [[TYKeywordSearch alloc] initWithTarget:self selector:@selector(getApiData)];
    [[TYApplication application] addURLOperation:_connection];
  }
}

- (void)getApiData {
  LOG_METHOD;
  NSError *error = nil;
  NSString *json_str = [[NSString alloc] initWithData:_connection.data encoding:NSUTF8StringEncoding];
//  LOG(@"data_str:%@",json_str)
  NSData *jsonData = [json_str dataUsingEncoding:NSUTF8StringEncoding];
  NSDictionary *data = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
  [_dataManager addData:data];
  _searchData = [_dataManager fetchData];
  [_tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  LOG(@"row count %lu", _searchData.count)
  return _searchData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  SearchData *rowData = [_searchData objectAtIndex:indexPath.row];
  static NSString *cellIdentifier = @"Cell";
  TYSearchTableViewCell *cell = (TYSearchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
//    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    cell = [[TYSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
  }
  [cell setUpRowData:rowData];
  
  return cell;
}


@end
