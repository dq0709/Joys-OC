//
//  ChosenLeftMenu.m
//  Joys
//
//  Created by dq on 16/4/7.
//  Copyright © 2016年 dq. All rights reserved.
//

#import "DQChosenLeftMenu.h"

@implementation DQChosenLeftMenu
+ (NSArray *)getChosenLeftMenuListWith:(id)responseObject {
    NSArray *dataArray = responseObject[@"data"];
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        DQChosenLeftMenu *item = [[DQChosenLeftMenu alloc]init];
        item.ID = dict[@"id"];
        item.name = dict[@"name"];
        item.imageURL = dict[@"thumbnail"];
        [array addObject:item];
    }
    return [array copy];
}
@end
