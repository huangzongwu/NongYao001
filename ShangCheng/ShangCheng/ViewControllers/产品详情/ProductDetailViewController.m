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
#import "UIImageView+ImageViewCategory.h"
#import "KongImageView.h"
#import "ProductDetailThreeTableViewCell.h"
#import "MJRefresh.h"
#import "ProductTradeRecordModel.h"
#import "ProductDetailFourTableViewCell.h"
@interface ProductDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (nonatomic,strong)KongImageView *kongImageView;

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
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

//下面选择的头部
@property (nonatomic,assign)SelectType selectType;

//用户评价
@property (nonatomic,strong)NSMutableArray *userCommentListArr;
//用户评价当前页数
@property (nonatomic,assign)NSInteger userCommentCurrentPage;
//用户评价总共的页数
@property (nonatomic,assign)NSInteger userCommentTotalPage;

//交易记录
@property (nonatomic,strong)NSMutableArray *tradeRecordListArr;
//交易记录当前页数
@property (nonatomic,assign)NSInteger tradeRecordCurrentPage;
//交易记录总共的页数
@property (nonatomic,assign)NSInteger tradeRecordTotalPage;


//是否收藏了
@property (nonatomic,assign)BOOL isFavorite;
//收藏按钮
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@end

@implementation ProductDetailViewController

- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    Manager *manager = [Manager shareInstance];
    
    //自适应高度
    // 让cell自适应高度
    self.detailTableView.rowHeight = UITableViewAutomaticDimension;
    //设置估算高度
    self.detailTableView.estimatedRowHeight = 44;
    
    //加载空白页
    self.kongImageView = [[[NSBundle mainBundle] loadNibNamed:@"KongImageView" owner:self options:nil] firstObject];
    self.kongImageView.reloadAgainButton.hidden = YES;
    self.kongImageView.frame = self.view.bounds;
    [self.view addSubview:self.kongImageView];
    
    
    //头部高度计算
    self.headerView.frame = CGRectMake(0, 0, kScreenW,  kScreenW + 2 + 115 + 13 + 46 + 13);
    
    self.productDetailModel = [[ProductDetailModel alloc] init];
    
    //获取产品详细信息
    [manager httpProductDetailInfoWithProductID:self.productID withProductDetailModel:self.productDetailModel withSuccessDetailResult:^(id successResult) {
        [self.kongImageView hiddenKongView];
        
        [self updateAllViewWithDetailModel:self.productDetailModel];

        //将第一个规格变成默认的规格
        [self selectOneFormatWithFormatID:self.productDetailModel.productModel.productFormatID];
        
        //收藏状态
        [self httpIsFavoriteProductWithFormatId:self.productDetailModel.productModel.productFormatID];
        
        //将这个产品加入浏览记录里面
        [manager addBrowseListActionWithBrowseProduct:self.productDetailModel.productModel];
        
        
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
        [self.kongImageView showKongViewWithKongMsg:@"网络错误" withKongType:KongTypeWithNetError];
        
    }];
    
    
    //下拉刷新
    [self downPushRefresh];
    
    //上啦加载
    [self upPushReload];
    
   
    
    
}

- (void)downPushRefresh {
    [self.detailTableView addHeaderWithCallback:^{
        
        if (self.selectType == SelectTypeUserComment) {
            [self httpProductCommentListWithPageIndex:1];
        }else if (self.selectType == SelectTypeTradeList) {
            [self httpProductTradeListWithPageIndex:1];
        }else {
            [self.detailTableView headerEndRefreshing];

        }
    }];
   
}

- (void)upPushReload {
    [self.detailTableView addFooterWithCallback:^{
        if (self.selectType == SelectTypeUserComment) {
            //当前页小于总页数，可以进行加载
            if (self.userCommentCurrentPage < self.userCommentTotalPage) {
                [self httpProductCommentListWithPageIndex:self.userCommentCurrentPage+1];
            }else {
                [self.detailTableView footerEndRefreshing];
            }

        }else if (self.selectType == SelectTypeTradeList) {
            //当前页小于总页数，可以进行加载
            if (self.tradeRecordCurrentPage < self.tradeRecordTotalPage) {
                [self httpProductTradeListWithPageIndex:self.tradeRecordCurrentPage+1];

            }else {
                [self.detailTableView footerEndRefreshing];
            }

        }else {

            [self.detailTableView footerEndRefreshing];

        }
    }];
}

