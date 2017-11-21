//
//  TodaySaleListCollectionViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2017/3/1.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "TodaySaleListCollectionViewCell.h"
#import "UIImageView+ImageViewCategory.h"
@implementation TodaySaleListCollectionViewCell
- (void)updateTodaySaleListCellWithModel:(TodaySaleListModel *)tempModel {
    
    [self.todaySaleListImageView setWebImageURLWithImageUrlStr:tempModel.p_icon withErrorImage:[UIImage imageNamed:@""] withIsCenter:YES];


    self.todaySaleListTitleLabel.text = tempModel.p_name;
//    self.todaySaleListCompanyLabel.text = @"";
    self.todaySaleListFormatLabel.text = tempModel.s_standard;
    self.todaySaleListPriceLabel.text = [NSString stringWithFormat:@"￥%@", tempModel.d_price];
    
    if ([tempModel.d_activity_id isEqualToString:@"0"]) {
        //没有活动
        self.saleImageView.hidden = YES;
    }else {
        //有活动
        self.saleImageView.hidden = NO;

    }
    
}

@end
