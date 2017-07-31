//
//  DQNavi.m
//  Joys
//
//  Created by dq on 16/4/19.
//  Copyright © 2016年 dq. All rights reserved.
//

#import "DQNavi.h"
#import "DQPicturesViewController.h"
#import "DQPicCollectionViewController.h"

@interface DQNavi ()

@end

@implementation DQNavi

//单例模式创建controller对象
+ (UINavigationController *)standardTuWanNavi{
    static UINavigationController *navi = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DQNavi *vc = [[DQNavi alloc] initWithViewControllerClasses:[self viewControllerClasses] andTheirTitles:[self itemNames]];
        vc.keys = [[self vcKeys] copy];
        vc.values = [[self vcValues] copy];
        navi = [[UINavigationController alloc] initWithRootViewController:vc];
    });
    return navi;
}

- (void)showMyCollection {
    DQPicCollectionViewController *picCollection = [DQPicCollectionViewController new];
    picCollection.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:picCollection animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"美图";
    self.view.backgroundColor = [UIColor colorWithRed:153/255.0 green:191/255.0 blue:125/255.0 alpha:1];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"collection2"] style:UIBarButtonItemStylePlain target:self action:@selector(showMyCollection)];
}

/** 提供每个VC对应的value值数组 */
+ (NSArray *)vcValues{
    NSMutableArray *arr = [NSMutableArray new];
    for (int i = 0; i <[self itemNames].count; i++) {
        //数值上，vc的infoType的枚举值 恰好和i值相同
        [arr addObject:@(i)];
    }
    return [arr copy];
}
/** 提供每个VC对应的key值数组 */
+ (NSArray *)vcKeys{
    NSMutableArray *arr = [NSMutableArray new];
    for (id obj in [self itemNames]) {
        [arr addObject:@"infoType"];
    }
    return [arr copy];
}

/** 提供题目数组 */
+ (NSArray *)itemNames{
    return @[@"搞笑",@"摄影",@"小清新",@"壁纸",@"动漫",@"宠物", @"风景"];
}
/** 提供每个题目对应的控制器的类型。题目和类型数量必须一致 */
+ (NSArray *)viewControllerClasses{
    NSMutableArray *arr = [NSMutableArray new];
    for (id obj in [self itemNames]) {
        [arr addObject:[DQPicturesViewController class]];
    }
    return [arr copy];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
