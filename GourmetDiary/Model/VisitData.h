//
//  VisitData.h
//  GourmetDiary
//
//  Created by Tomohiko on 2014/11/16.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ShopMst;

@interface VisitData : NSManagedObject

@property (nonatomic, retain) NSString * sid;
@property (nonatomic, retain) NSDate * visited_at;
@property (nonatomic, retain) NSString * memo;
@property (nonatomic, retain) NSNumber * situation;
@property (nonatomic, retain) NSNumber * fee;
@property (nonatomic, retain) NSNumber * persons;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) ShopMst *diary;

@end
