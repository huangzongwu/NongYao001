//
//  OrderListTwoTableViewCell.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/8.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "OrderListTwoTableViewCell.h"
#import "UIImageView+ImageViewCategory.h"
@implementation OrderListTwoTableViewCell
- (void)updateOrderLIstOneCellWithModel:(SupOrderModel *)model withWhichTableView:(NSString *)whichTableView withCellIndex:(NSIndexPath *)cellIndex {
    
    self.selectOrderButton.indexForButton = cellIndex;
    //看看是那个TableView，只有第二个TableView，且状态为0 才会有选中button。否则就没有选中button
    if ([whichTableView isEqualToString:@"2"]) {
        if ([model.p_status isEqualToString:@"0"] ) {
            self.selectButtonWidthLayout.constant = 25;
        }else {
            self.selectButtonWidthLayout.constant = 0;
        }
    }else {
        self.selectButtonWidthLayout.constant = 0;
    }
    
    
    //这个产品是否被选
    if (model.isSelectOrder == YES) {
        [self.selectOrderButton setImage:[UIImage imageNamed:@"g_btn_select"] forState:UIControlStateNormal];

    }else {
        [self.selectOrderButton setImage:[UIImage imageNamed:@"g_btn_normal"] forState:UIControlStateNormal];

    }
    
    self.orderNumberLabel.text = model.p_code;
    
    

    
    self.orderStateLabel.text = model.statusvalue;
  
    
    
    
    self.productCountLabel.text = [NSString stringWithFormat:@"共%ld件商品，", model.subOrderArr.count];
    self.orderPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[model.p_o_price_total floatValue] - [model.p_discount floatValue]];

    //首先清空原有的imageView
    for (UIView *tempImageView in self.productContentView.subviews) {
        if ([tempImageView isKindOfClass:[UIImageView class]]) {
            [tempImageView removeFromSuperview];
        }
    }
    
    
    
    //创建新的ImageView
    for (int i = 0; i < model.subOrderArr.count; i++) {
        UIImageView *tempProductImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10+(self.productContentView.bounds.size.height-10)*i, 10, self.productContentView.bounds.size.height-20, self.productContentView.bounds.size.height-20)];
        SonOrderModel *tempSonOrderModel = model.subOrderArr[i];
        tempProductImageView.image = [UIImage imageNamed:@"icon_pic_cp"];
        [tempProductImageView setWebImageURLWithImageUrlStr:tempSonOrderModel.p_icon withErrorImage:[UIImage imageNamed:@"icon_pic_cp"] withIsCenter:YES];
        [self.productContentView addSubview:tempProductImageView];
        //圆角
        tempProductImageView.layer.masksToBounds = YES;
        tempProductImageView.layer.cornerRadius = 4;
    }
    
    //scrollView的宽度，如果图片少，宽就是屏幕宽，
    CGFloat tempProductContentViewWidth = (self.productContentView.bounds.size.height-10)*model.subOrderArr.count+10;
    if (tempProductContentViewWidth < kScreenW) {
        tempProductContentViewWidth = kScreenW;
    }
    self.productContentViewWidthLayout.constant = tempProductContentViewWidth;
    
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
