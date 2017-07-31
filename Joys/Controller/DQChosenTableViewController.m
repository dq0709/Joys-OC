//
//  DQChosenTableViewController.m
//  Joys
//
//  Created by dq on 16/4/8.
//  Copyright © 2016年 dq. All rights reserved.
//

#import "DQChosenTableViewController.h"
#import "DQNetWorkManager.h"
#import "DQChosenDaily.h"
#import "DQChosen.h"
#import "DQChosenTableViewCell.h"
#import <RESideMenu/RESideMenu.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <MJRefresh.h>
#import <Masonry.h>
#import "DQChosenLeftMenuTableViewController.h"
#import "DQChosenThemeTableViewController.h"
#import "DQChosenDetailViewController.h"
#import "ScrollableView.h"
#import "DQChosenHeader.h"
#import "UINavigationBar+Awesome.h"

#define NAVBAR_CHANGE_POINT 20

@interface DQChosenTableViewController ()
@property (nonatomic, strong)NSMutableArray< DQChosenDaily *> *dataArray;
@property (nonatomic, strong)NSString *date;
@property (nonatomic, strong)ScrollableView *headerView;
@end

@implementation DQChosenTableViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    self.sideMenuViewController.navigationItem.title = @"精选";
    self.sideMenuViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoLeftMenu:)];
    
    [self sendRequestAndSetupHeader];
    
    WK(weakSelf)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.dataArray removeAllObjects];
        [weakSelf sendRequest];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf sendRequest];
    }];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 推出左侧菜单
- (void)gotoLeftMenu:(NSArray *)menuArray {
    DQChosenLeftMenuTableViewController *menuVC = (DQChosenLeftMenuTableViewController *)self.sideMenuViewController.leftMenuViewController;
    WK(weakSelf)
    menuVC.chooseItemBlock = ^(DQChosenLeftMenu *theme) {
        [weakSelf.sideMenuViewController hideMenuViewController];
        DQChosenThemeTableViewController *themeVC = [DQChosenThemeTableViewController new];
        themeVC.theme = theme;
        [weakSelf.sideMenuViewController.navigationController pushViewController:themeVC animated:YES];
    };
    [self.sideMenuViewController presentLeftMenuViewController];
}
#pragma mark - 请求数据
- (void)sendRequest {
    DQChosenDaily *daily = self.dataArray.lastObject;
    self.date = daily.date;
    NSString *url = self.date ? [NSString stringWithFormat:@"%@%@", requestBeforeDataURL, self.date] : requestLatestDataURL;
    WK(weakSelf)
    [DQNetWorkManager sendRequestWithUrl:url parameters:nil success:^(id responseObject) {
        DQChosenDaily *daily = [DQChosenDaily chosenDailyWith:responseObject];
        [weakSelf.dataArray addObject:daily];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [weakSelf.tableView showWarning:@"您的网络不给力！"];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}
//头视图
- (void)sendRequestAndSetupHeader {
    WK(weakSelf)
    [DQNetWorkManager sendRequestWithUrl:requestHotData parameters:nil success:^(id responseObject) {
         weakSelf.headerView = [[ScrollableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.7) imageURLs:[DQChosenHeader headerImagesWith:responseObject] andTitles:[DQChosenHeader headerTitlesWith:responseObject]];
        [weakSelf.headerView startAutoScroll];
        NSArray *news = [DQChosenHeader headerNewsWith:responseObject];
        weakSelf.headerView.didTap_block = ^(ScrollableView *sv, NSInteger currentIndex) {
            DQChosenDetailViewController *chosenDetailVC = [DQChosenDetailViewController new];
            chosenDetailVC.chosen = news[currentIndex];
            chosenDetailVC.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:chosenDetailVC animated:YES];
        };
        weakSelf.tableView.tableHeaderView = weakSelf.headerView;
    } failure:^(NSError *error) {
        [weakSelf.view showWarning:@"您的网络不给力！"];
    }];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UIColor * color = [UIColor colorWithRed:132/255.0 green:175/255.0 blue:109/255.0 alpha:1];
    CGFloat height = self.tableView.tableHeaderView.bounds.size.height;
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = 1 - ((NAVBAR_CHANGE_POINT + height - offsetY - 64) / height);
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self scrollViewDidScroll:self.tableView];
    [self.headerView stopScroll];
    [self.headerView startAutoScroll];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.headerView stopScroll];
    [self.navigationController.navigationBar lt_reset];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    DQChosenDaily *daily = self.dataArray[section];
    return daily.chosenItems.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DQChosenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChosenCell"];
    if (cell == nil) {
        cell = [[DQChosenTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChosenCell"];
    }
    DQChosenDaily *daily = self.dataArray[indexPath.section];
    DQChosen *chosenItem = daily.chosenItems[indexPath.row];
    cell.mainLabel.text = chosenItem.title;
    [cell.mainImageView sd_setImageWithURL:[NSURL URLWithString:chosenItem.imageURL] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CHOSEN_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DQChosenDaily *daily = self.dataArray[indexPath.section];
    DQChosen *chosenItem = daily.chosenItems[indexPath.row];
    DQChosenDetailViewController *chosenDetailVC = [DQChosenDetailViewController new];
    chosenDetailVC.chosen = chosenItem;
    chosenDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chosenDetailVC animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSInteger date = [self.dataArray[section].date integerValue];
    NSString *title = [NSString stringWithFormat:@"%02ld-%02ld-%02ld", date/10000, (date%10000)/100, date%100];
    return title;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    view.backgroundColor = [UIColor colorWithRed:132/255.0 green:154/255.0 blue:109/255.0 alpha:0.8];
    NSInteger date = [self.dataArray[section].date integerValue];
    NSString *title = [NSString stringWithFormat:@"%02ld-%02ld-%02ld", date/10000, (date%10000)/100, date%100];
    UILabel *label = [[UILabel alloc]init];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = title;
    return view;
}
/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
