//
//  DQChosenLeftMenuTableViewController.h
//  Joys
//
//  Created by dq on 16/4/7.
//  Copyright © 2016年 dq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DQChosenLeftMenu.h"

@interface DQChosenLeftMenuTableViewController : UITableViewController
@property (nonatomic, strong)void(^ chooseItemBlock)(DQChosenLeftMenu *);
@end
