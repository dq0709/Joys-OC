//
//  DQDBManager.h
//  Joys
//
//  Created by OS10.11 on 16/4/23.
//  Copyright © 2016年 dq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface DQDBManager : NSObject
+ (FMDatabase *)sharedDatabase;
@end
