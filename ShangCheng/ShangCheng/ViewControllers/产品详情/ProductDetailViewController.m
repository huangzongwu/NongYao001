//
//  ProductDetailViewController.m
//  ShangCheng
//
//  Created by TongLi on 2016/11/25.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "SelectProductViewController.h"
#import "ProductDetailOneTableViewCell.h"
#import "ProductDetailHeaderTableViewCell.h"
#import "Manager.h"
@interface ProductDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
//产品图片轮播图
@property (weak, nonatomic) IBOutlet UIView *productImageContentView;
//产品图片轮播图宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageScrollViewWidthLayout;

//产品标题
@property (weak, nonatomic) IBOutlet UILabel *productTitleLabel;
//产品公司
@property (weak, nonatomic) IBOutlet UILabel *productCompanyLabel;
//产品规格
@property (weak, nonatomic) IBOutlet UILabel *productFormatLabel;
//产品价格
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;
//选择规格的Label
@property (weak, nonatomic) IBOutlet UILabel *selectFormatLabel;


@property (weak, nonatomic) IBOutlet UITableView *detailTableView;

@property (nonatomic,strong)ProductDetailModel *productDetailModel;



@end

@implementation ProductDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.productDetailModel = [[ProductDetailModel alloc] init];
    
    //获取产品详细信息
    [[Manager shareInstance] httpProductDetailInfoWithProductID:self.productID withProductDetailModel:self.productDetailModel withSuccessDetailResult:^(id successResult) {

        
        [self updateAllViewWithDetailModel:self.productDetailModel];
        
        //将第一个规格变成默认的规格
        [self selectOneFormatWithFormatID:self.productDetailModel.productModel.productFormatID];
        
//        //获取所有的规格数据
//        [[Manager shareInstance] httpProductAllFarmatInfoWithProductID:self.productID withProductDetailModel:self.productDetailModel withSuccessFarmatResult:^(id successResult) {
//            //        self.productDetailModel = successResult;
//            //通过id找到是那个规格
//            //将第一个规格变成默认的规格
//            [self selectOneFormatWithFormatID:self.productDetailModel.productModel.productFormatID];
//            
//        } withFailFarmatResult:^(NSString *failResultStr) {
//            NSLog(@"%@",failResultStr);
//            
//        }];
        
    } withFailDetailResult:^(NSString *failResultStr) {
        NSLog(@"%@",failResultStr);

    }];
    
    
}


- (void)updateAllViewWithDetailModel:(ProductDetailModel *)tempDetailModel {
    //刷新头部View
    [self upHeaderViewWithDetailModel:tempDetailModel];
    //刷新列表
    [self.detailTableView reloadData];

}
//通过规格id找到在规格数组中的哪个,然后刷新UI
- (void)selectOneFormatWithFormatID:(NSString *)formatID {

    for (ProductFormatModel *tempFormatModel in self.productDetailModel.productFarmatArr) {
        //现将所有的变为no
        tempFormatModel.isSelect = NO;
        //有一样的，说明选择的就是这个
        if ([tempFormatModel.s_id isEqualToString:formatID]) {
            tempFormatModel.isSelect = YES;
            //将最新的和规格有关的数据 赋给ProductModel模型
            //规格id
            self.productDetailModel.productModel.productFormatID = tempFormatModel.s_id;
            //规格字符串
            self.productDetailModel.productModel.productFormatStr = tempFormatModel.productst;
            //价格
            self.productDetailModel.productModel.productPrice = tempFormatModel.s_price;
            //最小起订数量
            self.productDetailModel.p_standard_qty = tempFormatModel.s_min_quantity;
            //图片
            
        }

    }
    //刷新ui
    [self updateAllViewWithDetailModel:self.productDetailModel];
    
    
}


- (void)upHeaderViewWithDetailModel:(ProductDetailModel *)tempDetailModel {
    //图片赋值
    //1、根据图片的个数，计算contentView的宽度
    
    
    self.productTitleLabel.text = tempDetailModel.productModel.productTitle;
    self.productCompanyLabel.text = tempDetailModel.productModel.productCompany;
    self.productFormatLabel.text = [NSString stringWithFormat:@"产品规格：%@", tempDetailModel.productModel.productFormatStr ];
    self.productPriceLabel.text = [NSString stringWithFormat:@"￥%@", tempDetailModel.productModel.productPrice];
    //刷新 选择规格 地方的UI
    self.selectFormatLabel.text = [NSString stringWithFormat:@"已选 \"%@\"",tempDetailModel.productModel.productFormatStr];
    
}

#pragma mark - tableView Delegate -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 11;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    ProductDetailHeaderTableViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"detailHeadView"];
    headerCell.backgroundColor = [UIColor redColor];
    return headerCell;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProductDetailOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailOneCell" forIndexPath:indexPath];
    
    [cell updateProductDetailOneCellWithDic:self.productDetailModel withIndex:indexPath];
    return cell;
}

#pragma mark - 选择规格 -
- (IBAction)selectFormatTapAction:(UITapGestureRecognizer *)sender {
    [self performSegueWithIdentifier:@"detailToSelectFormatVC" sender:sender];
}


#pragma mark - 底部按钮的功能 -
//加入购物车
- (IBAction)joinShoppingCarAction:(UIButton *)sender {
    [self performSegueWithIdentifier:@"detailToSelectFormatVC" sender:sender];

}

//加入收藏
- (IBAction)joinFavoriteButtonAction:(UIButton *)sender {
    
    Manager *manager = [Manager shareInstance];
    [manager httpAddFavoriteWithUserId:manager.memberInfoModel.u_id withFormatId:self.productDetailModel.productModel.productFormatID withAddFavoriteSuccess:^(id successResult) {
        
    } withAddFavoriteFail:^(NSString *failResultStr) {
        
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"detailToSelectFormatVC"]) {
    
        SelectProductViewController *selectProductVC = [segue destinationViewController];
        selectProductVC.productDetailModel = self.productDetailModel;
        selectProductVC.refreshFormatBlock = ^(){
            [self updateAllViewWithDetailModel:self.productDetailModel];

        };
    }
    
    
}


@end
