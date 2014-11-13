//
//  TYGourmetDiaryManager.h
//  GourmetDiary
//
//  Created by Tomohiko on 2014/11/12.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface TYGourmetDiaryManager : NSObject

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSPersistentStoreCoordinator *coordinator;
@property (nonatomic, strong) NSManagedObjectModel *managedObjetModel;

+ (TYGourmetDiaryManager *)sharedmanager;
- (void)addData:(NSDictionary *)data;
- (void)resetData;
- (NSArray *)fetchData;

@end
