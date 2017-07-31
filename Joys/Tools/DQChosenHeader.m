//
//  DQChosenHeader.m
//  Joys
//
//  Created by dq on 16/4/13.
//  Copyright © 2016年 dq. All rights reserved.
//

#import "DQChosenHeader.h"
#import "DQChosen.h"

#define MAX_IMAGECOUNT 6

@implementation DQChosenHeader

+ (NSArray *)headerNewsWith:(id)responseObject {
    NSArray *array = responseObject[@"recent"];
    NSMutableArray *headerNewsIDs = [NSMutableArray array];
    NSInteger index = array.count >= MAX_IMAGECOUNT ? MAX_IMAGECOUNT : array.count;
    for (int i = 0; i < index; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        DQChosen *news = [DQChosen new];
        news.ID = dic[@"news_id"];
        news.title = dic[@"title"];
        news.imageURL = dic[@"thumbnail"];
        [headerNewsIDs addObject:news];
    }
    return [headerNewsIDs copy];
}

+ (NSArray *)headerImagesWith:(id)responseObject {
    NSArray *array = responseObject[@"recent"];
    NSMutableArray *headerImages = [NSMutableArray array];
    NSInteger index = array.count >= MAX_IMAGECOUNT ? MAX_IMAGECOUNT : array.count;
    for (int i = 0; i < index; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        NSString *imageURL = dic[@"thumbnail"];
        [headerImages addObject:imageURL];
    }
    return [headerImages copy];
}

+ (NSArray *)headerTitlesWith:(id)responseObject {
    NSArray *array = responseObject[@"recent"];
    NSMutableArray *headerTitles = [NSMutableArray array];
    NSInteger index = array.count >= MAX_IMAGECOUNT ? MAX_IMAGECOUNT : array.count;
    for (int i = 0; i < index; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        NSString *headerTitle = dic[@"title"];
        [headerTitles addObject:headerTitle];
    }
    return [headerTitles copy];
}

@end
