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
#import "ProductDetailTwoTableViewCell.h"
#import "ProductDetailHeaderTableViewCell.h"
#import "Manager.h"
#import "UIImageView+ImageViewCategory.h"
#import "KongImageView.h"
#import "ProductDetailThreeTableViewCell.h"
#import "MJRefresh.h"
#import "ProductTradeRecordModel.h"
#import "ProductDetailFourTableViewCell.h"
#import "WebPageViewController.h"
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
@property (weak, nonatomic) IBOutlet UIImageView *isActivityImageView;
@property (weak, nonatomic) IBOutlet UILabel *gwcNumberLabel;
//webView通过cellHeight修改cell的高度
@property(nonatomic,assign)float cellHeight;



@end

@implementation ProductDetailViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //通知，登陆成功
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setTableViewCellHight:)  name:@"getCellHightNotification" object:nil];
    }
    return self;
}


- (IBAction)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)favoriteBarButtonAction:(UIBarButtonItem *)sender {
    Manager *manager = [Manager shareInstance];
    AlertManager *alertM = [AlertManager shareIntance];
    
    if ([manager isLoggedInStatus] == YES) {
        
        if (self.isFavorite == NO) {
            //没有收藏过，现在可以收藏
            
            
            [manager httpAddFavoriteWithUserId:manager.memberInfoModel.u_id withFormatIdArr:@[self.productDetailModel.productModel.productFormatID] withAddFavoriteSuccess:^(id successResult) {
                
                
                [alertM showAlertViewWithTitle:nil withMessage:@"收藏成功" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
                //改变收藏按钮
                self.isFavorite = YES;
                [self scrollViewDidScroll:self.detailTableView];
//                sender.image = [[UIImage imageNamed:@"s_icon_jrsc_select_2@2x.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                
            } withAddFavoriteFail:^(NSString *failResultStr) {
                [alertM showAlertViewWithTitle:nil withMessage:[NSString stringWithFormat:@"收藏失败，%@",failResultStr] actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];

                
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
- (IBAction)telToPeopleServiceAction:(UIBarButtonItem *)sender {
    //联系客服
    [self performSegueWithIdentifier:@"productDetailToWebViewVC" sender:nil];
    
//    AlertManager *alertM = [AlertManager shareIntance];
//    [alertM showAlertViewWithTitle:@"拨打客服电话" withMessage:@"是否要拨打客服电话400-6076-152" actionTitleArr:@[@"取消",@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
//        if (actionBlockNumber == 1) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:4006076152"]];
//            
//        }
//    }];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //刷新此页面购物车的角标
    //
    Manager *manager = [Manager shareInstance];
    if ([manager isLoggedInStatus] == YES) {
        if (manager.shoppingNumberStr != nil && [manager.shoppingNumberStr integerValue]>0) {
            self.gwcNumberLabel.hidden = NO;
            self.gwcNumberLabel.text = manager.shoppingNumberStr;
        }else {
            self.gwcNumberLabel.hidden = YES;
        }
    }
    //进入先让navigation消失
    [self scrollViewDidScroll:self.detailTableView];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //显示navigationbar
    [self.navigationController.navigationBar setBackgroundImage:[self getImageWithAlpha:1] forBarMetrics:UIBarMetricsDefault];
    //显示navigation 那条线
    [self isClearNavigationBarLine:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //显示navigationbar
    [self.navigationController.navigationBar setBackgroundImage:[self getImageWithAlpha:1] forBarMetrics:UIBarMetricsDefault];
    //显示navigation 那条线
    [self isClearNavigationBarLine:NO];

}


//修改barbuttonItem,参数：是否显示navigationBar
- (void)modifyBarButtonItemWithIsShowNavigationBar:(BOOL)isShowNavigationBar {
    //左边的item
    NSArray<UIBarButtonItem*> * leftArray = self.navigationItem.leftBarButtonItems;
    UIBarButtonItem *leftItem = leftArray[0];
    //右边的item
    NSArray<UIBarButtonItem*> * rightArray = self.navigationItem.rightBarButtonItems;
    UIBarButtonItem *rightItem = rightArray[0];
    UIBarButtonItem *rightItem1 = rightArray[1];

    if (isShowNavigationBar == YES) {
        //显示navigationBar
        leftItem.image =  [[UIImage imageNamed:@"s_icon_back3.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        if (self.isFavorite == YES) {
            rightItem.image =  [[UIImage imageNamed:@"s_icon_jrsc_select.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

        }else {
            rightItem.image =  [[UIImage imageNamed:@"s_icon_jrsc.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

        }
        rightItem1.image =  [[UIImage imageNamed:@"s_icon_lxkf.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    }else {
        //隐藏navigationBar
        leftItem.image =  [[UIImage imageNamed:@"s_icon_back_2-.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        if (self.isFavorite == YES) {
            rightItem.image =  [[UIImage imageNamed:@"s_icon_jrsc_select_2.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

        }else {
            rightItem.image =  [[UIImage imageNamed:@"s_icon_jrsc_2.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

        }
        rightItem1.image =  [[UIImage imageNamed:@"s_icon_lxkf-_2.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    }
    
    
    
    

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self modifyBarButtonItemWithIsShowNavigationBar:NO];
    
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
    self.headerView.frame = CGRectMake(0, 0, kScreenW, kScreenW + 2 + 115 + 13 + 46 + 13 - 27 );
    
    self.productDetailModel = [[ProductDetailModel alloc] init];
    
    //获取产品详细信息
    [manager httpProductDetailInfoWithProductID:self.productID withType:self.type withProductDetailModel:self.productDetailModel withSuccessDetailResult:^(id successResult) {
        [self.kongImageView hiddenKongView];
        
        [self updateAllViewWithDetailModel:self.productDetailModel];

        //将第一个规格变成默认的规格
        [self selectOneFormatWithFormatID:self.productDetailModel.productModel.productFormatID];
        
        //收藏状态
        [self httpIsFavoriteProductWithFormatId:self.productDetailModel.productModel.productFormatID];
        
        //将这个产品加入浏览记录里面
        [manager addBrowseListActionWithBrowseProduct:self.productDetailModel];
        
        
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
    
    
//    //下拉刷新
//    [self downPushRefresh];
//    
//    //上啦加载
//    [self upPushReload];
//    

    
    
    
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
    NSArray<UIBarButtonItem*> * rightArray = self.navigationItem.rightBarButtonItems;
    UIBarButtonItem *favoriteItem = rightArray[0];
    
    Manager *manager = [Manager shareInstance];
    //如果登陆了就看看是否被收藏了
    if ([manager isLoggedInStatus] == YES) {
        [manager httpIsFavoriteWithUserId:manager.memberInfoModel.u_id withFormatId:formatId withIsFavoriteSuccess:^(id successResult) {
            
            if ([successResult isEqualToString:@"1"]) {
                //收藏了
                self.isFavorite = YES;
                [self scrollViewDidScroll:self.detailTableView];
//                favoriteItem.image =  [[UIImage imageNamed:@"s_icon_jrsc_select_2.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];


            }else {
                //未收藏
                self.isFavorite = NO;
//                favoriteItem.image =  [[UIImage imageNamed:@"s_icon_jrsc_2.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                [self scrollViewDidScroll:self.detailTableView];

            }
            
        } withIsFavoriteFail:^(NSString *failResultStr) {
            //获取失败了，就默认为没有收藏
            self.isFavorite = NO;
//            [self.favoriteButton setImage:[UIImage imageNamed:@"s_icon_jrsc"] forState:UIControlStateNormal];
            [self scrollViewDidScroll:self.detailTableView];

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
            if (tempFormatModel.imageArr.count > 0) {
                self.productDetailModel.productModel.productImageUrlstr = tempFormatModel.imageArr[0];
            }
            //是否活动
            self.productDetailModel.productModel.isSaleProduct = tempFormatModel.isActivity;
        }

    }
    //刷新ui
    [self updateAllViewWithDetailModel:self.productDetailModel];
    
    
}


- (void)upHeaderViewWithDetailModel:(ProductDetailModel *)tempDetailModel {
    //图片赋值
    //1、根据图片的个数，计算contentView的宽度
    
    [self.productImageView setWebImageURLWithImageUrlStr:tempDetailModel.productModel.productImageUrlstr withErrorImage:[UIImage imageNamed:@"icon_pic_cp"] withIsCenter:YES];
    if (tempDetailModel.productModel.isSaleProduct == YES) {
        self.isActivityImageView.hidden = NO;
    }else {
        self.isActivityImageView.hidden = YES;
    }
    self.productTitleLabel.text = tempDetailModel.productModel.productTitle;
    self.productCompanyLabel.text = tempDetailModel.productModel.productCompany;
    self.productFormatLabel.text = [NSString stringWithFormat:@"产品规格：%@", tempDetailModel.productModel.productFormatStr ];
    self.productPriceLabel.text = [NSString stringWithFormat:@"￥%@", tempDetailModel.productModel.productPrice];
    //刷新 选择规格 地方的UI
    self.selectFormatLabel.text = [NSString stringWithFormat:@"已选 \"%@\"",tempDetailModel.productModel.productFormatStr];
    
}


#pragma mark - 头部隐藏 -
//隐藏navigationBar下面的那条线
- (void)isClearNavigationBarLine:(BOOL )hideLine {
    /*
     navigationBar上有两个视图：1、_UINavigationBarBackground；2、_UINavigationBarBackIndicatorView
     其中_UINavigationBarBackground中又有两个视图：1、_UIBackdropView；2、UIImageView，这个imageView就是那一条线
     而_UINavigationBarBackIndicatorView上面没有视图了
     */
    
    //获取navigationBar上面的上面的视图
    NSArray *list = self.navigationController.navigationBar.subviews;
    for (UIView *navigationBarBackgroud in list) {
        
        //找到_UINavigationBarBackground
        if ([navigationBarBackgroud isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
            //在获取_UINavigationBarBackground上面的视图
            for (UIView *lineImageView in navigationBarBackgroud.subviews) {
                
                //如果上面是imageView的话，就是那条线
                if ([lineImageView isKindOfClass:[UIImageView class]]) {
                    if (hideLine == YES) {
                        //将这个线隐藏
                        lineImageView.hidden = YES;
                    }else {
                        //不隐藏这个线
                        lineImageView.hidden = NO;
                    }
                    
                }
            }
        }
    }
    
}

//--------------------------------------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat yOffset  = scrollView.contentOffset.y;
    NSLog(@"++%f",yOffset);
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    CGFloat alpha = yOffset/80.0f>1.0f?1:yOffset/80.0f;
    NSLog(@"%f",alpha);
    //改变navigation的背景色
    [self.navigationController.navigationBar setBackgroundImage:[self getImageWithAlpha:alpha] forBarMetrics:UIBarMetricsDefault];
    //改变通知按钮的颜色
    if (alpha>0.6) {
        NSLog(@"1111");
        //出现了navigationbar
        [self isClearNavigationBarLine:NO];
        
        //更换navigationItem样式
        [self modifyBarButtonItemWithIsShowNavigationBar:YES];
        
    }else{
        NSLog(@"2222");
        //消失了navigationbar
        [self isClearNavigationBarLine:YES];
        //更换navigationItem样式

        [self modifyBarButtonItemWithIsShowNavigationBar:NO];
    }
    
}


/**
 *  根据透明度去绘制一个图片，也可以省略此处用一个透明的图片，没这个效果好
 */
-(UIImage *)getImageWithAlpha:(CGFloat)alpha{
    
    UIColor *color = kColor(221, 76, 64, alpha);
    CGSize colorSize=CGSizeMake(1, 1);
    
    UIGraphicsBeginImageContext(colorSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    
    UIImage *img=UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return img;
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
            if ([productCommentModel.r_status isEqualToString:@"1"]) {
                //这条评论审核通过，可以展示
                [self.userCommentListArr addObject:productCommentModel];

            }
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


-(void)setTableViewCellHight:(NSNotification *)info
{
    NSDictionary * dic=info.userInfo;
    //判断通知中的参数是否与原来的值一致,防止死循环
    if (_cellHeight != [[dic objectForKey:@"height"]floatValue])
    {
        _cellHeight=[[dic objectForKey:@"height"]floatValue];
        [self.detailTableView reloadData];
    }
}

#pragma mark - tableView Delegate -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.selectType == SelectTypeProductDetail) {
        return 11 + 1;
    }
    
    if (self.selectType == SelectTypeUseInfo) {
        return 4;
    }
    
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
    return 0;
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
    
    //移除mjrefresh
    [self.detailTableView removeHeader];
    [self.detailTableView removeFooter];
}
//使用说明
- (IBAction)buttonTwoAction:(LineButton *)sender {
    self.selectType = SelectTypeUseInfo;
    [self.detailTableView reloadData];
    
    //移除mjrefresh
    [self.detailTableView removeHeader];
    [self.detailTableView removeFooter];

    
}
//用户评价
- (IBAction)buttonThreeAction:(LineButton *)sender {
    self.selectType = SelectTypeUserComment;
    [self.detailTableView reloadData];
    //如果请求过，那么就不用再次请求了
    if (self.userCommentListArr == nil) {
        [self httpProductCommentListWithPageIndex:1];
    }
    //添加mjrefresh
    [self downPushRefresh];
    [self upPushReload];

}
//交易记录
- (IBAction)buttonFourAction:(LineButton *)sender {
    self.selectType = SelectTypeTradeList;
    [self.detailTableView reloadData];
    if (self.tradeRecordListArr == nil) {
        [self httpProductTradeListWithPageIndex:1];
    }
    //添加mjrefresh
    [self downPushRefresh];
    [self upPushReload];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (self.selectType) {
        case SelectTypeProductDetail:
        {
            if (indexPath.row < 11) {
                //前面的表格信息
                ProductDetailOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"productDetailOneCell" forIndexPath:indexPath];
                
                [cell updateProductDetailOneCellWithProductInfoDic:self.productDetailModel withIndex:indexPath];
                return cell;
            }else {
                //最后的图文
                ProductDetailTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"productDetailTwoCell" forIndexPath:indexPath];
                [cell updateProductDetailTwoCell:self.productDetailModel.p_introduce];
                return cell;
            }
            
   
        }
            break;
            
        case SelectTypeUseInfo:
        {
            ProductDetailOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"productDetailOneCell" forIndexPath:indexPath];
            
            [cell updateProductDetailOneCellWithUseInfoDic:self.productDetailModel withIndex:indexPath];
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
    Manager *manager = [Manager shareInstance];
    AlertManager *alertM = [AlertManager shareIntance];
    //
    if ([manager isLoggedInStatus] == YES) {
        [self performSegueWithIdentifier:@"productDetailToShoppingCarVC" sender:nil];

    }else {
        
        //未登录
        [alertM showAlertViewWithTitle:nil withMessage:@"您未登录" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
            
        }];
        
    }
    
    
}

//立即购买
- (IBAction)buyNowButtonAction:(UIButton *)sender {
    
    Manager *manager = [Manager shareInstance];
    AlertManager *alertM = [AlertManager shareIntance];
    
    if ([manager isLoggedInStatus] == YES) {
        NSString *tempProductCount ;
        
        //如果是从产品详情中加入购物车
        for (ProductFormatModel *tempFormatModel in self.productDetailModel.productFarmatArr) {
            if (tempFormatModel.isSelect == YES) {
                tempProductCount = [NSString stringWithFormat:@"%ld",tempFormatModel.seletctCount];
            }
        }
        
        if ([tempProductCount integerValue] > 0) {
            [manager httpProductToShoppingCarWithFormatId:self.productDetailModel.productModel.productFormatID withProductCount:tempProductCount withSuccessToShoppingCarResult:^(id successResult) {
                //发送通知，让购物车界面刷新
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshShoppingCarVC" object:self userInfo:nil];
                //跳转到购物车界面
                [self performSegueWithIdentifier:@"productDetailToShoppingCarVC" sender:nil];
                
                
            } withFailToShoppingCarResult:^(NSString *failResultStr) {
                NSLog(@"加入失败");
                [alertM showAlertViewWithTitle:nil withMessage:@"加入购物车失败，请稍后再试" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
            }];
            
        }else {
            [alertM showAlertViewWithTitle:nil withMessage:@"选择产品的个数不能为0" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:nil];
            
        }
        
    }else {
        //未登录
        [alertM showAlertViewWithTitle:nil withMessage:@"您未登录" actionTitleArr:@[@"确定"] withViewController:self withReturnCodeBlock:^(NSInteger actionBlockNumber) {
            
        }];
        
    }

    
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
    
    if ([segue.identifier isEqualToString:@"productDetailToWebViewVC"]) {
        WebPageViewController *webPageVC = [segue destinationViewController];
        
        webPageVC.tempTitleStr = @"在线客服";
        webPageVC.webUrl = @"http://kefu.qycn.com/vclient/chat/?m=m&websiteid=99706";

    }
    
}


@end
