//
//  AfterMarketTwoTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2017/3/22.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import "AfterMarketTwoTableViewCell.h"
#import "SonOrderModel.h"
#import "UIImageView+ImageViewCategory.h"
@implementation AfterMarketTwoTableViewCell

- (void)updateAfterMarketTwoCellWithModel:(SupOrderModel *)tempModel {
    
    self.orderCodeLabel.text = tempModel.p_code;
    self.orderStatusLabel.text = tempModel.statusvalue;
    
    //看看有多少个子订单，模式都显示
    self.productImageViewOne.hidden = NO;
    [self.productImageViewOne setWebImageURLWithImageUrlStr:@"" withErrorImage:[UIImage imageNamed:@"productImage"]];
    self.productImageViewTwo.hidden = NO;
    [self.productImageViewTwo setWebImageURLWithImageUrlStr:@"" withErrorImage:[UIImage imageNamed:@"productImage"]];

    self.productImageViewThree.hidden = NO;
    self.productImageViewFour.hidden = NO;
    
    switch (tempModel.subOrderArr.count) {
        case 2:
            self.productImageViewThree.hidden = YES;
            self.productImageViewFour.hidden = YES;
            break;
        case 3:
            self.productImageViewFour.hidden = YES;
            [self.productImageViewThree setWebImageURLWithImageUrlStr:@"" withErrorImage:[UIImage imageNamed:@"productImage"]];

            break;
        case 4:
            [self.productImageViewThree setWebImageURLWithImageUrlStr:@"" withErrorImage:[UIImage imageNamed:@"productImage"]];
            [self.productImageViewFour setWebImageURLWithImageUrlStr:@"" withErrorImage:[UIImage imageNamed:@"productImage"]];

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
