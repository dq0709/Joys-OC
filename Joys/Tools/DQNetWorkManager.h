//
//  DQNetWorkManager.h
//  HappyLife
//
//  Created by dq on 16/3/26.
//  Copyright © 2016年 dq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DQNetWorkManager : NSObject
+(void) sendRequestWithUrl:(NSString *)urlStr parameters:(NSDictionary *)params success:(void(^)(id responseObject))successBlock failure:(void(^)(NSError *error))failureBlock;

@end
