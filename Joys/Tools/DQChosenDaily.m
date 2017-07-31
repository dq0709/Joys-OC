//
//  DQChosenDayily.m
//  Joys
//
//  Created by dq on 16/4/11.
//  Copyright © 2016年 dq. All rights reserved.
//

#import "DQChosenDaily.h"
#import "DQChosen.h"
#import "DQChosen.h"

@implementation DQChosenDaily
+ (instancetype)chosenDailyWith:(id)responseObject {
    DQChosenDaily *daily = [[DQChosenDaily alloc]init];
    daily.date = responseObject[@"date"];
    daily.chosenItems = [DQChosen getChosenDataWith:responseObject];
    return daily;
}
@end
