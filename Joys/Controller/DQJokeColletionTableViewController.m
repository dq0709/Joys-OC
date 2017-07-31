//
//  DQJokeColletionTableViewController.m
//  Joys
//
//  Created by dq on 16/4/24.
//  Copyright © 2016年 dq. All rights reserved.
//

#import "DQJokeColletionTableViewController.h"
#import "DQJoke.h"
#import "UIView+HUD.h"

@interface DQJokeColletionTableViewController ()
@property (nonatomic, strong)NSArray *jokesArray;
@end

@implementation DQJokeColletionTableViewController

- (NSArray *)jokesArray {
    if (!_jokesArray) {
        _jokesArray = [DQJoke getAllJokesFromDB];
    }
    return _jokesArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的段子";
    self.tableView.estimatedRowHeight = 60;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:SCREEN_BOUNDS];
    imageView.image = [UIImage imageNamed:@"bgImage_640x1136_2"];
    self.tableView.backgroundView = imageView;
    
    if (self.jokesArray.count == 0) {
        [self.tableView showWarning:@"您还没有收藏哦~"];
    }
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
    return self.jokesArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"colletedJoke"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"colletedJoke"];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor =  [UIColor colorWithRed:5/255.0 green:128/255.0 blue:100/255.0 alpha:1];
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        cell.textLabel.numberOfLines = 0;
        cell.backgroundColor = [UIColor clearColor];
    }
    DQJoke *joke =  self.jokesArray[indexPath.row];
    cell.textLabel.text = joke.content;
    cell.detailTextLabel.text = joke.updatetime;
    return cell;
}

#pragma mark - 删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self deletePoemAtIndexPath:indexPath];
    }];
    return @[action];
}

- (void)deletePoemAtIndexPath:(NSIndexPath *)indexPath {
    DQJoke *joke = self.jokesArray[indexPath.row];
    //创建UIAlertController
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除该收藏" message:@"确定删除该条收藏吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //删除对应的收藏
        if ([DQJoke removeJoke:joke.hashId]) {
            //更新数据源
            self.jokesArray = [DQJoke getAllJokesFromDB];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        }
    }];
    [alert addAction:cancel];
    [alert addAction:done];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
