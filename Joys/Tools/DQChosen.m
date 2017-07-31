//
//  DQChosen.m
//  Joys
//
//  Created by dq on 16/4/7.
//  Copyright © 2016年 dq. All rights reserved.
//

#import "DQChosen.h"
#import "DQDBManager.h"

@implementation DQChosen
+(NSArray *)getChosenDataWith:(id)responseObject {
    NSArray *array = responseObject[@"stories"];
    NSMutableArray *chosenData = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        DQChosen *chosen = [DQChosen new];
        chosen.ID = dic[@"id"];
        chosen.imageURL = dic[@"images"][0];
        chosen.title = dic[@"title"];
        [chosenData addObject:chosen];
    }
    return [chosenData copy];
}

//sqlite
- (BOOL)isCollectedInDB {
    FMDatabase *database = [DQDBManager sharedDatabase];
    NSString *sqlStr = [NSString stringWithFormat:@"select * from chosen where C_ID = '%@'", self.ID];
    FMResultSet *resultSet = [database executeQueryWithFormat: sqlStr, nil];
    if ([resultSet next]) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSArray *)getAllChosensFromDB {
    FMDatabase *database = [DQDBManager sharedDatabase];
    FMResultSet *resultSet = [database executeQuery:@"select * from chosen"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    while ([resultSet next]) {
        DQChosen *chosen = [self new];
        chosen.ID = [resultSet stringForColumn:@"C_ID"];
        chosen.title = [resultSet stringForColumn:@"title"];
        chosen.imageURL = [resultSet stringForColumn:@"imageURL"];
        [mutableArray addObject:chosen];
    }
    [database close];
    return [mutableArray copy];
}

+ (BOOL)insertChosenToDB:(DQChosen *)chosen {
    FMDatabase *database = [DQDBManager sharedDatabase];
    NSString *str = [NSString stringWithFormat:@"insert into chosen (C_ID, title, imageURL) values ('%@', '%@', '%@')", chosen.ID, chosen.title, chosen.imageURL];
    BOOL isSuccess = [database executeUpdateWithFormat:str, nil];
    [database close];
    return isSuccess;
}

+(BOOL)removeChosen:(NSString *)ID {
    FMDatabase *database = [DQDBManager sharedDatabase];
    NSString *str = [NSString stringWithFormat:@"delete from chosen where C_ID = '%@'", ID];
    BOOL isSuccess = [database executeUpdateWithFormat:str, nil];
    [database close];
    return isSuccess;
}

@end
