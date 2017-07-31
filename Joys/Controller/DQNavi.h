//
//  DQNavi.h
//  Joys
//
//  Created by dq on 16/4/19.
//  Copyright © 2016年 dq. All rights reserved.
//

#import <WMPageController/WMPageController.h>


@interface DQNavi : WMPageController
//内容页的首页应该是单例的，每次进程都只初始化一次
+ (UINavigationController *)standardTuWanNavi;

@end
