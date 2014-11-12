//
//  TYGourmetDialyManager.m
//  GourmetDiary
//
//  Created by Tomohiko on 2014/11/12.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import "TYGourmetDialyManager.h"
#import "SearchData.h"

@implementation TYGourmetDialyManager {
  SearchData *_searchData;
}

static TYGourmetDialyManager *sharedInstance = nil;

+ (TYGourmetDialyManager *)sharedmanager
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
    
  }
  return self;
}

- (void)loadManagedObjectContext
{
  if (_context != nil) return;
  
  NSPersistentStoreCoordinator *aCoodinator = [self coordinator];
  if (aCoodinator != nil) {
    _context = [[NSManagedObjectContext alloc] init];
    [_context setPersistentStoreCoordinator:aCoodinator];
  }
}

- (NSPersistentStoreCoordinator *)coordinator
{
  if (_coordinator != nil) {
    return _coordinator;
  }
  NSURL *modelURL = [NSURL fileURLWithPath:[NSFileManager defaultManager].currentDirectoryPath];
  modelURL = [modelURL URLByAppendingPathComponent:@"GourmetDialy"];
  NSError *error = nil;
  _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjetModel]];
  if (![_coordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:modelURL options:nil error:&error]) {
    abort();
  }
  return _coordinator;
}

- (NSManagedObjectModel *)managedObjetModel {
  if (_managedObjetModel != nil) {
    return _managedObjetModel;
  }
  NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"GourmetDialy" ofType:@"momd"];
  NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
  _managedObjetModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  
  return _managedObjetModel;
}

- (void)addData:(NSDictionary *)data
{
  LOG(@"data: %@", data)
}

@end
