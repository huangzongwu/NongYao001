//
//  MineCollectionViewCellOne.m
//  ShangCheng
//
//  Created by TongLi on 2016/11/2.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "MineCollectionViewCellOne.h"
#import "Manager.h"
#import "UIImageView+ImageViewCategory.h"
@implementation MineCollectionViewCellOne
- (void)updateMineCollectionViewCellOne {
    Manager *manager = [Manager shareInstance];
    self.userHeaderImageView.image = [UIImage imageNamed:@"test.png"];
    self.myNameLabel.text = @"未登录";
    self.myAreaAndPhoneLabel.hidden = YES;
    self.myTypeImageView.hidden = YES;
    self.memberManagerButton.hidden = YES;
    
    if ([manager isLoggedInStatus] == YES) {
        //已经登录了。
        //图片
        [self.userHeaderImageView setWebImageURLWithImageUrlStr:manager.memberInfoModel.u_icon withErrorImage:[UIImage imageNamed:@"test.png"]];
        
        self.myNameLabel.text = manager.memberInfoModel.u_truename;
        self.myAreaAndPhoneLabel.hidden = NO;
        self.myAreaAndPhoneLabel.text = [NSString stringWithFormat:@"%@",manager.memberInfoModel.u_mobile];

        if ([manager.memberInfoModel.u_type isEqualToString:@"1"]) {
            //代理商显示，其余的都不显示
            self.myTypeImageView.hidden = NO;
        }
        self.memberManagerButton.hidden = NO;
    }
    
}

@end
