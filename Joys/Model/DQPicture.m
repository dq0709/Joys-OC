//
//  DQPicture.m
//  Joys
//
//  Created by dq on 16/4/18.
//  Copyright © 2016年 dq. All rights reserved.
//

#import "DQPicture.h"
#import "DQDBManager.h"

@implementation DQPicture
+ (NSArray *)getPicturesDataWith:(id)responseObject {
    NSArray *dataArray = responseObject[@"data"];
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        DQPicture *pic = [DQPicture new];
        pic.ID = [dict[@"id"] stringValue];
        pic.url = dict[@"url"];
        pic.height = [dict[@"height"] doubleValue];
        pic.width = [dict[@"width"] doubleValue];
        [array addObject:pic];
    }
    
    return [array copy];
}

+ (NSString *)getURLWithType:(NSInteger)infoType sumNum:(NSInteger)num{
    switch (infoType) {
        case 0:
            return [[NSString stringWithFormat:@"http://mapp.tiankong.com/search?key=搞笑&pageNum=%ld&pageSize=20", num] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            break;
        case 1:
            return [[NSString stringWithFormat:@"http://mapp.tiankong.com/search?key=摄影&pageNum=%ld&pageSize=20", num] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            break;
        case 2:
            return [[NSString stringWithFormat:@"http://mapp.tiankong.com/search?key=小清新&pageNum=%ld&pageSize=20", num] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            break;
        case 3:
            return [[NSString stringWithFormat:@"http://mapp.tiankong.com/search?key=壁纸&pageNum=%ld&pageSize=20", num] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            break;
        case 4:
            return [[NSString stringWithFormat:@"http://mapp.tiankong.com/search?key=动漫&pageNum=%ld&pageSize=20", num] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            break;
        case 5:
            return [[NSString stringWithFormat:@"http://mapp.tiankong.com/search?key=宠物&pageNum=%ld&pageSize=20", num] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            break;
        case 6:
            return [[NSString stringWithFormat:@"http://mapp.tiankong.com/search?key=风景&pageNum=%ld&pageSize=20", num] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            break;
        default:
            return nil;
            break;
    }
}

+ (NSArray *)getAllPicturesFromDB {
    FMDatabase *database = [DQDBManager sharedDatabase];
    FMResultSet *resultSet = [database executeQuery:@"select * from picture"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    while ([resultSet next]) {
        DQPicture *pic = [self new];
        pic.ID = [resultSet stringForColumn:@"C_ID"];
        pic.url = [resultSet stringForColumn:@"url"];
        pic.width = [resultSet doubleForColumn:@"width"];
        pic.height = [resultSet doubleForColumn:@"height"];
        [mutableArray addObject:pic];
    }
    [database close];
    return [mutableArray copy];
}

- (BOOL)isCollectedInDB {
    FMDatabase *database = [DQDBManager sharedDatabase];
    NSString *sqlStr = [NSString stringWithFormat:@"select * from picture where C_ID = '%@'", self.ID];
    FMResultSet *resultSet = [database executeQueryWithFormat: sqlStr, nil];
    if ([resultSet next]) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)insertPictureToDB:(DQPicture *)picture {
    FMDatabase *database = [DQDBManager sharedDatabase];
    NSString *str = [NSString stringWithFormat:@"insert into picture (C_ID, url, width, height) values ('%@', '%@', %lf, %lf)", picture.ID, picture.url, picture.width, picture.height];
    BOOL isSuccess = [database executeUpdateWithFormat:str, nil];
    [database close];
    return isSuccess;
}

+ (BOOL)removePicure:(NSString *)ID {
    FMDatabase *database = [DQDBManager sharedDatabase];
    NSString *str = [NSString stringWithFormat:@"delete from picture where C_ID = '%@'", ID];
    BOOL isSuccess = [database executeUpdateWithFormat:str, nil];
    [database close];
    return isSuccess;
}

@end
