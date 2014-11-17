//
//  TYGourmetDialyManager.m
//  GourmetDiary
//
//  Created by Tomohiko on 2014/11/12.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import "TYGourmetDiaryManager.h"
#import "SearchData.h"
#import "KeywordSearch.h"
#import "ShopMst.h"
#import "VisitData.h"

@implementation TYGourmetDiaryManager {
  SearchData *_searchData;
  KeywordSearch *_keywordData;
  ShopMst *_shopData;
  VisitData *_visitData;
  NSURL *_storeURL;
  int _n;
}

static TYGourmetDiaryManager *sharedInstance = nil;

+ (TYGourmetDiaryManager *)sharedmanager
{
  @synchronized(self) {
    LOG()
    sharedInstance = [[self alloc] init];
  }
  return sharedInstance;
}

- (id)init
{
  self = [super init];
  if (self) {
    //初期設定
    LOG()
    [self loadManagedObjectContext];
  }
  return self;
}

- (void)loadManagedObjectContext
{
  LOG()
  if (_context != nil) return;
  LOG()
  NSPersistentStoreCoordinator *aCoodinator = [self coordinator];
  if (aCoodinator != nil) {
    _context = [[NSManagedObjectContext alloc] init];
    [_context setPersistentStoreCoordinator:aCoodinator];
  }
}

- (NSPersistentStoreCoordinator *)coordinator
{
  LOG()
  if (_coordinator != nil) {
    return _coordinator;
  }
// SQLパターン
  NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
  _storeURL = [NSURL fileURLWithPath:[directory stringByAppendingPathComponent:@"GourmetDiary.sqlite"]];
//  LOG(@"storeURL %@", _storeURL)
//  NSURL *modelURL = [NSURL fileURLWithPath:[NSFileManager defaultManager].currentDirectoryPath];
//  modelURL = [modelURL URLByAppendingPathComponent:@"GourmetDiary.momd"];
  NSError *error = nil;
  _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjetModel]];
  if (![_coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:_storeURL options:nil error:&error]) {
    LOG(@"Unresolved error %@ %@", error, [error userInfo])
    abort();
  }
  return _coordinator;
}

- (NSManagedObjectModel *)managedObjetModel {
  if (_managedObjetModel != nil) {
    return _managedObjetModel;
  }
  NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"GourmetDiary" ofType:@"momd"];
  NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
  _managedObjetModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  
  return _managedObjetModel;
}

/* 検索TOP・現在地検索 */
//データリセット
- (void)resetData
{
  LOG()
  if (_searchData) {
    [_context deleteObject:_searchData];
    NSError *error;
    if (![_context save:&error]) {
      LOG(@"error: %@", error)
    }
  } else {
    NSFetchRequest *requestDelete = [[NSFetchRequest alloc] init];
    [requestDelete setEntity:[NSEntityDescription entityForName:@"SearchData" inManagedObjectContext:_context]];
    [requestDelete setIncludesPropertyValues:NO];
    NSError *error = nil;
    NSArray *dataArray = [_context executeFetchRequest:requestDelete error:&error];
    for (NSManagedObject *data in dataArray) {
      [_context deleteObject:data];
    }
    NSError *saveError = nil;
    [_context save:&saveError];
  }
}

//データ登録
- (void)addData:(NSDictionary *)data
{
  NSArray *ary = [[data objectForKey:@"results"] objectForKey:@"shop"];
  LOG(@"data: %lu", ary.count)
  
  for (_n = 0; _n < ary.count; _n++) {
    _searchData = (SearchData *)[NSEntityDescription insertNewObjectForEntityForName:@"SearchData" inManagedObjectContext:_context];
    if (_searchData == nil) {
      return;
    }
    _searchData.shop = [[data valueForKeyPath:@"results.shop.name"] objectAtIndex:_n];
    _searchData.sid = [[data valueForKeyPath:@"results.shop.id"] objectAtIndex:_n];
    _searchData.genre = [[data valueForKeyPath:@"results.shop.genre.name"] objectAtIndex:_n];
    _searchData.address = [[data valueForKeyPath:@"results.shop.address"] objectAtIndex:_n];
    NSString *lat = [[data valueForKeyPath:@"results.shop.lat"] objectAtIndex:_n];
    _searchData.lat = [NSNumber numberWithDouble:[lat doubleValue]];
    NSString *lng = [[data valueForKeyPath:@"results.shop.lng"] objectAtIndex:_n];
    _searchData.lng = [NSNumber numberWithDouble:[lng doubleValue]];
//    LOG(@"n %d shop: %@ sid: %@ category:%@ area:%@ lat:%@ lng:%@", _n, _searchData.shop, _searchData.sid, _searchData.category, _searchData.area, _searchData.lat, _searchData.lng)
    NSError *error = nil;
    if (![_context save:&error]) {
      LOG("error %@", error)
    }
  }
}

