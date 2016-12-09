//
//  ProductDetailOneTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2016/11/25.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "ProductDetailOneTableViewCell.h"

@implementation ProductDetailOneTableViewCell

- (void)updateProductDetailOneCellWithDic:(ProductDetailModel *)productDetailModel withIndex:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
            self.titleLabel.text = @"产品分类";
            self.contentLabel.text = productDetailModel.p_typevalue1;
            break;
        case 1:
            self.titleLabel.text = @"产品编号";
            self.contentLabel.text = productDetailModel.p_pid;
            break;
        case 2:
            self.titleLabel.text = @"产品规格";
            self.contentLabel.text = productDetailModel.productModel.productFormatStr;
            break;
        case 3:
            self.titleLabel.text = @"有效成分";
            self.contentLabel.text = productDetailModel.p_ingredient;
            break;
        case 4:
            self.titleLabel.text = @"推荐起订数量";
            self.contentLabel.text = productDetailModel.p_standard_qty;
            break;
        case 5:
            self.titleLabel.text = @"生产厂家";
            self.contentLabel.text = productDetailModel.productModel.productCompany;
            break;
        case 6:
            self.titleLabel.text = @"PD证";
            self.contentLabel.text = productDetailModel.p_registration;
            break;
        case 7:
            self.titleLabel.text = @"产品标准证";
            self.contentLabel.text = productDetailModel.p_certificate;
            break;
        case 8:
            self.titleLabel.text = @"生产许可证";
            self.contentLabel.text = productDetailModel.p_license;
            break;
        case 9:
            self.titleLabel.text = @"发布时间";
            self.contentLabel.text = productDetailModel.p_time_create;
            break;
        case 10:
            self.titleLabel.text = @"防治对象";
            self.contentLabel.text = productDetailModel.p_treatment;
            break;
            
        default:
            break;
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
