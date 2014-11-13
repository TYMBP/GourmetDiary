//
//  TYGourmetDialyManager.m
//  GourmetDiary
//
//  Created by Tomohiko on 2014/11/12.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import "TYGourmetDiaryManager.h"
#import "SearchData.h"

@implementation TYGourmetDiaryManager {
  SearchData *_searchData;
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
  }
}

- (void)addData:(NSDictionary *)data
{
//  LOG(@"data: %@", data)
  for (_n = 0; _n < 3; _n++) {
    _searchData = (SearchData *)[NSEntityDescription insertNewObjectForEntityForName:@"SearchData" inManagedObjectContext:_context];
    if (_searchData == nil) {
      return;
    }
    _searchData.shop = [[data valueForKeyPath:@"results.shop.name"] objectAtIndex:_n];
    _searchData.category = [[data valueForKeyPath:@"results.shop.genre.name"] objectAtIndex:_n];
    _searchData.area = [[data valueForKeyPath:@"results.shop.small_area.name"] objectAtIndex:_n];
    NSString *lat = [[data valueForKeyPath:@"results.shop.lat"] objectAtIndex:_n];
    _searchData.lat = [NSNumber numberWithDouble:[lat doubleValue]];
    NSString *lng = [[data valueForKeyPath:@"results.shop.lng"] objectAtIndex:_n];
    _searchData.lng = [NSNumber numberWithDouble:[lng doubleValue]];
//    LOG(@"n %d shop: %@, category:%@, area:%@ lat:%@, lng:%@", _n, _searchData.shop, _searchData.category, _searchData.area, _searchData.lat, _searchData.lng)
    NSError *error = nil;
    if (![_context save:&error]) {
      LOG("error %@", error)
    }
  }
}

//データ取得
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


@end
