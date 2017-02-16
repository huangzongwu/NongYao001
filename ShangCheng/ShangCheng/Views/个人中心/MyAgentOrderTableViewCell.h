//
//  MyAgentOrderTableViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2017/2/15.
//  Copyright © 2017年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Manager.h"
@interface MyAgentOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *orderHeaderImageView;
@property (weak, nonatomic) IBOutlet UILabel *orderNameAndPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderAgentMoneyLabel;//收益


@property (weak, nonatomic) IBOutlet UIImageView *orderOneImageView;
@property (weak, nonatomic) IBOutlet UIImageView *orderTwoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *orderThreeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *orderFourImageView;
@property (weak, nonatomic) IBOutlet UIImageView *orderFiveImageView;


@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTotalMoneyLabel;//总价

- (void)updateMyAgentOrderCellWithAgentModel:(MyAgentOrderModel *)tempModel ;

@end
