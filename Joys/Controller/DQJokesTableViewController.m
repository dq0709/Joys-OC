//
//  DQJokesTableViewController.m
//  HappyLife
//
//  Created by dq on 16/3/26.
//  Copyright © 2016年 dq. All rights reserved.
//

#import "DQJokesTableViewController.h"
#import "DQJoke.h"
#import "DQNetWorkManager.h"
#import <MJRefresh/MJRefresh.h>
#import "UIView+HUD.h"
#import "DQJokeTableViewCell.h"
#import "DQJokeColletionTableViewController.h"

#import <AFNetworking/AFNetworking.h>

@interface DQJokesTableViewController ()
/**请求页数**/
@property (nonatomic, assign)NSInteger page;
/**存储数据**/
@property (nonatomic, strong)NSMutableArray *jokesArray;
@end

@implementation DQJokesTableViewController

- (NSMutableArray *)jokesArray {
    if (!_jokesArray) {
        _jokesArray = [NSMutableArray array];
    }
    return _jokesArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"段子";
    self.page = 1;
    self.tableView.estimatedRowHeight = 60;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:SCREEN_BOUNDS];
    imageView.image = [UIImage imageNamed:@"bgImage_640x1136_2"];
    self.tableView.backgroundView = imageView;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"collection2"] style:UIBarButtonItemStylePlain target:self action:@selector(showMyCollection)];
    
    WK(weakSelf)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf.jokesArray removeAllObjects];
        [weakSelf sendRequest];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page += 1;
        [weakSelf sendRequest];
    }];
    [self.tableView.mj_header beginRefreshing];
}


- (void)sendRequest {
    NSString *urlStr = @"http://japi.juhe.cn/joke/content/text.from";
    NSDictionary *param = @{
                            @"page":[NSNumber numberWithInteger:self.page],
                            @"pagesize":@20,
                            @"key":@"890608324a834555dac961cc5a95370b"
                            };
    WK(weakSelf)
    [DQNetWorkManager sendRequestWithUrl:urlStr parameters:param success:^(id responseObject) {
        //调用数据管理类的方法，解析网络流
        weakSelf.jokesArray = [[weakSelf.jokesArray arrayByAddingObjectsFromArray:[DQJoke getJokesDataWith:responseObject]] mutableCopy];
        [weakSelf endRefresh];
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [weakSelf endRefresh];
        NSLog(@"%@",error.localizedDescription);
        [weakSelf.tableView showWarning:@"您的网络不给力！"];
    }];
}
- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.jokesArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DQJokeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JokeCell"];
    if (cell == nil) {
        cell = [[DQJokeTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"JokeCell"];
    }
    DQJoke *joke = self.jokesArray[indexPath.row];
    cell.contentLabel.text = joke.content;
    cell.dateLabel.text =  joke.updatetime;
    cell.collectingBtn.selected = [joke isCollectedInDB];
    cell.collectingBtn.tag = indexPath.row;
    [cell.collectingBtn addTarget:self action:@selector(collectionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionBtnClicked:(UIButton *)sender {
    //操作数据库
    DQJoke *joke =  self.jokesArray[sender.tag];
    if (!sender.selected) {
        BOOL success = [DQJoke insertJokeToDB:joke];
        success ? [self.tableView showWarning:@"收藏成功"] : [self.tableView showWarning:@"收藏失败"];
        sender.selected = success ? YES : NO;
    } else {
        BOOL success = [DQJoke removeJoke:joke.hashId];
        success ? [self.tableView showWarning:@"取消收藏成功"] : [self.tableView showWarning:@"取消收藏失败"];
        sender.selected = success ? NO : YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

#pragma mark - collection

- (void)showMyCollection {
    DQJokeColletionTableViewController *jokeColletion = [DQJokeColletionTableViewController new];
    jokeColletion.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:jokeColletion animated:YES];
}

@end
