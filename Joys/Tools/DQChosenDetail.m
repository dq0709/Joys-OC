//
//  DQChosenDetail.m
//  Joys
//
//  Created by dq on 16/4/12.
//  Copyright © 2016年 dq. All rights reserved.
//

#import "DQChosenDetail.h"

@implementation DQChosenDetail
+ (instancetype)chosenDetailWith:(id)responseObject {
    DQChosenDetail *detail = [[DQChosenDetail alloc]init];
    detail.body = responseObject[@"body"];
    detail.css = [responseObject[@"css"] firstObject];
    return detail;
}
@end
