//
//  DQChosenDetailViewController.m
//  Joys
//
//  Created by dq on 16/4/12.
//  Copyright © 2016年 dq. All rights reserved.
//

#import "DQChosenDetailViewController.h"
#import "DQNetWorkManager.h"
#import "UIView+HUD.h"
#import "DQChosenDetail.h"

@interface DQChosenDetailViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong)UIWebView *webView;
@property (nonatomic, assign)CGFloat lastContentOffset;
@end

@implementation DQChosenDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.webView = [[UIWebView alloc]initWithFrame:SCREEN_BOUNDS];
    [self.view addSubview:self.webView];
    self.webView.scrollView.delegate = self;
    self.webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.webView.multipleTouchEnabled = YES;
    self.webView.userInteractionEnabled = YES;
    self.webView.scalesPageToFit=YES;
    self.webView.scrollView.bounces = NO;
    [self sendRequest];
    
}

- (void)sendRequest {
    [DQNetWorkManager sendRequestWithUrl:[NSString stringWithFormat:@"%@%@", requestNewsURL, self.chosen.ID] parameters:nil success:^(id responseObject) {
        DQChosenDetail *chosenDetail = [DQChosenDetail chosenDetailWith:responseObject];
        if (chosenDetail.body) {
            NSString *strHead = @"<html> <head><style type=\"text/css\">div{font-size: 48px}h2 {font-size: 68px; color: #006000}div.question {background:#859B6E}body {color:white; background:#859B6E}img{width:100%; height:auto}span{font-size: 38px}img.avatar{width: 100px; height:100px;border-radius:50%; overflow:hidden}</style></head><body><br>";
            NSString *strFoot = @"</body></html>";
            [self.webView loadHTMLString:[NSString stringWithFormat:@"%@%@%@", strHead, chosenDetail.body, strFoot] baseURL:nil];
        } else {
            [self.view showWarning:@"您查看的内容不存在"];
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        }
    } failure:^(NSError *error) {
        [self.view showWarning:@"您的网络不给力！"];
    }];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView*)scrollView{
    self.lastContentOffset = scrollView.contentOffset.y;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > self.lastContentOffset) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    } else {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.lastContentOffset == 0) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
