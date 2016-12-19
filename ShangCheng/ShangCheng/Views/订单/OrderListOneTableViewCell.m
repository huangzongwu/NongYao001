//
//  OrderListOneTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/8.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "OrderListOneTableViewCell.h"

@implementation OrderListOneTableViewCell
- (void)updateOrderLIstOneCellWithModel:(SupOrderModel *)model withWhichTableView:(NSString *)whichTableView withCellIndex:(NSIndexPath *)cellIndex {

    self.selectOrderButton.indexForButton = cellIndex;
    //看看是那个TableView，只有第二个TableView，且状态为0或者1B 才会有选中button。否则就没有选中button
    if ([whichTableView isEqualToString:@"2"]) {
        if ([model.p_status isEqualToString:@"0"] || [model.p_status isEqualToString:@"1B"]) {
            self.selectButtonWidthLayout.constant = 20;
        }else {
            self.selectButtonWidthLayout.constant = 0;
        }
    }else {
        self.selectButtonWidthLayout.constant = 0;
    }
    
    
    //这个产品是否被选
    if (model.isSelectOrder == YES) {
        self.selectOrderButton.backgroundColor = [UIColor redColor];
    }else {
        self.selectOrderButton.backgroundColor = [UIColor lightGrayColor];
    }
    
    self.orderNumberLabel.text = model.p_code;
    //待付款
    if ([model.p_status isEqualToString:@"0"] || [model.p_status isEqualToString:@"1B"] ) {
        self.orderStateLabel.text = @"待付款";
    }
    //待确认（属于待付款）
    if ([model.p_status isEqualToString:@"1A"]) {
        self.orderStateLabel.text = @"待确认";
    }
    //进行中
    if ([model.p_status isEqualToString:@"1"] ) {
        self.orderStateLabel.text = @"进行中";
    }
    //已完成
    if ([model.p_status isEqualToString:@"9"]) {
        self.orderStateLabel.text = @"已完成";
    }
    
    
//    产品信息
//    子订单，即产品
    SonOrderModel *sonOrderModel = model.subOrderArr[0];
    
    self.productNameLabel.text = sonOrderModel.p_name;
    self.productFormatLabel.text = sonOrderModel.productst;
//    self.productCompany.text = sonOrderModel.;
    
    
    self.productCountLabel.text = [NSString stringWithFormat:@"共%ld件商品", model.subOrderArr.count];
    self.orderPriceLabel.text = [NSString stringWithFormat:@"￥%@", model.p_o_price_total];
    
    if (model.isSelectOrder == YES) {
        self.selectOrderButton.backgroundColor = [UIColor redColor];
    }else {
        self.selectOrderButton.backgroundColor = [UIColor lightGrayColor];
    }

}


- (IBAction)selectButtonAction:(IndexButton *)sender {
    NSLog(@"%ld",sender.indexForButton.section);
    self.selectButtonBlock(sender);
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
