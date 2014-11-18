//
//  TYResultViewController.m
//  GourmetDiary
//
//  Created by Tomohiko on 2014/11/14.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import "TYResultViewController.h"
#import "TYGourmetDiaryManager.h"
#import "TYDetailViewController.h"
#import "TYSearchTableViewCell.h"
#import "TYKeywordSearchConn.h"
#import "KeywordSearch.h"
#import "TYApplication.h"

@implementation TYResultViewController {
  UITableView *_tableView;
  TYGourmetDiaryManager *_dataManager;
  NSArray *_searchData;
  NSUInteger _set;
  TYKeywordSearchConn *_connection;
  NSMutableDictionary *_para;
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
      _para = para;
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
  
  if (_set == 1) {
    _searchData = nil;
    _searchData = [_dataManager fetchData];
    [_tableView reloadData];
  } else if (_set == 2) {
    LOG()
    [self runAPI];
  }
}

- (void)runAPI
{
  LOG()
  [_dataManager resetKeywordSearchData];
  @synchronized (self) {
    _connection = [[TYKeywordSearchConn alloc] initWithTarget:self selector:@selector(getApiData) para:_para];
    [[TYApplication application] addURLOperation:_connection];
  }
}

- (void)getApiData {
  NSError *error = nil;
  NSString *json_str = [[NSString alloc] initWithData:_connection.data encoding:NSUTF8StringEncoding];
//  LOG(@"data_str:%@",json_str)
  NSData *jsonData = [json_str dataUsingEncoding:NSUTF8StringEncoding];
  NSDictionary *data = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
  
  LOG(@"error %@", [[data objectForKey:@"results"] objectForKey:@"error"])
  LOG(@"error %@", [data valueForKeyPath:@"results.error.message"])
  LOG(@"data count %@", [[data objectForKey:@"results"] objectForKey:@"results_returned"])
  NSNumber *n = [[data objectForKey:@"results"] objectForKey:@"results_returned"];
  int num = [n intValue];
  LOG(@"n: %@", n)
  if (num == 0) {
    LOG(@"response null")
    [self warning:@"検索条件が正しくないか、もしくは条件を絞り込む必要があります"];
  } else {
    [_dataManager addKeywordSearchData:data];
     _searchData = nil;
    [_dataManager fetchKeywordSearchData:^(NSArray *ary){
      LOG(@"ary :%@", ary)
       _searchData = ary;
      [_tableView reloadData];
     }];
  }
}

- (void)warning:(NSString *)mess
{
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"入力エラー" message:mess preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
    LOG(@"OK tap")
    [self.navigationController popToRootViewControllerAnimated:YES];
  }];
  [alert addAction:ok];
  [self presentViewController:alert animated:YES completion:nil];
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
  if (cell == nil) {
    cell = [[TYSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
  }
  [cell setUpRowData:rowData];
  
  return cell;
}

//タップイベント
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  SearchData *rowData = [_searchData objectAtIndex:indexPath.row];
  LOG(@"sid: %@", rowData.sid)
  NSString *para = rowData.sid;
  TYDetailViewController *detailVC = [[TYDetailViewController alloc] initWithNibName:nil bundle:nil para:para];
  [self.navigationController pushViewController:detailVC animated:YES];
}

@end