//検索TOPデータ取得
- (NSArray *)fetchData
{
  NSError *error = nil;
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SearchData"];
  NSArray *fetchedArray = [_context executeFetchRequest:request error:&error];
//  LOG(@"fetchedArrary %@", [fetchedArray objectAtIndex:0])
//  LOG(@"fetchedArrary %@", [fetchedArray objectAtIndex:1])
//  LOG(@"fetchedArrary %@", [fetchedArray objectAtIndex:2])
  
  if (fetchedArray == nil) {
    LOG(@"fetch failure\n%@", [error localizedDescription])
    return fetchedArray;
  }
  return fetchedArray;
}

/* キーワード検索 */
//キーワード検索データリセット
- (void)resetKeywordSearchData
{
  LOG()
  if (_keywordData) {
    [_context deleteObject:_keywordData];
    NSError *error;
    if (![_context save:&error]) {
      LOG(@"error: %@", error)
    }
  } else {
    NSFetchRequest *requestDelete = [[NSFetchRequest alloc] init];
    [requestDelete setEntity:[NSEntityDescription entityForName:@"KeywordSearch" inManagedObjectContext:_context]];
    [requestDelete setIncludesPropertyValues:NO];
    NSError *error = nil;
    NSArray *dataArray = [_context executeFetchRequest:requestDelete error:&error];
    for (NSManagedObject *data in dataArray) {
      [_context deleteObject:data];
    }
    NSError *saveError = nil;
    [_context save:&saveError];
  }
}

//キーワード検索結果登録
- (void)addKeywordSearchData:(NSDictionary *)data
{
  NSArray *ary = [[data objectForKey:@"results"] objectForKey:@"shop"];
  LOG(@"data: %lu", ary.count)
  
  for (_n = 0; _n < ary.count; _n++) {
    _keywordData = (KeywordSearch *)[NSEntityDescription insertNewObjectForEntityForName:@"KeywordSearch" inManagedObjectContext:_context];
    if (_keywordData == nil) {
      return;
    }
    _keywordData.shop = [[data valueForKeyPath:@"results.shop.name"] objectAtIndex:_n];
    _keywordData.sid = [[data valueForKeyPath:@"results.shop.id"] objectAtIndex:_n];
    _keywordData.genre = [[data valueForKeyPath:@"results.shop.genre.name"] objectAtIndex:_n];
    _keywordData.address = [[data valueForKeyPath:@"results.shop.address"] objectAtIndex:_n];
    LOG(@"n %d shop: %@ sid: %@ genre:%@ address:%@", _n, _keywordData.shop, _keywordData.sid, _keywordData.genre, _keywordData.address)
    NSError *error = nil;
    if (![_context save:&error]) {
      LOG("error %@", error)
    }
  }
}

//検索TOPデータ取得
- (void)fetchKeywordSearchData:(Callback)callback
{
  LOG()
  NSError *error = nil;
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"KeywordSearch"];
  NSArray *fetchedArray = [_context executeFetchRequest:request error:&error];
  
  if (fetchedArray == nil) {
    LOG(@"fetch failure\n%@", [error localizedDescription])
  }
  
  if (callback) {
    LOG()
    callback(fetchedArray);
  }
}

