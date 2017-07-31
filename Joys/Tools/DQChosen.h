//
//  DQChosen.h
//  Joys
//
//  Created by dq on 16/4/7.
//  Copyright © 2016年 dq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DQChosen : NSObject
/** id **/
@property (nonatomic, copy)NSString *ID;
/** 标题 **/
@property (nonatomic, copy)NSString *title;
/** 图片网址 **/
@property (nonatomic, copy)NSString *imageURL;

+(NSArray *)getChosenDataWith:(id)responseObject;

- (BOOL)isCollectedInDB;
+ (NSArray *)getAllChosensFromDB;
+ (BOOL)insertChosenToDB:(DQChosen *)chosen;
+ (BOOL)removeChosen:(NSString *)ID;
@end
