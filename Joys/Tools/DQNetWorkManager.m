//
//  DQNetWorkManager.m
//  HappyLife
//
//  Created by dq on 16/3/26.
//  Copyright © 2016年 dq. All rights reserved.
//

#import "DQNetWorkManager.h"
#import <AFNetworking.h>

@implementation DQNetWorkManager
+(void)sendRequestWithUrl:(NSString *)urlStr parameters:(NSDictionary *)params success:(void (^)(id))successBlock failure:(void (^)(NSError *))failureBlock {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/plain", @"text/json", @"text/javascript", @"application/json", nil];
    [manager GET:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error);
    }];
}

@end
