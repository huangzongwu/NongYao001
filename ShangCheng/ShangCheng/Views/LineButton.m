//
//  LineButton.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/6.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "LineButton.h"

@implementation LineButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    self.line = [[UIView alloc] initWithFrame:CGRectMake(0, rect.size.height-2, rect.size.width, 2)];
    self.line.backgroundColor = [UIColor redColor];
    [self addSubview:self.line];
    
}


@end
