//
//  SelectProductViewController.m
//  ShangCheng
//
//  Created by TongLi on 2016/11/30.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "SelectProductViewController.h"
#import "Manager.h"
#import "IndexButton.h"
#define kButtonW (kScreenW-40)/3
#define kButtonH 20

@interface SelectProductViewController ()

@property (weak, nonatomic) IBOutlet UILabel *productTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *productCountLabel;

@property (weak, nonatomic) IBOutlet UIView *scrollViewContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewContentHeightLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countTitleLabelYLayout;


@end

@implementation SelectProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   //创建button
    for (int i = 0; i < self.productDetailModel.productFarmatArr.count; i++) {
        
        IndexButton *formatButton = [[IndexButton alloc] initWithFrame:CGRectMake(10 + i%3*(kButtonW + 10), 35+20 + i/3*(kButtonH + 10), kButtonW, 20)];
        formatButton.indexForButton = [NSIndexPath indexPathForRow:i inSection:0];
        formatButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [formatButton addTarget:self action:@selector(formatButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        formatButton.backgroundColor = [UIColor redColor];
        [self.scrollViewContentView addSubview:formatButton];
        
        ProductFormatModel *formatModel = self.productDetailModel.productFarmatArr[i];
        [formatButton setTitle:formatModel.productst forState:UIControlStateNormal];
        if (formatModel.isSelect == YES) {
            formatButton.backgroundColor = [UIColor cyanColor];
            //刷新产品个数
            self.productCountLabel.text = [NSString stringWithFormat: @"%ld",formatModel.seletctCount];
        }
        
    }
    
    //更新UI
    [self upSelectViewWith:self.productDetailModel];
    
}

//更新标题和价格
- (void)upSelectViewWith:(ProductDetailModel *)detailModel {
    
    self.productTitleLabel.text = detailModel.productModel.productTitle;
    self.productPriceLabel.text = detailModel.productModel.productPrice;
}

//页面将要显示，
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //修改约束
    NSInteger buttonNum = self.productDetailModel.productFarmatArr.count+7;

    self.countTitleLabelYLayout.constant = 20 + (buttonNum-1)/3*(kButtonH + 10)+kButtonH +20;
    
    self.scrollViewContentHeightLayout.constant = 35 + self.countTitleLabelYLayout.constant+55+20;

}


//关闭button
- (IBAction)dismissButtonAction:(UIButton *)sender {
    //block刷新详情页的UI
    self.refreshFormatBlock();
    [self dismissViewControllerAnimated:YES completion:nil];
}

//选择某个规格的buttonAction
- (void)formatButtonAction:(IndexButton *)sender {
    //清理所有的button颜色
    for (UIView *tempButton in sender.superview.subviews) {
        if ([tempButton isKindOfClass:[IndexButton class]]) {
            tempButton.backgroundColor = [UIColor redColor];
        }
    }
    //选中的改变颜色
    sender.backgroundColor = [UIColor cyanColor];
    
    //清理所有的模型bool选择
    for (ProductFormatModel *tempFormatModel in self.productDetailModel.productFarmatArr) {
        tempFormatModel.isSelect = NO;
    }
    //改变选中的那个模型的bool值
    ProductFormatModel *selectFormatModel = self.productDetailModel.productFarmatArr[sender.indexForButton.row];
    selectFormatModel.isSelect = YES;
    
    NSLog(@"%@",selectFormatModel.s_id);
    
    //将最新的和规格有关的数据 赋给ProductModel模型
    //规格id
    self.productDetailModel.productModel.productFormatID = selectFormatModel.s_id;
    //规格字符串
    self.productDetailModel.productModel.productFormatStr = selectFormatModel.productst;
    //价格
    self.productDetailModel.productModel.productPrice = selectFormatModel.s_price;
    //最小起订数量
    self.productDetailModel.p_standard_qty = selectFormatModel.s_min_quantity;
    //图片

    
    //刷新UI
    [self upSelectViewWith:self.productDetailModel];
    
    //刷新数量ui
    self.productCountLabel.text = [NSString stringWithFormat:@"%ld", selectFormatModel.seletctCount];
    
}



//减少数量按钮
- (IBAction)lessProductNumberAction:(UIButton *)sender {
    for (ProductFormatModel *tempModel in self.productDetailModel.productFarmatArr) {
        //选择的是这个规格
        if (tempModel.isSelect == YES) {
            //修改数量
            if (tempModel.seletctCount <= [tempModel.s_min_quantity integerValue]) {
                NSLog(@"不能少于起订数量");
            }else {
                tempModel.seletctCount--;
                
                //刷新个数UI
                self.productCountLabel.text = [NSString stringWithFormat:@"%ld",tempModel.seletctCount];
            }
            
        }
    }
}

//增加数量按钮
- (IBAction)addProductNumberAction:(UIButton *)sender {
    for (ProductFormatModel *tempModel in self.productDetailModel.productFarmatArr) {
        //选择的是这个规格
        if (tempModel.isSelect == YES) {
            //修改数量
            tempModel.seletctCount++;
                
            //刷新个数UI
            self.productCountLabel.text = [NSString stringWithFormat:@"%ld",tempModel.seletctCount];
            
            
        }
    }

    
}
//确认加入购物车
- (IBAction)enterButtonAction:(UIButton *)sender {
    

    NSString *tempProductCount ;
    
    //如果是从产品详情中加入购物车
        for (ProductFormatModel *tempFormatModel in self.productDetailModel.productFarmatArr) {
            if (tempFormatModel.isSelect == YES) {
                tempProductCount = [NSString stringWithFormat:@"%ld",tempFormatModel.seletctCount];
            }
        }
    
    [[Manager shareInstance] httpProductToShoppingCarWithFormatId:self.productDetailModel.productModel.productFormatID withProductCount:tempProductCount withSuccessToShoppingCarResult:^(id successResult) {
        //发送通知，让购物车界面刷新
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshShoppingCarVC" object:self userInfo:nil];
    } withFailToShoppingCarResult:^(NSString *failResultStr) {
        NSLog(@"加入失败");
    }];
    
    
//    [[Manager shareInstance] httpProductToShoppingCarWithJoinShoppingCarProductModel:self.productDetailModel withSuccessToShoppingCarResult:^(id successResult) {
//        //发送通知，让购物车界面刷新
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshShoppingCarVC" object:self userInfo:nil];
//        
//    } withFailToShoppingCarResult:^(NSString *failResultStr) {
//        NSLog(@"bbb");
//
//    }];
    
    //block刷新详情页的UI
    self.refreshFormatBlock();
    [self dismissViewControllerAnimated:YES completion:nil];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
