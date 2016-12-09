//
//  OrderListFootOneTableViewCell.h
//  ShangCheng
//
//  Created by TongLi on 2016/12/8.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexButton.h"
@interface OrderListFootOneTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet IndexButton *orderPayButton;
@property (weak, nonatomic) IBOutlet IndexButton *orderCancelButton;

@end
