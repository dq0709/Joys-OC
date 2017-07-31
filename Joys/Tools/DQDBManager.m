//
//  DQDBManager.m
//  Joys
//
//  Created by OS10.11 on 16/4/23.
//  Copyright © 2016年 dq. All rights reserved.
//

#import "DQDBManager.h"

@implementation DQDBManager
+ (FMDatabase *)sharedDatabase {
    //使用GCD的一次性任务实现两个逻辑
    static FMDatabase *database = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //1.移动数据库文件到/Documents/sqlite.db
        NSString *atPath = [[NSBundle mainBundle] pathForResource:@"Joys.db" ofType:nil];
        NSString *toPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"sqlite.db"];
        NSError *error = nil;
        if (![[NSFileManager defaultManager] fileExistsAtPath:toPath]) {
            [[NSFileManager defaultManager] copyItemAtPath:atPath toPath:toPath error:&error];
        }
        if (!error) {
            database = [FMDatabase databaseWithPath:toPath];
        }
    });
    [database open];
    return database;
}

@end
