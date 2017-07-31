//
//  DQPicCollectionViewController.m
//  Joys
//
//  Created by dq on 16/4/25.
//  Copyright © 2016年 dq. All rights reserved.
//

#import "DQPicCollectionViewController.h"
#import "DQPicture.h"
#import <PSCollectionView.h>
#import <MWPhotoBrowser.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <Masonry.h>

@interface DQPicCollectionViewController ()<UIScrollViewDelegate, PSCollectionViewDelegate, PSCollectionViewDataSource, MWPhotoBrowserDelegate>
@property (nonatomic, strong)NSArray *picturesArray;
@property (nonatomic, strong)PSCollectionView *collectionView;
@property (nonatomic, strong) MWPhotoBrowser *browser;
@end

@implementation DQPicCollectionViewController

- (NSArray *)picturesArray {
    if (!_picturesArray) {
        _picturesArray = [DQPicture getAllPicturesFromDB];
    }
    return _picturesArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的美图";
    
    self.collectionView = [[PSCollectionView alloc] initWithFrame:self.view.bounds];
    self.collectionView.backgroundColor = [UIColor colorWithRed:209/255.0 green:227/255.0 blue:200/255.0 alpha:1];
    self.collectionView.delegate = self;
    self.collectionView.collectionViewDelegate = self;
    self.collectionView.collectionViewDataSource = self;
    [self.view addSubview:self.collectionView];
    //设置竖向 两行
    self.collectionView.numColsPortrait = 2;
    
    if (self.picturesArray.count == 0) {
        [self.collectionView showWarning:@"您还没有收藏哦~"];
    }
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
    DQPicture *picture = self.picturesArray[self.browser.currentIndex];
    //弹框提示
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除该收藏" message:@"确定删除该条收藏吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //删除对应的收藏
        if ([DQPicture removePicure:picture.ID]) {
            //更新数据源
            self.picturesArray = [DQPicture getAllPicturesFromDB];
            [self.collectionView reloadData];
            [self.browser reloadData];
        }
    }];
    [alert addAction:cancel];
    [alert addAction:done];
    [self.browser presentViewController:alert animated:YES completion:nil];
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
