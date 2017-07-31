//
//  DQChosenDetail.h
//  Joys
//
//  Created by dq on 16/4/12.
//  Copyright © 2016年 dq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DQChosenDetail : NSObject
/** 网页body **/
@property (nonatomic, copy)NSString *body;
/** css -- 未使用 **/
@property (nonatomic, copy)NSString *css;
+ (instancetype)chosenDetailWith:(id)responseObject;
@end
