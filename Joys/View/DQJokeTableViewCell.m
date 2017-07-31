//
//  DQJokeTableViewCell.m
//  Joys
//
//  Created by OS10.11 on 16/4/24.
//  Copyright © 2016年 dq. All rights reserved.
//

#import "DQJokeTableViewCell.h"
#import <Masonry.h>

@implementation DQJokeTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentLabel = [UILabel new];
        [self.contentView addSubview:self.contentLabel];
        self.dateLabel = [UILabel new];
        [self.contentView addSubview:self.dateLabel];
        WK(weakSelf)
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(8);
            make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(12);
            make.bottom.mas_equalTo(weakSelf.dateLabel.mas_top).offset(-8);
            make.width.mas_equalTo(weakSelf.contentView.mas_width).offset(-30);
        }];
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(12);
            make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(-8);
            make.width.mas_equalTo(weakSelf.contentView.mas_width).offset(-60);
        }];
        self.contentLabel.textColor = [UIColor whiteColor];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.font = [UIFont systemFontOfSize:16];
        
        self.dateLabel.textColor = [UIColor colorWithRed:5/255.0 green:128/255.0 blue:100/255.0 alpha:1];
        self.dateLabel.font = [UIFont systemFontOfSize:12];
        
        self.collectingBtn = [UIButton new];
        [self.collectingBtn setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
        [self.collectingBtn setImage:[UIImage imageNamed:@"collection2"] forState:UIControlStateSelected];
        [self.contentView addSubview:self.collectingBtn];
        
        [self.collectingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(-10);
            make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-10);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        self.selectionStyle =  UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
