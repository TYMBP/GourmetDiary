//
//  TYSearchViewController.m
//  GourmetDiary
//
//  Created by Tomohiko on 2014/11/09.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import "TYSearchViewController.h"
#import "TYLocationSearch.h"
#import "TYApplication.h"
#import "TYGourmetDiaryManager.h"
#import "TYSearchTableViewCell.h"
#import "TYResultViewController.h"
#import "TYUtil.h"
//#import "SearchData.h"

#define MORE_LABEL 100

@implementation TYSearchViewController {
  NSMutableData *_responseData;
  TYLocationSearch *_connection;
  UITextField *_shopKeyword;
  UITextField *_areaStation;
  UITableView *_tableView;
  UILabel *_more;
  TYGourmetDiaryManager *_dataManager;
  NSArray *_searchData;
  NSString *_shopMessage;
  NSString *_areaMessage;
// あとで消す NSArray *_location;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _dataManager = [TYGourmetDiaryManager sharedmanager];
    
  }
  return self;
}

- (void)viewDidLoad
{
  self.navigationItem.title = @"Search";
  
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor grayColor];
  UIBarButtonItem *topBtn = [[UIBarButtonItem alloc] initWithTitle:@"Top" style:UIBarButtonItemStylePlain target:self action:@selector(searchDidFinish)];
  self.navigationItem.leftBarButtonItem = topBtn;
  
  //検索ボタン
  UIButton *searchBtn = [self makeButton:CGRectMake(self.view.frame.size.width/2-90, 300, 180, 50) text:@"Search"];
  [searchBtn addTarget:self action:@selector(searchStart) forControlEvents:UIControlEventTouchUpInside];
  //検索テキストフィールド
  _shopKeyword = [self makeTextField:CGRectMake(self.view.frame.size.width/2-120, 100, 240, 40)];
  _areaStation = [self makeTextField:CGRectMake(self.view.frame.size.width/2-120, 180, 240, 40)];
  UILabel *shopInput = [self makeLabel:CGRectMake(70, 70, 100, 30) text:@"店名 キーワード" size:12];
  UILabel *areaInput = [self makeLabel:CGRectMake(70, 150, 100, 30) text:@"エリア 駅名" size:12];
  UILabel *location = [self makeLabel:CGRectMake(10, 370, 100, 30) text:@"周辺のお店" size:18];
  _more = [self makeLabel:CGRectMake(290, 370, 80, 30) text:@"もっとみる" size:14];
  _more.tag = MORE_LABEL;
  _more.userInteractionEnabled = YES;
  
  //table
  _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 400, self.view.bounds.size.width, 180)];
  _tableView.backgroundColor = [UIColor clearColor];
  _tableView.alwaysBounceHorizontal = NO;
  _tableView.alwaysBounceVertical = NO;
  _tableView.delegate = self;
  _tableView.dataSource = self;
  _tableView.rowHeight = 60.0;
  
  [self.view addSubview:searchBtn];
  [self.view addSubview:_shopKeyword];
  [self.view addSubview:_areaStation];
  [self.view addSubview:shopInput];
  [self.view addSubview:areaInput];
  [self.view addSubview:location];
  [self.view addSubview:_more];
  [self.view addSubview:_tableView];
  
//   APIよりDATAの取得
  [self runAPI];
}


- (UILabel *)makeLabel:(CGRect)rect text:(NSString *)text size:(NSInteger)size
{
  UILabel *label = [[UILabel alloc] initWithFrame:rect];
  label.font = [UIFont fontWithName:FONT_HIRAKAKUW6 size:size];
  label.textColor = [UIColor blackColor];
  label.text = text;
  
  return label;
}

- (UITextField *)makeTextField:(CGRect)rect
{
  UITextField *textField = [[UITextField alloc] initWithFrame:rect];
  [textField setReturnKeyType:UIReturnKeyNext];
  [textField setBackgroundColor:[UIColor whiteColor]];
  [textField setBorderStyle:UITextBorderStyleRoundedRect];
  textField.delegate = self;
  
  return textField;
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

- (void)searchDidFinish
{
  LOG()
  if ([self.modalDelegate respondsToSelector:@selector(searchDidFinish)]) {
    [self.modalDelegate searchDidFinish];
  }
}

//検索スタート
- (void)searchStart
{
  LOG()
  _shopMessage = nil;
  _areaMessage = nil;
  [_shopKeyword resignFirstResponder];
  [_areaStation resignFirstResponder];
  NSMutableDictionary *para = [NSMutableDictionary dictionary];
 
  //バリデーション
  if ([_shopKeyword.text length] == 0 && [_areaStation.text length] == 0) {
    [self warning:@"検索ワードを入力してください"];
  } else {
    _shopMessage = [TYUtil checkKeyword:_shopKeyword.text];
    LOG(@"shopMessage %@", _shopMessage)
    _areaMessage = [TYUtil checkKeyword:_areaStation.text];
    LOG(@"areaMessage %@", _areaMessage)
    if ([_shopMessage length] != 0) {
      LOG(@"message error")
      [self warning:_shopMessage];
    } else if ([_areaMessage length] != 0) {
      LOG(@"message error")
      [self warning:_areaMessage];
    }
    [para setValue:_shopKeyword.text forKey:@"shop"];
    [para setValue:_areaStation.text forKey:@"area"];
    
    TYResultViewController *resultVC = [[TYResultViewController alloc] initWithNibName:nil bundle:nil set:2 para:para];
    [self.navigationController pushViewController:resultVC animated:YES];
  }
}

- (void)warning:(NSString *)mess
{
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"入力エラー" message:mess preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
    LOG(@"OK tap")
  }];
  [alert addAction:ok];
  [self presentViewController:alert animated:YES completion:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  UITouch *touch = [[event allTouches] anyObject];
  if (touch.view.tag == _more.tag) {
    LOG()
    TYResultViewController *resultVC = [[TYResultViewController alloc] initWithNibName:nil bundle:nil set:1 para:nil];
    [self.navigationController pushViewController:resultVC animated:YES];
  }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)runAPI
{
  LOG()
  [_dataManager resetData];
  @synchronized (self) {
    _connection = [[TYLocationSearch alloc] initWithTarget:self selector:@selector(getApiData)];
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
  return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  LOG(@"indexPath %lu", indexPath.row)
  SearchData *rowData = [_searchData objectAtIndex:indexPath.row];
  LOG(@"rowdata %@", rowData.shop)
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
  LOG()
}


@end
