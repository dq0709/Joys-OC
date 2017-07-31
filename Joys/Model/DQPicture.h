//
//  DQPicture.h
//  Joys
//
//  Created by dq on 16/4/18.
//  Copyright © 2016年 dq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DQPicture : NSObject
@property (nonatomic, copy)NSString *ID;
@property (nonatomic, copy)NSString *url;
/**高度**/
@property (nonatomic, assign)CGFloat height;
/**宽度**/
@property (nonatomic, assign)CGFloat width;

+ (NSArray *)getPicturesDataWith:(id)responseObject;

+ (NSString *)getURLWithType:(NSInteger)infoType sumNum:(NSInteger)num;

+ (NSArray *)getAllPicturesFromDB;
- (BOOL)isCollectedInDB;
+ (BOOL)insertPictureToDB:(DQPicture *)picture;
+ (BOOL)removePicure:(NSString *)ID;

@end
