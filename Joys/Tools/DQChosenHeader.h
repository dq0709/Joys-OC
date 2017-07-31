//
//  DQChosenHeader.h
//  Joys
//
//  Created by dq on 16/4/13.
//  Copyright © 2016年 dq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DQChosenHeader : NSObject
+ (NSArray *)headerNewsWith:(id)responseObject;
+ (NSArray *)headerImagesWith:(id)responseObject;
+ (NSArray *)headerTitlesWith:(id)responseObject;
@end
