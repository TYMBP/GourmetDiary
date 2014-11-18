//
//  TYDetailViewController.m
//  GourmetDiary
//
//  Created by Tomohiko on 2014/11/16.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import "TYDetailViewController.h"
#import "TYDetailSearchConn.h"
#import "TYGourmetDiaryManager.h"
#import "TYRegisterViewController.h"
#import "TYApplication.h"
#import "ShopMst.h"

@implementation TYDetailViewController {
  TYGourmetDiaryManager *_dataManager;
  ShopMst *_shopData;
  TYDetailSearchConn *_connection;
  NSString *_para;
  UILabel *_nameData;
  UILabel *_levelData;
  UILabel *_genreData;
  UILabel *_addressData;
  UILabel *_visitedData;
  UIImageView *_shopImage;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil para:(NSString *)para
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _dataManager = [TYGourmetDiaryManager sharedmanager];
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
  self.view.backgroundColor = [UIColor purpleColor];
  
  UILabel *name = [self makeLabel:CGRectMake(20, 80, 100, 40) text:@"店名"];
  UILabel *level = [self makeLabel:CGRectMake(20, 120, 100, 40) text:@"マイ評価"];
  UILabel *genre = [self makeLabel:CGRectMake(20, 160, 100, 40) text:@"ジャンル"];
  UILabel *address = [self makeLabel:CGRectMake(20, 200, 100, 40) text:@"アドレス"];
  UILabel *visited = [self makeLabel:CGRectMake(20, 240, 100, 40) text:@"訪問回数"];
  _nameData = [self makeLabel:CGRectMake(140, 80, 200, 40) text:@""];
  _levelData = [self makeLabel:CGRectMake(140, 120, 200, 40) text:@""];
  _genreData = [self makeLabel:CGRectMake(140, 160, 200, 40) text:@""];
  _addressData = [self makeLabel:CGRectMake(140, 200, 200, 40) text:@""];
  _visitedData = [self makeLabel:CGRectMake(140, 240, 200, 40) text:@""];
  _shopImage = [self makeImageView:CGRectMake(20, 300, 168, 125) path:nil];
  UIButton *mapBtn = [self makeButton:CGRectMake(230, 300, 100, 30) text:@"地図"];
  UIButton *telBtn = [self makeButton:CGRectMake(230, 350, 100, 30) text:@"電話"];
  UIButton *hpBtn = [self makeButton:CGRectMake(230, 400, 100, 30) text:@"hotpepper"];
  UIButton *registBtn = [self makeButton:CGRectMake(40, 450, 280, 40) text:@"登録画面へ"];
  [registBtn addTarget:self action:@selector(nextInputData) forControlEvents:UIControlEventTouchUpInside];
  
  //日記登録
  [self.view addSubview:name];
  [self.view addSubview:level];
  [self.view addSubview:genre];
  [self.view addSubview:address];
  [self.view addSubview:visited];
  [self.view addSubview:_nameData];
  [self.view addSubview:_levelData];
  [self.view addSubview:_genreData];
  [self.view addSubview:_addressData];
  [self.view addSubview:_visitedData];
  [self.view addSubview:_shopImage];
  [self.view addSubview:mapBtn];
  [self.view addSubview:telBtn];
  [self.view addSubview:hpBtn];
  [self.view addSubview:registBtn];
  
  [self runAPI];
}

- (UILabel *)makeLabel:(CGRect)rect text:(NSString *)text
{
  UILabel *label = [[UILabel alloc] initWithFrame:rect];
  label.font = [UIFont fontWithName:FONT_HIRAKAKUW6 size:18];
  label.textColor = [UIColor whiteColor];
  label.text = text;
  return label;
}

- (UIButton *)makeButton:(CGRect)rect text:(NSString *)text
{
  UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  btn.titleLabel.font = [UIFont fontWithName:FONT_HIRAKAKUW6 size:16];
  btn.layer.borderColor = [[UIColor whiteColor] CGColor];
  btn.layer.borderWidth = 1.0;
  btn.layer.cornerRadius = 10;
  [btn setFrame:rect];
  [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [btn setTitle:text forState:UIControlStateNormal];
  
  return btn;
}

- (UIImageView *)makeImageView:(CGRect)rect path:(NSString *)path
{
  UIImage *img;
  UIImageView *iv = [[UIImageView alloc] initWithFrame:rect];
  if (path) {
    NSURL *url = [NSURL URLWithString:path];
    NSData *data = [NSData dataWithContentsOfURL:url];
    img = [[UIImage alloc] initWithData:data];
  } else {
    img = [UIImage imageNamed:@"NoImage"];
  }
  iv.image = img;
  
  return iv;
}

- (void)nextInputData
{
  LOG()
  TYRegisterViewController *detailVC = [[TYRegisterViewController alloc] initWithNibName:nil bundle:nil para:_shopData];
  [self.navigationController pushViewController:detailVC animated:YES];
}

//ショップ詳細データ取得
- (void)runAPI
{
  LOG()
//  [_dataManager resetKeywordSearchData];
  @synchronized (self) {
    _connection = [[TYDetailSearchConn alloc] initWithTarget:self selector:@selector(getApiData) para:_para];
    [[TYApplication application] addURLOperation:_connection];
  }
}

- (void)getApiData {
  NSError *error = nil;
  NSString *json_str = [[NSString alloc] initWithData:_connection.data encoding:NSUTF8StringEncoding];
  LOG(@"data_str:%@",json_str)
  NSData *jsonData = [json_str dataUsingEncoding:NSUTF8StringEncoding];
  NSDictionary *data = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
  if (error) {
    LOG(@"error %@", [[data valueForKeyPath:@"results.error.message"] objectForKey:0])
  }
//  LOG(@"data count %@", [[data objectForKey:@"results"] objectForKey:@"results_returned"])
  
  _shopData = nil;
  
  [_dataManager tempShopData:data setData:^(ShopMst *master){
    LOG(@"master: %@", master)
    _shopData = master;
    _nameData.text = _shopData.shop;
    //_levelData.text
    _genreData.text = _shopData.genre;
    _addressData.text = _shopData.address;
    //visited.text
    [_shopImage removeFromSuperview];
    _shopImage = nil;
    _shopImage = [self makeImageView:CGRectMake(20, 300, 168, 125) path:_shopData.img_path];
    [self.view addSubview:_shopImage];
  }];
}




@end
