//
//  DQChosenDayily.h
//  Joys
//
//  Created by dq on 16/4/11.
//  Copyright © 2016年 dq. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DQChosen;
@interface DQChosenDaily : NSObject
@property (nonatomic, strong)NSArray<DQChosen *> *chosenItems;
@property (nonatomic, strong)NSString *date;

+ (instancetype)chosenDailyWith:(id)responseObject;
@end
