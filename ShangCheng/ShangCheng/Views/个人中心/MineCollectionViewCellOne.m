//
//  MineCollectionViewCellOne.m
//  ShangCheng
//
//  Created by TongLi on 2016/11/2.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "MineCollectionViewCellOne.h"
#import "Manager.h"
@implementation MineCollectionViewCellOne
- (void)updateMineCollectionViewCellOne {
    Manager *manager = [Manager shareInstance];
    
    self.myNameLabel.text = @"未登录";
    self.myAreaAndPhoneLabel.hidden = YES;
    self.myTypeImageView.hidden = YES;
    self.memberManagerButton.hidden = YES;
    
    if ([manager isLoggedInStatus] == YES) {
        //已经登录了。
        self.myNameLabel.text = manager.memberInfoModel.u_truename;
        self.myAreaAndPhoneLabel.hidden = NO;
        self.myAreaAndPhoneLabel.text = [NSString stringWithFormat:@"%@",manager.memberInfoModel.u_mobile];
        self.myTypeImageView.hidden = NO;
//        self.myTypeImageView = ;
        self.memberManagerButton.hidden = NO;
    }
    
}

@end
