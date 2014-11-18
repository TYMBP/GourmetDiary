//
//  TYRegisterViewController.m
//  GourmetDiary
//
//  Created by Tomohiko on 2014/11/17.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import "TYRegisterViewController.h"
#import "TYGourmetDiaryManager.h"
#import "ShopMst.h"

#define TF_CALENDAR 1
#define TF_SITUATION 2
#define TF_LEVEL 3
#define TF_PERSON 4
#define TF_FEE 5

@implementation TYRegisterViewController {
  TYGourmetDiaryManager *_dataManager;
  ShopMst *_para;
  UITextField *_douTf;
  UITextField *_situTf;
  UITextField *_levelTf;
  UITextField *_personTf;
  UITextField *_feeTf;
  UITextView *_comment;
  UIDatePicker *_picker;
  UIPickerView *_picker2;
  UIPickerView *_picker3;
  UIPickerView *_picker4;
  UIPickerView *_picker5;
  NSUInteger _levelNum;
  NSUInteger _situNum;
  NSUInteger _personNum;
  NSUInteger _feeNum;
  NSMutableArray *_levelList;
  NSMutableArray *_situList;
  NSMutableArray *_personList;
  NSMutableArray *_feeList;
  NSUInteger _tagNum;
  UIToolbar *_toolbar;
  UIToolbar *_toolbar2;
  UIToolbar *_toolbar3;
  UIToolbar *_toolbar4;
  UIToolbar *_toolbar5;
  UIView *_backView;
  NSDateFormatter *_dateFomatter;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil para:(ShopMst *)para
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _dataManager = [TYGourmetDiaryManager sharedmanager];
    _dateFomatter = nil;
    if (para) {
      LOG(@"para %@", para)
      _para = para;
      self.title = _para.shop;
    }
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor orangeColor];
  _dateFomatter = [[NSDateFormatter alloc] init];
  [_dateFomatter setDateStyle:NSDateFormatterShortStyle];
  
  UILabel *dou = [self makeLabel:CGRectMake(20, 80, 150, 40) text:@"利用日"];
  UILabel *situation = [self makeLabel:CGRectMake(20, 120, 150, 40) text:@"シチュエーション"];
  UILabel *level = [self makeLabel:CGRectMake(20, 160, 150, 40) text:@"マイ評価"];
  UILabel *person = [self makeLabel:CGRectMake(20, 200, 150, 40) text:@"人数"];
  UILabel *fee = [self makeLabel:CGRectMake(20, 240, 150, 40) text:@"料金"];
  UILabel *comment = [self makeLabel:CGRectMake(20, 280, 150, 40) text:@"コメント"];
  _douTf = [self makeTextField:CGRectMake(180, 80, 180, 30)];
  _douTf.delegate = self;
  _douTf.tag = TF_CALENDAR;
  _douTf.text = [_dateFomatter stringFromDate:[NSDate date]];
  _situTf = [self makeTextField:CGRectMake(180, 120, 180, 30)];
  _situTf.delegate = self;
  _situTf.tag = TF_SITUATION;
  _levelTf = [self makeTextField:CGRectMake(180, 160, 180, 30)];
  _levelTf.delegate =self;
  _levelTf.tag = TF_LEVEL;
  _personTf = [self makeTextField:CGRectMake(180, 200, 180, 30)];
  _personTf.delegate =self;
  _personTf.tag = TF_PERSON;
  _feeTf = [self makeTextField:CGRectMake(180, 240, 180, 30)];
  _feeTf.delegate =self;
  _feeTf.tag = TF_FEE;
  _comment = [[UITextView alloc] initWithFrame:CGRectMake(20, 320, 340, 180)];
  _comment.font = [UIFont fontWithName:FONT_HIRAKAKUW6 size:16];
  _comment.editable = YES;
  
  UIButton *registBtn = [self makeButton:CGRectMake(40, 530, 300, 40) text:@"登録する"];
  [registBtn addTarget:self action:@selector(validationData) forControlEvents:UIControlEventTouchUpInside];
  
  [self.view addSubview:dou];
  [self.view addSubview:situation];
  [self.view addSubview:level];
  [self.view addSubview:person];
  [self.view addSubview:fee];
  [self.view addSubview:comment];
  [self.view addSubview:_comment];
  [self.view addSubview:_douTf];
  [self.view addSubview:_situTf];
  [self.view addSubview:_levelTf];
  [self.view addSubview:_personTf];
  [self.view addSubview:_feeTf];
  [self.view addSubview:registBtn];
  
  //picker
  _levelList = [[NSMutableArray alloc] initWithObjects:@"", @"うーん1点", @"もうちょい2点", @"まあまあ3点", @"まずまず4点", @"うまい！5点", nil];
  _situList = [[NSMutableArray alloc] initWithObjects:@"", @"朝ごはん", @"昼ごはん", @"夜ごはん", @"お茶のじかん", @"お酒のじかん", @"持ちかえり", @"OTHER", nil];
  _personList = [[NSMutableArray alloc] initWithObjects:@"", @"1人", @"2人", @"3人", @"4人", @"5人〜9人", @"10人以上", nil];
  _feeList = [[NSMutableArray alloc] initWithObjects:@"", @"500円しない", @"500〜1,000円くらい", @"1,000〜2,000円くらい", @"2,000〜3,000円くらい", @"3,000〜4,000円くらい", @"4,000〜5,000円くらい", @"5,000〜10,000円だったかな", @"10,000円以上だった…", nil];
  
  _picker = [[UIDatePicker alloc] init];
  _picker.minuteInterval = 1;
  _picker.datePickerMode = UIDatePickerModeDate;
  [_picker addTarget:self action:@selector(datePickerEventValueChanged) forControlEvents:UIControlEventValueChanged];
  
  _picker.tag = TF_CALENDAR;
  _douTf.inputView = _picker;
  _picker2 = [self makePicker];
  _picker2.tag = TF_SITUATION;
  _situTf.inputView = _picker2;
  _picker3 = [self makePicker];
  _picker3.tag = TF_LEVEL;
  _levelTf.inputView = _picker3;
  _picker4 = [self makePicker];
  _picker4.tag = TF_PERSON;
  _personTf.inputView = _picker4;
  _picker5 = [self makePicker];
  _picker5.tag = TF_FEE;
  _feeTf.inputView = _picker5;
  _toolbar = [self makeToolbar:CGRectMake(0, 0, 320, 44)];
  _toolbar.tag = TF_CALENDAR;
  _toolbar2 = [self makeToolbar:CGRectMake(0, 0, 320, 44)];
  _toolbar2.tag = TF_SITUATION;
  _toolbar3 = [self makeToolbar:CGRectMake(0, 0, 320, 44)];
  _toolbar3.tag = TF_LEVEL;
  _toolbar4 = [self makeToolbar:CGRectMake(0, 0, 320, 44)];
  _toolbar4.tag = TF_PERSON;
  _toolbar5 = [self makeToolbar:CGRectMake(0, 0, 320, 44)];
  _toolbar5.tag = TF_FEE;
  _douTf.inputAccessoryView = _toolbar;
  _situTf.inputAccessoryView = _toolbar2;
  _levelTf.inputAccessoryView = _toolbar3;
  _personTf.inputAccessoryView = _toolbar4;
  _feeTf.inputAccessoryView = _toolbar5;
  _backView = [[UIView alloc] initWithFrame:self.view.frame];
  _backView.backgroundColor = [UIColor clearColor];
