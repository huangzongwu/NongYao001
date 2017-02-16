//
//  TradeRecordTableViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2017/2/8.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Manager.h"
@interface TradeRecordTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tradeTypeImageView;
@property (weak, nonatomic) IBOutlet UILabel *tradeMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradeDetailLabel;

- (void)updateTradeRecordCellWithModel:(MyTradeRecordModel *)tradeRecordModel;


@end
