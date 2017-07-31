//
//  ChosenLeftMenu.h
//  Joys
//
//  Created by dq on 16/4/7.
//  Copyright © 2016年 dq. All rights reserved.
//  精选   主题列表

#import <Foundation/Foundation.h>

@interface DQChosenLeftMenu : NSObject

/**id**/
@property (nonatomic, copy)NSString *ID;
/**标题**/
@property (nonatomic, copy)NSString *name;
/**主题图片**/
@property (nonatomic, copy)NSString *imageURL;

+ (NSArray *) getChosenLeftMenuListWith:(id)responseObject;
@end
