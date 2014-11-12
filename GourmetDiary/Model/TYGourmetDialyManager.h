//
//  TYGourmetDialyManager.h
//  GourmetDiary
//
//  Created by Tomohiko on 2014/11/12.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface TYGourmetDialyManager : NSObject

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSPersistentStoreCoordinator *coordinator;
@property (nonatomic, strong) NSManagedObjectModel *managedObjetModel;

+ (TYGourmetDialyManager *)sharedmanager;
- (void)addData:(NSDictionary *)data;

@end