//查看这个商品是否被关注了
- (void)httpIsFavoriteProductWithFormatId:(NSString *)formatId {
    Manager *manager = [Manager shareInstance];
    //如果登陆了就看看是否被收藏了
    if ([manager isLoggedInStatus] == YES) {
        [manager httpIsFavoriteWithUserId:manager.memberInfoModel.u_id withFormatId:formatId withIsFavoriteSuccess:^(id successResult) {
            
            if ([successResult isEqualToString:@"1"]) {
                //收藏了
                self.isFavorite = YES;
                [self.favoriteButton setImage:[UIImage imageNamed:@"s_icon_ysc"] forState:UIControlStateNormal];
            }else {
                //未收藏
                self.isFavorite = NO;
                [self.favoriteButton setImage:[UIImage imageNamed:@"s_icon_jrsc"] forState:UIControlStateNormal];
            }
            
        } withIsFavoriteFail:^(NSString *failResultStr) {
            //获取失败了，就默认为没有收藏
            self.isFavorite = NO;
            [self.favoriteButton setImage:[UIImage imageNamed:@"s_icon_jrsc"] forState:UIControlStateNormal];
        }];
    }
    
    
    
    

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
    
    [self.productImageView setWebImageURLWithImageUrlStr:tempDetailModel.productModel.productImageUrlstr withErrorImage:[UIImage imageNamed:@"productImage"]];
    self.productTitleLabel.text = tempDetailModel.productModel.productTitle;
    self.productCompanyLabel.text = tempDetailModel.productModel.productCompany;
    self.productFormatLabel.text = [NSString stringWithFormat:@"产品规格：%@", tempDetailModel.productModel.productFormatStr ];
    self.productPriceLabel.text = [NSString stringWithFormat:@"￥%@", tempDetailModel.productModel.productPrice];
    //刷新 选择规格 地方的UI
    self.selectFormatLabel.text = [NSString stringWithFormat:@"已选 \"%@\"",tempDetailModel.productModel.productFormatStr];
    
}

#pragma mark - 请求评价列表 -
- (void)httpProductCommentListWithPageIndex:(NSInteger )pageIndex {
    Manager *manager = [Manager shareInstance];
    [manager productCommentListWithProductId:self.productID withPageIndex:pageIndex withPageSize:10 withCommentListSuccess:^(id successResult) {
        //得到总页数
        self.userCommentTotalPage = [[successResult objectForKey:@"totalpages"] integerValue];
        //如果是pageIndex为1，就是刷新了
        if (pageIndex == 1) {
            //清空原有数据
            self.userCommentListArr = [NSMutableArray array];
            self.userCommentCurrentPage = 1;
            //取消效果
            [self.detailTableView headerEndRefreshing];
            
        }else {
            //如果是加载，那么更新currentpage
            self.userCommentCurrentPage = pageIndex;
            //取消效果
            [self.detailTableView footerEndRefreshing];
            

        }
        
        for (NSDictionary *tempDic in [successResult objectForKey:@"content"]) {
            ProductCommentModel *productCommentModel = [[ProductCommentModel alloc] init];
            [productCommentModel setValuesForKeysWithDictionary:tempDic];
            [self.userCommentListArr addObject:productCommentModel];
        }
        
//        //假数据
//        ProductCommentModel *model = [[ProductCommentModel alloc] init];
//        model.mobile = @"118538075702";
//        model.r_content = @"非常好非常好非常好非常好非常好非常好非常好非常好非常好非常好非常好非常好非常好非常好非常好非常好非常好非常好非常好非常好非常好非常好非常好非常好非常好非常好非常好";
//        model.r_content_reply = @"回复内容回复内容回复内容回复内容回复内容回复内容回复内容回复内容回复内容回复内容回复内容回复内容回复内容回复内容回复内容回复内容回复内容回复内容回复内容";
//        model.r_time_create = @"2017-10-11";
//        [self.userCommentListArr addObject:model];
//        
//        
//        ProductCommentModel *model2 = [[ProductCommentModel alloc] init];
//        model2.mobile = @"118538075702";
//        model2.r_content = @"非常好非";
//        model2.r_content_reply = @"回复内容";
//        model2.r_time_create = @"2017-10-11";
//        [self.userCommentListArr addObject:model2];

        
        //刷新UI
        [self.detailTableView reloadData];
        
    } withCommentListFail:^(NSString *failResultStr) {
        [self.detailTableView headerEndRefreshing];
        [self.detailTableView footerEndRefreshing];
        
    }];
}

