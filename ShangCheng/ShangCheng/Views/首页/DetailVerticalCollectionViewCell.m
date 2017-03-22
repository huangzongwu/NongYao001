//
//  DetailVerticalCollectionViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2016/10/28.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "DetailVerticalCollectionViewCell.h"
#import "UIImageView+ImageViewCategory.h"
@implementation DetailVerticalCollectionViewCell
- (void)updateDetailVerticalCollectionViewCell:(ProductModel *)tempProductModel withIsHideCompanyLabel:(BOOL)isHideCompanyLabel {
    
    [self.productImageView setWebImageURLWithImageUrlStr:tempProductModel.productImageUrlstr withErrorImage:[UIImage imageNamed:@"productImage"]];
    
    //是否显示活动角标
    if (tempProductModel.isSaleProduct == YES) {
        self.saleImageView.hidden = NO;
    }else {
        self.saleImageView.hidden = YES;
    }
    
    self.productTitleLabel.text = tempProductModel.productTitle;
    //有的cell没有公司，有的cell有。所以要判断
    if (isHideCompanyLabel == YES) {
        self.productCompanyLabel.hidden = YES;
        self.companyLabelHeightLayout.constant = 0;
    }else {
        self.productCompanyLabel.hidden = NO;
        self.companyLabelHeightLayout.constant = 17;
    }
    self.productCompanyLabel.text = tempProductModel.productCompany;
    self.productFormatLabel.text = tempProductModel.productFormatStr;
    self.productPriceLabel.text = [NSString stringWithFormat:@"￥%@", tempProductModel.productPrice ];
    
    
}

@end
