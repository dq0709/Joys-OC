//
//  DQPhoto.h
//  Joys
//
//  Created by 邓琼 on 2017/8/7.
//  Copyright © 2017年 tarena. All rights reserved.
//

#import <MWPhotoBrowser/MWPhotoBrowser.h>

@protocol DQPhotoBrowserDelegate <MWPhotoBrowserDelegate>

- (void)didClickExtroButton;

@end

@interface DQPhotoBrowser : MWPhotoBrowser
@property (nonatomic, weak) id<DQPhotoBrowserDelegate> myDelegate;
@end