//  _backView.alpha = 0;
  _backView.hidden = YES;
  _backView.userInteractionEnabled = NO;
  [self.view addSubview:_backView];
}

- (UIView *)makeView
{
  UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
  view.backgroundColor = [UIColor blackColor];
  view.alpha = 0.2;
  view.hidden = YES;
  view.userInteractionEnabled = NO;
 
  return view;
}

- (UIPickerView *)makePicker
{
  UIPickerView *picker = [[UIPickerView alloc] init];
  picker.showsSelectionIndicator = YES;
  picker.delegate = self;
  picker.dataSource = self;
 
  return picker;
}

- (UIToolbar *)makeToolbar:(CGRect)rect
{
  UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
  toolbar.barStyle = UIBarStyleBlack;
  [toolbar sizeToFit];
  UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
  UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
  NSArray *items = [NSArray arrayWithObjects:spacer, done, nil];
  [toolbar setItems:items animated:YES];
  
  return toolbar;
}

- (UILabel *)makeLabel:(CGRect)rect text:(NSString *)text
{
  UILabel *label = [[UILabel alloc] initWithFrame:rect];
  label.font = [UIFont fontWithName:FONT_HIRAKAKUW6 size:18];
  label.textColor = [UIColor whiteColor];
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
  btn.titleLabel.font = [UIFont fontWithName:FONT_HIRAKAKUW6 size:16];
  btn.layer.borderColor = [[UIColor whiteColor] CGColor];
  btn.layer.borderWidth = 1.0;
  btn.layer.cornerRadius = 10;
  [btn setFrame:rect];
  [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [btn setTitle:text forState:UIControlStateNormal];
  
  return btn;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
  _tagNum = 0;
  
  switch (textField.tag) {
    case TF_SITUATION:
      _tagNum = TF_SITUATION;
      break;
    case TF_LEVEL:
      _tagNum = TF_LEVEL;
      break;
    case TF_PERSON:
      _tagNum = TF_PERSON;
      break;
    case TF_FEE:
      _tagNum = TF_FEE;
      break;
    default:
      break;
  }
  // ピッカー表示開始
  _backView.hidden = NO;
  return YES;
}

- (void)done:(id)sender
{
  _backView.hidden = YES;
  [_levelTf resignFirstResponder];
  [_douTf resignFirstResponder];
  [_situTf resignFirstResponder];
  [_personTf resignFirstResponder];
  [_feeTf resignFirstResponder];
}

//バリデーション
- (void)validationData
{
  if ([_douTf.text length] == 0 || [_situTf.text length] == 0 || [_levelTf.text length] == 0 || [_personTf.text length] == 0 || [_feeTf.text length] == 0) {
    [self warning:@"未入力項目があります"];
  } else if ([_comment.text length] >= 256){
    [self warning:@"コメントは256文字までで入力してください"];
  } else {
    [_dateFomatter setDateFormat:@"yyyy/MM/dd"];
    [_dateFomatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *date = [_dateFomatter dateFromString:_douTf.text];
  
    NSString *dateStr = [_dateFomatter stringFromDate:[NSDate date]];
    [_dateFomatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *now = [_dateFomatter dateFromString:dateStr];
    NSComparisonResult result  = [date compare:now];
    
    switch (result) {
      case NSOrderedDescending:
        [self warning:@"日時の入力に誤りがあります"];
        break;
      default:
        [self registerVisitData:date];
        break;
    }
  }
}

//登録
- (void)registerVisitData:(NSDate *)date
{
  NSMutableDictionary *dic = [NSMutableDictionary dictionary];
  [dic setValue:_para.sid forKey:@"sid"];
  [dic setValue:date forKey:@"visited_at"];
  [dic setValue:[NSNumber numberWithInteger:_personNum] forKey:@"persons"];
  [dic setValue:_comment.text forKey:@"memo"];
  [dic setValue:[NSNumber numberWithInteger:_situNum] forKey:@"situation"];
  [dic setValue:[NSNumber numberWithInteger:_feeNum] forKey:@"fee"];
  _para.level = [NSNumber numberWithInteger:_levelNum];
  [_dataManager addShopMstData:_para];
  [_dataManager addVisitData:dic];

//  if ([self.modalDelegate respondsToSelector:@selector(searchDidFinish)]) {
//    [self.modalDelegate searchDidFinish];
//  }
  [self.navigationController popToRootViewControllerAnimated:YES];
}

//AlertView
- (void)warning:(NSString *)mess
{
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"入力エラー" message:mess preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
    LOG(@"OK tap")
  }];
  [alert addAction:ok];
  [self presentViewController:alert animated:YES completion:nil];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
  NSUInteger n;
  switch (_tagNum) {
    case TF_SITUATION:
      n = [_situList count];
      break;
    case TF_LEVEL:
      n = [_levelList count];
      break;
    case TF_PERSON:
      n = [_personList count];
      break;
    case TF_FEE:
      n = [_feeList count];
      break;
    default:
      break;
  }
  return n;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  NSArray *list;
  switch (_tagNum) {
    case TF_SITUATION:
      list = _situList;
      break;
    case TF_LEVEL:
      list = _levelList;
      break;
    case TF_PERSON:
      list = _personList;
      break;
    case TF_FEE:
      list = _feeList;
      break;
    default:
      break;
  }
  return [list objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//  LOG(@"row: %lu", row)
  switch (_tagNum) {
    case TF_SITUATION:
      _situTf.text = [NSString stringWithFormat:@"%@", _situList[row]];
      _situNum = row;
      break;
    case TF_LEVEL:
      _levelTf.text = [NSString stringWithFormat:@"%@", _levelList[row]];
      _levelNum = row;
      break;
    case TF_PERSON:
      _personTf.text = [NSString stringWithFormat:@"%@", _personList[row]];
      _personNum = row;
      break;
    case TF_FEE:
      _feeTf.text = [NSString stringWithFormat:@"%@", _feeList[row]];
      _feeNum = row;
      break;
    default:
      break;
  }
}

//カレンダー更新
- (void)datePickerEventValueChanged
{
  _douTf.text = [_dateFomatter stringFromDate:_picker.date];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  //キーボード閉じる
  [self.view.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop){
    if ([obj isKindOfClass:[UITextView class]]) {
      LOG()
      _backView.hidden = YES;
      [obj resignFirstResponder];
    } else if ([obj isKindOfClass:[UITextField class]]) {
      LOG()
      _backView.hidden = YES;
      [obj resignFirstResponder];
    } else {
    }
  }];
}

@end