#pragma mark - 请求交易记录 -
- (void)httpProductTradeListWithPageIndex:(NSInteger)pageIndex {
    
    Manager *manager = [Manager shareInstance];
    [manager httpProductTradeRecordWithProductId:self.productID withPageIndex:pageIndex withPageSize:10 withTradeRecordSuccess:^(id successResult) {
        
        //得到总页数
        self.tradeRecordTotalPage = [[successResult objectForKey:@"totalpages"] integerValue];
        //如果是pageIndex为1，就是刷新了
        if (pageIndex == 1) {
            //清空原有数据
            self.tradeRecordListArr = [NSMutableArray array];
            self.tradeRecordCurrentPage = 1;
            //取消效果
            [self.detailTableView headerEndRefreshing];
            
        }else {
            //如果是加载，那么更新currentpage
            self.tradeRecordCurrentPage = pageIndex;
            //取消效果
            [self.detailTableView footerEndRefreshing];
            
            
        }
        
        for (NSDictionary *tempDic in [successResult objectForKey:@"content"]) {
            ProductTradeRecordModel *productTradeModel = [[ProductTradeRecordModel alloc] init];
            [productTradeModel setValuesForKeysWithDictionary:tempDic];
            [self.tradeRecordListArr addObject:productTradeModel];
        }
        
//        //假数据
//        ProductTradeRecordModel *model = [[ProductTradeRecordModel alloc] init];
//        model.o_num = @"10";
//        model.mobile = @"18538075702";
//        model.p_time_pay = @"2017-10-10";
//        model.truename = @"十万个冷笑话";
        
//        [self.tradeRecordListArr addObject:model];
        
        //刷新UI
        [self.detailTableView reloadData];

        
    } withTradeRecordFail:^(NSString *failResultStr) {
        [self.detailTableView headerEndRefreshing];
        [self.detailTableView footerEndRefreshing];
    }];
    
}

#pragma mark - tableView Delegate -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.selectType == SelectTypeUserComment) {
        if (self.userCommentListArr.count == 0) {
            return 1;//显示空白
        }else{
            return self.userCommentListArr.count;
        }
    }
    if (self.selectType == SelectTypeTradeList) {
        if (self.tradeRecordListArr.count == 0) {
            return 1;//显示空白
        }else {
            return self.tradeRecordListArr.count;
        }
    }
    return 11;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 57;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    ProductDetailHeaderTableViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"detailHeadView"];
    [headerCell updateButtonUIWithType:self.selectType];
    return headerCell;

}
//产品详情按钮
- (IBAction)buttonOneAction:(LineButton *)sender {
    self.selectType = SelectTypeProductDetail;
    [self.detailTableView reloadData];
}
//使用说明
- (IBAction)buttonTwoAction:(LineButton *)sender {
    self.selectType = SelectTypeUseInfo;
    [self.detailTableView reloadData];
}
//用户评价
- (IBAction)buttonThreeAction:(LineButton *)sender {
    self.selectType = SelectTypeUserComment;
    [self.detailTableView reloadData];
    //如果请求过，那么就不用再次请求了
    if (self.userCommentListArr == nil) {
        [self httpProductCommentListWithPageIndex:1];
    }

}
//交易记录
- (IBAction)buttonFourAction:(LineButton *)sender {
    self.selectType = SelectTypeTradeList;
    [self.detailTableView reloadData];
    if (self.tradeRecordListArr == nil) {
        [self httpProductTradeListWithPageIndex:1];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (self.selectType) {
        case SelectTypeProductDetail:
        {
            ProductDetailOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailOneCell" forIndexPath:indexPath];
            
            [cell updateProductDetailOneCellWithDic:self.productDetailModel withIndex:indexPath];
            return cell;
   
        }
            break;
            
        case SelectTypeUseInfo:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"" forIndexPath:indexPath];
            return cell;
        }
            break;
            
            case SelectTypeUserComment:
        {
            if (self.userCommentListArr.count == 0) {
                //空白
                UITableViewCell *kongCell = [tableView dequeueReusableCellWithIdentifier:@"kongCell" forIndexPath:indexPath];
                return kongCell;
            }else {
                ProductDetailThreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"productDetailThreeCell" forIndexPath:indexPath];
                ProductCommentModel *productCommentModel = self.userCommentListArr[indexPath.row];
                [cell updateProductDetailThreeCellWithModel:productCommentModel];
                
                return cell;
            }
            
        }
            break;
            
        case SelectTypeTradeList:
        {
            if (self.tradeRecordListArr.count == 0) {
                //空白
                UITableViewCell *kongCell = [tableView dequeueReusableCellWithIdentifier:@"kongCell" forIndexPath:indexPath];
                return kongCell;
            }else {
                ProductDetailFourTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"productDetailFourCell" forIndexPath:indexPath];
                
                ProductTradeRecordModel *productTradeModel = self.tradeRecordListArr[indexPath.row];
                [cell updateProductDetailFourCellWithModel:productTradeModel];
                return cell;
            }

        }
            break;

            
        default:
            break;
    }
    
    
    
}

