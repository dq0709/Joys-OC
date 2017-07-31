//
//  DQChosenTableViewCell.m
//  Joys
//
//  Created by dq on 16/4/11.
//  Copyright © 2016年 dq. All rights reserved.
//

#import "DQChosenTableViewCell.h"
#import <Masonry.h>

@implementation DQChosenTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.mainLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.mainLabel];
        self.mainImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:self.mainImageView];
        
        WK(weakSelf)
        [self.mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.mas_top).offset(8);
            make.left.mas_equalTo(weakSelf.mas_left).offset(20);
            make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(-30);
            make.width.mas_equalTo(weakSelf.mas_width).offset(- CHOSEN_CELL_HEIGHT - 44);
            make.right.mas_equalTo(weakSelf.mainImageView.mas_left).offset(-16);
        }];
        [self.mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.mas_top).offset(8);
            make.height.mas_equalTo(CHOSEN_CELL_HEIGHT - 16);
            make.width.mas_equalTo(CHOSEN_CELL_HEIGHT - 12);
        }];
        self.mainLabel.textColor = [UIColor whiteColor];
        self.mainLabel.numberOfLines = 0;
        self.mainLabel.font = [UIFont systemFontOfSize:18];
        
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
