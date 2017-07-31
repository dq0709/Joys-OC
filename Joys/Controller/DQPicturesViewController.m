//
//  DQPicturesViewController.m
//  HappyLife
//
//  Created by dq on 16/3/25.
//  Copyright © 2016年 dq. All rights reserved.
//

#import "DQPicturesViewController.h"
#import "DQNetWorkManager.h"
#import "UIView+HUD.h"
#import "DQPicture.h"
#import <PSCollectionView.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <MJRefresh.h>
#import <Masonry.h>
#import <MWPhotoBrowser/MWPhotoBrowser.h>
#import "DQNavi.h"


@interface DQPicturesViewController () <UIScrollViewDelegate, PSCollectionViewDelegate, PSCollectionViewDataSource, MWPhotoBrowserDelegate>
@property (nonatomic, strong)PSCollectionView *collectionView;
@property (nonatomic, strong)NSMutableArray *picturesArray;
@property (nonatomic, assign)NSInteger sumNumber;

@property (nonatomic, strong) MWPhotoBrowser *browser;
@end

@implementation DQPicturesViewController

- (NSMutableArray *)picturesArray {
    if (!_picturesArray) {
        _picturesArray = [NSMutableArray array];
    }
    return _picturesArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView = [[PSCollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44)];
    self.collectionView.backgroundColor = [UIColor colorWithRed:132/255.0 green:175/255.0 blue:109/255.0 alpha:0.3];
    self.collectionView.delegate = self;
    self.collectionView.collectionViewDelegate = self;
    self.collectionView.collectionViewDataSource = self;
    [self.view addSubview:self.collectionView];
    //设置竖向 两行
    self.collectionView.numColsPortrait = 2;
    
    WK(weakSelf)
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.sumNumber = 1;
        [weakSelf.picturesArray removeAllObjects];
        [weakSelf sendRequest];
    }];
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.sumNumber += 1;
        [weakSelf sendRequest];
    }];
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark - 网络请求
- (void)sendRequest {
    WK(weakSelf)
    [DQNetWorkManager sendRequestWithUrl:[DQPicture getURLWithType:self.infoType sumNum:self.sumNumber] parameters:nil success:^(id responseObject) {
        weakSelf.picturesArray = [[weakSelf.picturesArray arrayByAddingObjectsFromArray:[DQPicture getPicturesDataWith:responseObject]] mutableCopy];
        [weakSelf.collectionView reloadData];
        [weakSelf endRefresh];
    } failure:^(NSError *error) {
        [weakSelf.view showWarning:@"您的网络不给力！"];
        [weakSelf endRefresh];
        NSLog(@"%@",error);
    }];
}
- (void)endRefresh {
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}
#pragma mark - collectionView
- (NSInteger)numberOfRowsInCollectionView:(PSCollectionView *)collectionView{
    return self.picturesArray.count;
}
- (CGFloat)collectionView:(PSCollectionView *)collectionView heightForRowAtIndex:(NSInteger)index {
    DQPicture *pic = self.picturesArray[index];
    CGFloat width =pic.width;
    CGFloat height = pic.height;
    return (SCREEN_HEIGHT/2 -16) *height/width;
}

- (PSCollectionViewCell *)collectionView:(PSCollectionView *)collectionView cellForRowAtIndex:(NSInteger)index{
    PSCollectionViewCell *cell = [collectionView dequeueReusableViewForClass:[PSCollectionViewCell class]];
    if (!cell) {
        cell = [[PSCollectionViewCell alloc] initWithFrame:CGRectZero];
        UIImageView *imageView=[UIImageView new];
        imageView.backgroundColor = [UIColor lightGrayColor];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        [cell addSubview:imageView];
        imageView.tag = 100;
    }
    UIImageView *iv = (UIImageView *)[cell viewWithTag:100];
    [iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    DQPicture *pic = self.picturesArray[index];
    [iv sd_setImageWithURL:[NSURL URLWithString:pic.url]];
    return cell;
}

- (void)collectionView:(PSCollectionView *)collectionView didSelectCell:(PSCollectionViewCell *)cell atIndex:(NSInteger)index {
    self.browser  = [[MWPhotoBrowser alloc] initWithDelegate:self];
    self.browser.zoomPhotosToFill = YES;
    self.browser.enableSwipeToDismiss = YES;
    [self.browser setCurrentPhotoIndex:index];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:self.browser];
    [self presentViewController:nc animated:YES completion:nil];
}

#pragma mark - MWPhotoBrowserDelegate
- (void)didClickExtroButton {
    //点中 收藏
    DQPicture *picture = self.picturesArray[self.browser.currentIndex];
    if ([picture isCollectedInDB]) {
        [self.browser.view showWarning:@"您已经收藏过此图片"];
        return;
    }
    BOOL success = [DQPicture insertPictureToDB:picture];
    success ? [self.browser.view showWarning:@"收藏成功"]:[self.browser.view showWarning:@"收藏失败"];
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.picturesArray.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.picturesArray.count) {
        DQPicture *pic = self.picturesArray[index];
        return [MWPhoto photoWithURL:[NSURL URLWithString:pic.url]];
    }
    return nil;
}


@end
