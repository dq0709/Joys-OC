//
//  DQChosenThemeTableViewController.m
//  Joys
//
//  Created by dq on 16/4/12.
//  Copyright © 2016年 dq. All rights reserved.
//

#import "DQChosenThemeTableViewController.h"
#import "DQChosenTableViewCell.h"
#import "DQChosen.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DQNetWorkManager.h"
#import "UIView+HUD.h"
#import "DQChosenDetailViewController.h"

@interface DQChosenThemeTableViewController ()
@property (nonatomic, strong)NSArray *dataArray;
@end

@implementation DQChosenThemeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.theme.name;
    self.tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    self.tableView.backgroundColor = [UIColor clearColor];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:SCREEN_BOUNDS];
    imageView.image = [UIImage imageNamed:@"bgImage_640x1136_2"];
    self.tableView.backgroundView = imageView;
    [self setupHeaderView];
    [self sendRequest];
}
#pragma mark -  设置头视图
- (void)setupHeaderView {
//    self.tabBarController.viewControllers[2];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH - 20)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.theme.imageURL] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
    self.tableView.tableHeaderView = imageView;
}

#pragma mark - 发送网络请求
- (void)sendRequest {
    WK(weakSelf)
    [DQNetWorkManager sendRequestWithUrl:[NSString stringWithFormat:@"%@%@", requestThemeData, self.theme.ID] parameters:nil success:^(id responseObject) {
        weakSelf.dataArray = [DQChosen getChosenDataWith:responseObject];
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [weakSelf.tableView showWarning:@"您的网络不给力！"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DQChosenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThemeCell"];
    if (cell == nil) {
        cell = [[DQChosenTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ThemeCell"];
    }
    DQChosen *chosen = self.dataArray[indexPath.row];
    cell.mainLabel.text = chosen.title;
    [cell.mainImageView sd_setImageWithURL:[NSURL URLWithString:chosen.imageURL] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CHOSEN_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DQChosen *chosen = self.dataArray[indexPath.row];
    DQChosenDetailViewController *chosenDetailVC = [DQChosenDetailViewController new];
    chosenDetailVC.chosen = chosen;
    chosenDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chosenDetailVC animated:YES];
}

@end
