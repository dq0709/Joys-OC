//
//  DQJoke.h
//  HappyLife
//
//  Created by dq on 16/3/26.
//  Copyright © 2016年 dq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DQJoke : NSObject
/* 标识*/
@property (nonatomic, copy)NSString *hashId;
/**内容**/
@property (nonatomic, copy)NSString *content;
/**更新时间**/
@property (nonatomic, copy)NSString *updatetime;

@property (nonatomic, assign)BOOL collected;

+(NSArray *)getJokesDataWith:(id)responseObject;


- (BOOL)isCollectedInDB;
+ (NSArray *)getAllJokesFromDB;
+ (BOOL)insertJokeToDB:(DQJoke *)joke;
+ (BOOL)removeJoke:(NSString *)hashId;
@end