/* shop詳細 */
- (void)tempShopData:(NSDictionary *)data setData:(SetData)setData
{
  _shopData = nil;
  NSArray *ary = [[data objectForKey:@"results"] objectForKey:@"shop"];
  LOG(@"data: %lu", ary.count)
  
  _shopData = (ShopMst *)[NSEntityDescription insertNewObjectForEntityForName:@"ShopMst" inManagedObjectContext:_context];
  if (_shopData == nil) {
    return;
  } else {
    LOG()
    _shopData.shop = [[data valueForKeyPath:@"results.shop.name"] objectAtIndex:0];
    _shopData.shop_kana = [[data valueForKeyPath:@"results.shop.name"] objectAtIndex:0];
    _shopData.area = [[data valueForKeyPath:@"results.shop.small_area.name"] objectAtIndex:0];
    _shopData.address = [[data valueForKeyPath:@"results.shop.address"] objectAtIndex:0];
    _shopData.genre = [[data valueForKeyPath:@"results.shop.genre.name"] objectAtIndex:0];
    _shopData.url = [[data valueForKeyPath:@"results.shop.urls.mobile"] objectAtIndex:0];
    _shopData.sp_url = [[data valueForKeyPath:@"results.shop.coupon_urls.sp"] objectAtIndex:0];
    NSString *lat = [[data valueForKeyPath:@"results.shop.lat"] objectAtIndex:0];
    _shopData.lat = [NSNumber numberWithDouble:[lat doubleValue]];
    NSString *lng = [[data valueForKeyPath:@"results.shop.lng"] objectAtIndex:0];
    _shopData.lng = [NSNumber numberWithDouble:[lng doubleValue]];
    _shopData.img_path = [[data valueForKeyPath:@"results.shop.photo.mobile.l"] objectAtIndex:0];
    _shopData.sid = [[data valueForKeyPath:@"results.shop.id"] objectAtIndex:0];
    
    LOG(@"shop:%@ shop_kana:%@ area:%@ address:%@ genre:%@ url:%@ sp_url:%@ lat:%@ lng:%@ img_path:%@ sid:%@", _shopData.shop, _shopData.shop_kana, _shopData.area, _shopData.address, _shopData.genre, _shopData.url, _shopData.sp_url, _shopData.lat, _shopData.lng, _shopData.img_path, _shopData.sid)
    
  }
  
  NSArray *visitAry = [self fetchVisitData];
  if (visitAry) {
    LOG(@"visitAry: %@", visitAry)
    for (int i = 0; i < visitAry.count; i++) {
      LOG(@"i: %d", i)
    }
  }
  if (setData) {
    LOG()
    setData(_shopData);
  }
}

//店舗マスター登録
- (void)addShopMstData:(ShopMst *)data
{
  _shopData = nil;
  _shopData = (ShopMst *)[NSEntityDescription insertNewObjectForEntityForName:@"ShopMst" inManagedObjectContext:_context];
  if (_shopData == nil) {
    return;
  }
  LOG()
  _shopData.shop = data.shop;
  _shopData.shop_kana = data.shop_kana;
  _shopData.area = data.area;
  _shopData.address = data.address;
  _shopData.genre = data.genre;
  _shopData.url = data.url;
  _shopData.sp_url = data.sp_url;
  _shopData.lat = data.lat;
  _shopData.lng = data.lng;
  _shopData.img_path = data.img_path;
  _shopData.sid = data.sid;
  _shopData.level = data.level;
  
  LOG(@"shop:%@ shop_kana:%@ area:%@ address:%@ genre:%@ url:%@ sp_url:%@ lat:%@ lng:%@ img_path:%@ sid:%@ level:%@", data.shop, data.shop_kana, data.area, data.address, data.genre, data.url, data.sp_url, data.lat, data.lng, data.img_path, data.sid, data.level)
  
  
  
  
//  NSError *error = nil;
//  if (![_context save:&error]) {
//    LOG("error %@", error)
//  }
}

/* 利用記録データ */
- (NSArray *)fetchVisitData
{
  NSError *error = nil;
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"VisitData"];
  NSArray *fetchedArray = [_context executeFetchRequest:request error:&error];
//  LOG(@"fetchedArrary %@", [fetchedArray objectAtIndex:0])
//  LOG(@"fetchedArrary %@", [fetchedArray objectAtIndex:1])
//  LOG(@"fetchedArrary %@", [fetchedArray objectAtIndex:2])
  
  if (fetchedArray == nil) {
    LOG(@"fetch failure\n%@", [error localizedDescription])
    return fetchedArray;
  }
  return fetchedArray;
}


@end
