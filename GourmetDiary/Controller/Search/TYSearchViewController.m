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
#import "TYGourmetDialyManager.h"

@implementation TYSearchViewController {
  NSMutableData *_responseData;
  TYLocationSearch *_connection;
  UITextField *_shopKeyword;
  UITextField *_areaStation;
  UITableView *_tableView;
  TYGourmetDialyManager *_dataManager;
  
// あとで消す NSArray *_location;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  LOG()
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _dataManager = [TYGourmetDialyManager sharedmanager];
    
//移動したのであとで消す
//    _location = [[TYApplication application] getLocation];
//    LOG(@"location %@", _location)
//    LOG(@"lat %@", [_location objectAtIndex:1])
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
  [searchBtn addTarget:self action:@selector(hoge) forControlEvents:UIControlEventTouchUpInside];
  //検索テキストフィールド
  _shopKeyword = [self makeTextField:CGRectMake(self.view.frame.size.width/2-120, 100, 240, 40)];
  _areaStation = [self makeTextField:CGRectMake(self.view.frame.size.width/2-120, 180, 240, 40)];
  UILabel *shopInput = [self makeLabel:CGRectMake(70, 70, 100, 30) text:@"店名 キーワード"];
  UILabel *areaInput = [self makeLabel:CGRectMake(70, 150, 100, 30) text:@"エリア 駅名"];
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
  [self.view addSubview:_tableView];
  
//   APIよりDATAの取得
  [self runAPI];
}

//チェック用
- (void)hoge
{
  LOG()
}

- (UILabel *)makeLabel:(CGRect)rect text:(NSString *)text
{
  UILabel *label = [[UILabel alloc] initWithFrame:rect];
  label.font = [UIFont fontWithName:FONT_HIRAKAKUW6 size:12];
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
// あとで削除する1112
//  NSNotification *n = [NSNotification notificationWithName:@"searchFinish" object:self];
//  [[NSNotificationCenter defaultCenter] postNotification:n];
}

- (void)runAPI
{
  LOG()
  @synchronized (self) {
    _connection = [[TYLocationSearch alloc] initWithTarget:self selector:@selector(getApiData)];
    [[TYApplication application] addURLOperation:_connection];
  }
}

- (void)getApiData {
  LOG_METHOD;
  NSError *error = nil;
  NSString *json_str = [[NSString alloc] initWithData:_connection.data encoding:NSUTF8StringEncoding];
  LOG(@"data_str:%@",json_str)
  NSData *jsonData = [json_str dataUsingEncoding:NSUTF8StringEncoding];
  NSDictionary *data = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
  LOG(@"data:%@",data)
  
  [_dataManager addData:data];
  
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
  static NSString *cellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    cell.textLabel.text = @"test";
  }
  return cell;
}


@end
