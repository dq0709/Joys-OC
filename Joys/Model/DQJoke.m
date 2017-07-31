//
//  DQJoke.m
//  HappyLife
//
//  Created by dq on 16/3/26.
//  Copyright © 2016年 dq. All rights reserved.
//

#import "DQJoke.h"
#import "DQDBManager.h"

@implementation DQJoke

+(NSArray *)getJokesDataWith:(id)responseObject {
    NSArray *dataArray = responseObject[@"result"][@"data"];
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        DQJoke *joke = [[DQJoke alloc]init];
        joke.content = dict[@"content"];
        joke.updatetime = dict[@"updatetime"];
        joke.hashId = dict[@"hashId"];
        if (joke.content.length > 1) {
            [array addObject:joke];
        }
    }
    return [array copy];
}

- (BOOL)isCollectedInDB {
    FMDatabase *database = [DQDBManager sharedDatabase];
    NSString *sqlStr = [NSString stringWithFormat:@"select * from joke where hashId = '%@'", self.hashId];
    FMResultSet *resultSet = [database executeQueryWithFormat: sqlStr, nil];
    if ([resultSet next]) {
        return YES;
    } else {
        return NO;
    }
}
+ (NSArray *)getAllJokesFromDB {
    FMDatabase *database = [DQDBManager sharedDatabase];
    FMResultSet *resultSet = [database executeQuery:@"select * from joke"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    while ([resultSet next]) {
        DQJoke *joke = [self new];
        joke.hashId = [resultSet stringForColumn:@"hashId"];
        joke.content = [resultSet stringForColumn:@"content"];
        joke.updatetime = [resultSet stringForColumn:@"updatetime"];
        [mutableArray addObject:joke];
    }
    [database close];
    return [mutableArray copy];
}

+ (BOOL)insertJokeToDB:(DQJoke *)joke {
    FMDatabase *database = [DQDBManager sharedDatabase];
    NSString *str = [NSString stringWithFormat:@"insert into joke (hashId, content, updatetime) values ('%@', '%@', '%@')", joke.hashId, joke.content, joke.updatetime];
    BOOL isSuccess = [database executeUpdateWithFormat: str, nil];
    [database close];
    return isSuccess;
}

+ (BOOL)removeJoke:(NSString *)hashId {
    FMDatabase *database = [DQDBManager sharedDatabase];
    NSString *str = [NSString stringWithFormat:@"delete from joke where hashId = '%@'", hashId];
    BOOL isSuccess = [database executeUpdateWithFormat:str, nil];
    [database close];
    return isSuccess;
}


@end
