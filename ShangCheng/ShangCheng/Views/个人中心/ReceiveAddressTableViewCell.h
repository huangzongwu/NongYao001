//
//  ReceiveAddressTableViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2016/12/29.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexButton.h"
#import "ReceiveAddressModel.h"

typedef void(^RightNextBlock)(NSIndexPath *rightNextBlock);
@interface ReceiveAddressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *receiverAndMobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiveAddressLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectImageWidthLayout;
@property (weak, nonatomic) IBOutlet IndexButton *rightNextButton;
//点击后边的按钮block
@property (nonatomic,copy) RightNextBlock rightNextBlock;

- (void)updateReceiveAddressCell:(ReceiveAddressModel *)receiveAddressModel withIndex:(NSIndexPath *)cellIndex;



@end
