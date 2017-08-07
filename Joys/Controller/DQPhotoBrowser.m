//
//  DQPhoto.m
//  Joys
//
//  Created by 邓琼 on 2017/8/7.
//  Copyright © 2017年 tarena. All rights reserved.
//

#import "DQPhotoBrowser.h"

@interface DQPhotoBrowser ()

@end

@implementation DQPhotoBrowser

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.navigationController.viewControllers objectAtIndex:0] == self) {
        UIBarButtonItem *extroBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"collection"] style:UIBarButtonItemStylePlain target:self action:@selector(extroButtonPressed:)];
        self.navigationItem.leftBarButtonItem = extroBtn;
    }
}
- (void)extroButtonPressed:(id)sender {
    [_myDelegate didClickExtroButton];
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
