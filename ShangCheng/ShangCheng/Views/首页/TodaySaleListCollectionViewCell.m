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
    
    [self.todaySaleListImageView setWebImageURLWithImageUrlStr:@"" withErrorImage:[UIImage imageNamed:@""]];
//    if (<#condition#>) {
//        <#statements#>
//    }

    self.todaySaleListTitleLabel.text = tempModel.p_name;
//    self.todaySaleListCompanyLabel.text = @"";
    self.todaySaleListFormatLabel.text = tempModel.s_standard;
    self.todaySaleListPriceLabel.text = tempModel.d_price;
    
}

@end