#pragma mark - 选择规格 -
- (IBAction)selectFormatTapAction:(UITapGestureRecognizer *)sender {
    //截屏，然后当做下一个界面的背景
    Manager *manager = [Manager shareInstance];
    UIImage *screenImg = [manager screenShot];
    [self performSegueWithIdentifier:@"detailToSelectFormatVC" sender:screenImg];
}


#pragma mark - 底部按钮的功能 -
//加入购物车
- (IBAction)joinShoppingCarAction:(UIButton *)sender {
    //截屏，然后当做下一个界面的背景
    Manager *manager = [Manager shareInstance];
    UIImage *screenImg = [manager screenShot];
    
    [self performSegueWithIdentifier:@"detailToSelectFormatVC" sender:screenImg];


}

//进入购物车界面
- (IBAction)pushShoppingCarButtonAction:(UIButton *)sender {
   
    //
    [self performSegueWithIdentifier:@"productDetailToShoppingCarVC" sender:nil];
    
    
}
//加入收藏
- (IBAction)joinFavoriteButtonAction:(UIButton *)sender {
    
    Manager *manager = [Manager shareInstance];
    AlertManager *alertM = [AlertManager shareIntance];
    
    if ([manager isLoggedInStatus] == YES) {
        
        if (self.isFavorite == NO) {
            //没有收藏过，现在可以收藏
            [manager httpAddFavoriteWithUserId:manager.memberInfoModel.u_id withFormatId:self.productDetailModel.productModel.productFormatID withAddFavoriteSuccess:^(id successResult) {
                
                [alertM showAlertViewWithTitle:nil withMessage:@"收藏成功" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];

                
            } withAddFavoriteFail:^(NSString *failResultStr) {
                
            }];

        }else {
            [alertM showAlertViewWithTitle:nil withMessage:@"已经收藏过了，无需重复收藏" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];

        }
    }else {
        [alertM showAlertViewWithTitle:nil withMessage:@"您还没有登录" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
            
        }];
    }
    
}

//联系客服
- (IBAction)telToPeopleServiceAction:(UIButton *)sender {
    AlertManager *alertM = [AlertManager shareIntance];
    [alertM showAlertViewWithTitle:@"拨打客服电话" withMessage:@"是否要拨打客服电话400-6076-152" actionTitleArr:@[@"取消",@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
        if (actionBlockNumber == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:4006076152"]];

        }
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
        selectProductVC.backImage = sender;
        selectProductVC.productDetailModel = self.productDetailModel;
        selectProductVC.refreshFormatBlock = ^(){
            [self updateAllViewWithDetailModel:self.productDetailModel];
            //重新请求收藏状态
            [self httpIsFavoriteProductWithFormatId:self.productDetailModel.productModel.productFormatID];

        };
    }
    
    
}


@end
