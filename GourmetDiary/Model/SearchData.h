//
//  SearchData.h
//  GourmetDiary
//
//  Created by Tomohiko on 2014/11/12.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SearchData : NSManagedObject

@property (nonatomic, retain) NSString * shop;
@property (nonatomic, retain) NSString * area;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lng;

@end
