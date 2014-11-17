//
//  ShopMst.h
//  GourmetDiary
//
//  Created by Tomohiko on 2014/11/16.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ShopMst : NSManagedObject

@property (nonatomic, retain) NSString * shop;
@property (nonatomic, retain) NSString * shop_kana;
@property (nonatomic, retain) NSString * area;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * genre;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * sp_url;
@property (nonatomic, retain) NSString * tel;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lng;
@property (nonatomic, retain) NSString * img_path;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSString * sid;
@property (nonatomic, retain) NSSet *master;
@end

@interface ShopMst (CoreDataGeneratedAccessors)

- (void)addMasterObject:(NSManagedObject *)value;
- (void)removeMasterObject:(NSManagedObject *)value;
- (void)addMaster:(NSSet *)values;
- (void)removeMaster:(NSSet *)values;

@end
