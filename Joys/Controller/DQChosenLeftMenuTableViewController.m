//
//  DQChosenLeftMenuTableViewController.m
//  Joys
//
//  Created by dq on 16/4/7.
//  Copyright © 2016年 dq. All rights reserved.
//

#import "DQChosenLeftMenuTableViewController.h"
#import "DQNetWorkManager.h"
#import "UIView+HUD.h"


@interface DQChosenLeftMenuTableViewController ()
@property (nonatomic, strong)NSArray *menuArray;
@end

@implementation DQChosenLeftMenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 44, 0);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    WK(weakSelf)
    [DQNetWorkManager sendRequestWithUrl:requestThemes parameters:nil success:^(id responseObject) {
        weakSelf.menuArray = [DQChosenLeftMenu getChosenLeftMenuListWith:responseObject];
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [weakSelf.view showWarning:@"您的网络不给力！"];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MENU"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MENU"];
        cell.textLabel.textColor = [UIColor colorWithRed:5/255.0 green:128/255.0 blue:100/255.0 alpha:1];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"t%ld.png",indexPath.row%8]];
    DQChosenLeftMenu *item = self.menuArray[indexPath.row];
    cell.textLabel.text = item.name;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.chooseItemBlock(self.menuArray[indexPath.row]);
}

@end
