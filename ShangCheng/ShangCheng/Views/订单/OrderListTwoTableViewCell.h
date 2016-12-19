//
//  OrderListTwoTableViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2016/12/8.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SupOrderModel.h"
#import "IndexButton.h"
typedef void(^SelectButtonBlock)(IndexButton *selectButton);

@interface OrderListTwoTableViewCell : UITableViewCell
//选中的button
@property (weak, nonatomic) IBOutlet IndexButton *selectOrderButton;
@property (nonatomic,strong)SelectButtonBlock selectButtonBlock;

//选择button的宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectButtonWidthLayout;

//订单号
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
//订单状态
@property (weak, nonatomic) IBOutlet UILabel *orderStateLabel;
//产品展示的视图，多个产品有多个ImageView
@property (weak, nonatomic) IBOutlet UIView *productContentView;
//scrollView的宽度。和产品的个数有关系
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *productContentViewWidthLayout;
//产品数量
@property (weak, nonatomic) IBOutlet UILabel *productCountLabel;
//价格
@property (weak, nonatomic) IBOutlet UILabel *orderPriceLabel;


- (void)updateOrderLIstOneCellWithModel:(SupOrderModel *)model withWhichTableView:(NSString *)whichTableView withCellIndex:(NSIndexPath *)cellIndex;



@end
