//
//  Manager.m
//  ShangCheng
//
//  Created by TongLi on 2016/10/27.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "Manager.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation Manager
+ (Manager *)shareInstance {
    static Manager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[Manager alloc] init];
    });
    return manager;
}

#pragma mark - 首页 -
- (void)httpBannerScrollViewDataSourceWithBannerSuccess:(SuccessResult)bannerSuccess withBannerFail:(FailResult)bannerFail {
    NSString *url = [NSString stringWithFormat:@"%@?id=&type=0",[[InterfaceManager shareInstance]linkManageBase]];
    [[NetManager shareInstance] getRequestWithURL:url withParameters:nil withContentTypes:nil withHeaderArr:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%ld",operation.response.statusCode);
        NSLog(@"%@",[self dictionaryToJson:successResult]);
        
        
        NSMutableArray *dataSourceArr = [NSMutableArray array];
        
        for (NSDictionary *tempDic in successResult) {
            BannerModel *bannerModel = [[BannerModel alloc] init];
            [bannerModel setValuesForKeysWithDictionary:tempDic];
            [dataSourceArr addObject:bannerModel];
        }
        
        
        
        bannerSuccess(dataSourceArr);
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld",operation.response.statusCode);
        bannerFail([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,[operation.responseObject objectForKey:@"Message"]]);
    }];
    
}

//广告条
- (void)httpAdScrollViewDataSourceWithAdSuccess:(SuccessResult)adSuccess withAdFail:(FailResult)adFail {
    NSString *url = [NSString stringWithFormat:@"%@?code=12816&pageindex=1&pagesize=5",[[InterfaceManager shareInstance] informationIndexBase]] ;
    [[NetManager shareInstance] getRequestWithURL:url withParameters:nil withContentTypes:nil withHeaderArr:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%ld",operation.response.statusCode);
        NSLog(@"%@",[self dictionaryToJson:successResult]);
        if (operation.response.statusCode == 200) {
            NSMutableArray *adDataSourceArr = [NSMutableArray array];
            
            NSArray *jsonArr = [successResult objectForKey:@"content"];
            for (NSDictionary *tempDic in jsonArr) {
                PestsListModel *tempModel = [[PestsListModel alloc] init];
                [tempModel setValuesForKeysWithDictionary:tempDic];
                [adDataSourceArr addObject:tempModel];
            }
            
            adSuccess(adDataSourceArr);
        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld",operation.response.statusCode);
        adFail([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,[operation.responseObject objectForKey:@"Message"]]);
    }];

}

//今日特价
- (void)todayActivityWithTodaySuccess:(SuccessResult )todaySuccess withTodayFail:(FailResult)todayFail {
    
    [[NetManager shareInstance] getRequestWithURL:[[InterfaceManager shareInstance] todayActivityBase] withParameters:nil withContentTypes:nil withHeaderArr:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%ld",operation.response.statusCode);
        NSLog(@"%@",[self dictionaryToJson:successResult]);
        NSMutableArray *todayArr = [NSMutableArray array];
        
        for (NSDictionary *jsonDic in successResult) {
            TodaySaleModel *todaySaleModel = [[TodaySaleModel alloc] init];
            [todaySaleModel setValuesForKeysWithDictionary:jsonDic];
            [todayArr addObject:todaySaleModel];
        }
        todaySuccess(todayArr);
        
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld -- %@",operation.response.statusCode,errorResult);
        todayFail([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,[operation.responseObject objectForKey:@"Message"]]);
    }];
}

//查询今日特价商品
- (void)searchTodayActivityWithAid:(NSString *)a_id withSearchTodaySuccess:(SuccessResult)searchTodaySuccess withSearchTodayFail:(FailResult)searchTodayFail {
    
    NSString *url = [NSString stringWithFormat:@"%@?id=%@",[[InterfaceManager shareInstance] todayActivityBase],a_id];
    [[NetManager shareInstance] getRequestWithURL:url withParameters:nil withContentTypes:nil withHeaderArr:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%ld",operation.response.statusCode);
        NSLog(@"%@",[self dictionaryToJson:successResult]);
        NSMutableArray *listArr = [NSMutableArray array];
        for (NSDictionary *jsonDic in successResult) {
            TodaySaleListModel *todaySaleListModel = [[TodaySaleListModel alloc] init];
            [todaySaleListModel setValuesForKeysWithDictionary:jsonDic];
            [listArr addObject:todaySaleListModel];
            
        }
        searchTodaySuccess(listArr);
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld -- %@",operation.response.statusCode,errorResult);
        searchTodayFail([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,[operation.responseObject objectForKey:@"Message"]]);
    }];

}

//病虫害树
- (NSMutableArray *)pestsTreeArr {
    if (_pestsTreeArr == nil) {
        self.pestsTreeArr = [NSMutableArray array];
    }
    return _pestsTreeArr;
}
//病虫害树形图
- (void)httpInformationPestsTreeWithPestsTreeSuccess:(SuccessResult )pestsSuccess withPestsTreeFail:(FailResult)pestsFail {
    NSString *url = [NSString stringWithFormat:@"%@?tree=",[[InterfaceManager shareInstance] informationPestsBase]];
    [[NetManager shareInstance] getRequestWithURL:url withParameters:nil withContentTypes:nil withHeaderArr:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%ld",operation.response.statusCode);
        NSLog(@"%@",[self dictionaryToJson:successResult]);
        
        self.pestsTreeArr = nil;
        for (NSDictionary *tempDic in (NSArray *)successResult) {
            PestsTreeModel *pestsModel = [[PestsTreeModel alloc] init];
            [pestsModel setValuesForKeysWithDictionary:tempDic];
            [self.pestsTreeArr addObject:pestsModel];
        }
    
        pestsSuccess(self.pestsTreeArr);
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld",operation.response.statusCode);
        pestsFail([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,[operation.responseObject objectForKey:@"Message"]]);
    }];
    
}

//分类病虫害列表
- (void)httpPestsTypeWithCode:(NSString *)code withPageIndex:(NSInteger)pageIndex withTypeSuccess:(SuccessResult )typeSuccess withTypeFail:(FailResult)typeFail {
    
    NSString *url = [NSString stringWithFormat:@"%@?code=%@&pageindex=%ld&pagesize=10",[[InterfaceManager shareInstance] informationIndexBase],code,pageIndex] ;
    [[NetManager shareInstance] getRequestWithURL:url withParameters:nil withContentTypes:nil withHeaderArr:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%ld",operation.response.statusCode);
        NSLog(@"%@",[self dictionaryToJson:successResult]);
        if (operation.response.statusCode == 200) {
            //如果是刷新，要清空原有数据
            if (pageIndex == 1) {
                self.searchPestsDataSourceArr = nil;
            }
            //解析数据
            [self analyzeSearchPestsListWithJsonDic:successResult];

            //总页数 block返回
            typeSuccess([successResult objectForKey:@"totalpages"]);
        }
        
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld",operation.response.statusCode);
        typeFail([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,[operation.responseObject objectForKey:@"Message"]]);

    }];

    
    
}

#pragma mark - 搜索 -
//搜索的产品数据源
- (NSMutableArray *)searchProductListDataSourceArr {
    if (_searchProductListDataSourceArr == nil) {
        self.searchProductListDataSourceArr = [NSMutableArray array];
    }
    return _searchProductListDataSourceArr;
}
//搜索的病虫害数据源
- (NSMutableArray *)searchPestsDataSourceArr {
    if (_searchPestsDataSourceArr == nil) {
        self.searchPestsDataSourceArr = [NSMutableArray array];
    }
    return _searchPestsDataSourceArr;
}

//请求搜索数据
- (void)searchActionWithKeyword:(NSString *)keyword withType:(NSString *)type withSort:(NSString *)sortStr withDesc:(NSString *)desc withPageindex:(NSInteger )pageindex withSearchSuccess:(SuccessResult)searchSuccess withSearchFail:(FailResult)searchFail {
    //sort="" 综合查询； sales 销量； hits 关注度； date 发布时间； price 金额；
    
    NSString *url = [[NSString stringWithFormat:@"%@?keyword=%@&type=%@&sort=%@&desc=%@&pageindex=%ld&pagesize=20", [[InterfaceManager shareInstance] siteSearchBase] ,keyword,type,sortStr,desc,pageindex] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [[NetManager shareInstance] getRequestWithURL:url withParameters:nil withContentTypes:nil withHeaderArr:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%ld",operation.response.statusCode);
        NSLog(@"%@",[self dictionaryToJson:successResult]);
        if (operation.response.statusCode == 200) {
            //看看是搜索的产品还是病虫害
            //解析产品
            if ([type isEqualToString:@"产品库"]) {
                //如果是刷新，要清空原有数据
                if (pageindex == 1) {
                    self.searchProductListDataSourceArr = nil;
                }
                //解析数据
                [self analyzeSearchProductListWithJsonDic:successResult];
            }
            //解析病虫害
            if ([type isEqualToString:@"病虫害"]) {
                //如果是刷新，要清空原有数据
                if (pageindex == 1) {
                    self.searchPestsDataSourceArr = nil;
                }
                //解析数据
                [self analyzeSearchPestsListWithJsonDic:successResult];
            }
       
            //总页数 block返回
            searchSuccess([successResult objectForKey:@"totalpages"]);

        }
       } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld",operation.response.statusCode);
           searchFail([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,[operation.responseObject objectForKey:@"Message"]]);
    }];
    
}
//解析产品
- (void)analyzeSearchProductListWithJsonDic:(NSDictionary *)jsonDic {
    NSArray *jsonArr = [jsonDic objectForKey:@"content"];
    for (NSDictionary *tempDic in jsonArr) {
        SearchListModel *tempModel = [[SearchListModel alloc] init];
        [tempModel setValuesForKeysWithDictionary:tempDic];
        [self.searchProductListDataSourceArr addObject:tempModel];
    }
    
}

//解析病虫害
- (void)analyzeSearchPestsListWithJsonDic:(NSDictionary *)jsonDic {
    NSArray *jsonArr = [jsonDic objectForKey:@"content"];
    for (NSDictionary *tempDic in jsonArr) {
        PestsListModel *tempModel = [[PestsListModel alloc] init];
        [tempModel setValuesForKeysWithDictionary:tempDic];
        [self.searchPestsDataSourceArr addObject:tempModel];
    }
    
}


#pragma mark - 分类 -
//type=type&code=&sort=&desc=&pageindex=1&pagesize=10
- (void)httpProductTypeWithCode:(NSString *)code withSort:(NSString *)sort withDesc:(NSString *)desc withPageIndex:(NSInteger)pageIndex withTypeSuccess:(SuccessResult )typeSuccess withTypeFail:(FailResult)typeFail {
    NSString *url = [[NSString stringWithFormat:@"%@?type=type&code=%@&level=3&sort=%@&desc=%@&pageindex=%ld&pagesize=10",[[InterfaceManager shareInstance] productsBySortTypeBase],code,sort,desc,pageIndex] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [[NetManager shareInstance] getRequestWithURL:url withParameters:nil withContentTypes:nil withHeaderArr:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%ld",operation.response.statusCode);
        NSLog(@"%@",[self dictionaryToJson:successResult]);
        if (operation.response.statusCode == 200) {
            //如果是刷新，要清空原有数据
            if (pageIndex == 1) {
                self.searchProductListDataSourceArr = nil;
            }
            //解析数据
            [self analyzeSearchProductListWithJsonDic:successResult];
            //总页数 block返回
            typeSuccess([successResult objectForKey:@"totalpages"]);
        }
     
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld",operation.response.statusCode);
        typeFail([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,[operation.responseObject objectForKey:@"Message"]]);

    }];
}


#pragma mark - 产品 -
- (NSMutableDictionary *)homeDataSourceDic {
    if (!_homeDataSourceDic) {
        self.homeDataSourceDic = [NSMutableDictionary dictionary];
    }
    return _homeDataSourceDic;
}
//热卖产品
- (void)httpHomeHotProductWithCnum:(NSString *)cnum withHotSuccess:(SuccessResult)hotSuccess withHotFail:(FailResult)hotFail {
    [[NetManager shareInstance] getRequestWithURL:[[InterfaceManager shareInstance] homeHotProductWithCnum:cnum] withParameters:nil withContentTypes:nil withHeaderArr:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%@",[self dictionaryToJson:successResult]);
        if (operation.response.statusCode == 200) {
            //解析
            [self analyzeHomeHotProductJsonDic:successResult withSuccessHomeResult:hotSuccess withFailHomeResult:hotFail];
        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld",operation.response.statusCode);
        hotFail([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,[operation.responseObject objectForKey:@"Message"]]);
    }];
}

//首页产品 ，rnum是推荐产品的个数
- (void)httpHomeProductWithRnum:(NSString *)rnum withSuccessHomeResult:(SuccessResult)successHomeResult withFailHomeResult:(FailResult)failHomeResult {
    
    [[NetManager shareInstance] getRequestWithURL:[[InterfaceManager shareInstance] homeProductURLWithRnum:rnum] withParameters:nil withContentTypes:nil withHeaderArr:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%@",[self dictionaryToJson:successResult]);
        if (operation.response.statusCode == 200) {
            //网络成功，解析数据
            [self analyzeHomeProductJsonDic:successResult withSuccessHomeResult:successHomeResult withFailHomeResult:failHomeResult];

        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld",operation.response.statusCode);
        failHomeResult([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,[operation.responseObject objectForKey:@"Message"]]);
    }];
}

- (void)analyzeHomeHotProductJsonDic:(NSDictionary *)jsonDic withSuccessHomeResult:(SuccessResult)successHomeResult withFailHomeResult:(FailResult)failHomeResult {
    //解析热销产品
    NSMutableArray *hotArr = [NSMutableArray array];
    NSArray *crazeArr = [jsonDic objectForKey:@"content"];
    for (NSDictionary *crazeDic in crazeArr) {
        ProductModel *hotProductModel = [[ProductModel alloc] init];
        [hotProductModel setValuesForKeysWithDictionary:crazeDic];
        
        [hotArr addObject:hotProductModel];
    }
    [self.homeDataSourceDic setValue:hotArr forKey:@"热销"];
    
    successHomeResult(self.homeDataSourceDic);
}


- (void)analyzeHomeProductJsonDic:(NSDictionary *)jsonDic withSuccessHomeResult:(SuccessResult)successHomeResult withFailHomeResult:(FailResult)failHomeResult {

    //解析推荐产品
    NSMutableArray *recommendArr = [NSMutableArray array];
//    NSArray *recomArr = [jsonDic objectForKey:@"recom"];
    for (NSDictionary *recomDic in jsonDic) {
        ProductClassModel *tempClassModel = [[ProductClassModel alloc] init];
        [tempClassModel setValuesForKeysWithDictionary:recomDic];
        tempClassModel.productArr = [NSMutableArray array];

        for (NSDictionary *productDic in [recomDic objectForKey:@"item"]) {
            
            ProductModel *tempProductModel = [[ProductModel alloc] init];
            [tempProductModel  setValuesForKeysWithDictionary:productDic];
            
            [tempClassModel.productArr addObject:tempProductModel];
        }

        [recommendArr addObject:tempClassModel];
    }
    [self.homeDataSourceDic setValue:recommendArr forKey:@"推荐"];
    
    successHomeResult(self.homeDataSourceDic);
    
}


//获取产品详情
- (void)httpProductDetailInfoWithProductID:(NSString *)productId withType:(NSString *)type withProductDetailModel:(ProductDetailModel *)productDetailModel withSuccessDetailResult:(SuccessResult)successDetailResult withFailDetailResult:(FailResult)failDetailResult {
    
    [[NetManager shareInstance] getRequestWithURL:[[InterfaceManager shareInstance] productDetailURLWithProductID:productId withType:type withIsst:@"1"] withParameters:nil withContentTypes:nil withHeaderArr:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%@",[self dictionaryToJson:successResult]);
        
        if (operation.response.statusCode == 200) {
            //网络成功，解析数据
            [self analyzeProductDetailInfoWithJsonArr:successResult withProductDetailModel:productDetailModel withSuccessDetailResult:successDetailResult withFailDetailResult:failDetailResult];
        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld",operation.response.statusCode);
        failDetailResult([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,[operation.responseObject objectForKey:@"Message"]]);
    }];
    
}

//解析产品详情
- (void)analyzeProductDetailInfoWithJsonArr:(NSArray *)jsonArr withProductDetailModel:(ProductDetailModel *)productDetailModel withSuccessDetailResult:(SuccessResult)successDetailResult withFailDetailResult:(FailResult)failDetailResult {
    if (jsonArr.count > 0) {

        ProductModel *tempModel = [[ProductModel alloc] init];
        [tempModel setValuesForKeysWithDictionary:jsonArr[0]];
        
        productDetailModel.productModel = tempModel;
        [productDetailModel setValuesForKeysWithDictionary:jsonArr[0]];

        successDetailResult(productDetailModel);
        
    }else {
        failDetailResult(@"暂时没有数据哦亲");
    }
    
    
}

/*
//获取产品的所有规格
- (void)httpProductAllFarmatInfoWithProductID:(NSString *)productId  withProductDetailModel:(ProductDetailModel *)productDetailModel withSuccessFarmatResult:(SuccessResult)successFarmatResult withFailFarmatResult:(FailResult)failFarmatResult {

    [[NetManager shareInstance] getRequestWithURL:[[InterfaceManager shareInstance] productAllFarmatWithProductID:productId] withParameters:nil withContentTypes:nil withHeaderArr:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        //解析
        [self analyzeProductAllFarmatInfoWithJsonArr:successResult withProductDetailModel:productDetailModel withSuccessFarmatResult:successFarmatResult withFailFarmatResult:failFarmatResult];
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld",operation.response.statusCode);
        failFarmatResult([operation.responseObject objectForKey:@"Message"]);

    }];
}

- (void)analyzeProductAllFarmatInfoWithJsonArr:(NSArray *)jsonArr withProductDetailModel:(ProductDetailModel *)productDetailModel withSuccessFarmatResult:(SuccessResult)successFarmatResult withFailFarmatResult:(FailResult)failFarmatResult {
    
    productDetailModel.productFarmatArr = [NSMutableArray array];
    for (NSDictionary *jsonDic in jsonArr) {
        ProductFormatModel *formatModel = [[ProductFormatModel alloc] init];
        [formatModel setValuesForKeysWithDictionary:jsonDic];

        formatModel.seletctCount = [formatModel.s_min_quantity integerValue];//默认的选择数量为最小起订数量

        [productDetailModel.productFarmatArr addObject:formatModel];
    }
    successFarmatResult(productDetailModel);
    
}
 
*/

//产品分类树
- (NSMutableArray *)productClassTreeArr {
    if (!_productClassTreeArr) {
        self.productClassTreeArr = [NSMutableArray array];
    }
    return _productClassTreeArr;
}
- (void)httpProductClassTreeWithClassTreeSuccess:(SuccessResult)classTreeSuccess withClassTreeFali:(FailResult)classTreeFail {
    
    [[NetManager shareInstance] getRequestWithURL:[[InterfaceManager shareInstance] productClassTree] withParameters:nil withContentTypes:nil withHeaderArr:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%ld",operation.response.statusCode);
        NSLog(@"%@",[self dictionaryToJson:successResult]);
        
        self.productClassTreeArr = nil;
//        self.productClassTreeArr = [NSMutableArray arrayWithArray:successResult];
//        
//        for (NSDictionary *tempDic in self.productClassTreeArr) {
//            
//            NSArray *tempArr = [tempDic objectForKey:@"item"];
//            for (NSDictionary *tempDic2 in tempArr) {
////                [tempDic2 mutableCopy];
//                [[tempDic2 mutableCopy] setValue:@"0" forKey:@"isMore"];
////                tempDic2 = tempMutableDic2;
//            }
//        }
//        
//        classTreeSuccess(self.productClassTreeArr);
        for (NSDictionary *tempDic in (NSArray *)successResult) {
            ClassModel *classModel = [[ClassModel alloc] init];
            [classModel setValuesForKeysWithDictionary:tempDic];
            [self.productClassTreeArr addObject:classModel];
        }
        
        
        
        classTreeSuccess(self.productClassTreeArr);

    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld",operation.response.statusCode);
        classTreeFail([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,[operation.responseObject objectForKey:@"Message"]]);
    }];
}

//产品的交易记录
- (void)httpProductTradeRecordWithProductId:(NSString *)productId withPageIndex:(NSInteger)pageIndex withPageSize:(NSInteger)pageSize withTradeRecordSuccess:(SuccessResult )tradeRecordSuccess withTradeRecordFail:(FailResult)tradeRecordFail {
    NSString *url = [NSString stringWithFormat:@"%@?pid=%@&pageindex=%ld&pagesize=%ld",[[InterfaceManager shareInstance] productTradeRecordBase],productId,pageIndex,pageSize];
    
    [[NetManager shareInstance] getRequestWithURL:url withParameters:nil withContentTypes:nil withHeaderArr:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%ld",operation.response.statusCode);
        NSLog(@"%@",[self dictionaryToJson:successResult]);
        
        if (operation.response.statusCode == 200) {
            tradeRecordSuccess(successResult);
        }

    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld--%@",operation.response.statusCode,errorResult);
        tradeRecordFail([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,[operation.responseObject objectForKey:@"Message"]]);
    }];
    
}

//是否被收藏
- (void)httpIsFavoriteWithUserId:(NSString *)userID withFormatId:(NSString *)formatId withIsFavoriteSuccess:(SuccessResult )isFavoriteSuccess withIsFavoriteFail:(FailResult)isFavoriteFail {
    NSString *url = [NSString stringWithFormat:@"%@?uid=%@&sid=%@",[[InterfaceManager shareInstance] favoriteBase],userID,formatId];
    
    [[NetManager shareInstance] getRequestWithURL:url withParameters:nil withContentTypes:@"string" withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        if (operation.response.statusCode == 200) {
            isFavoriteSuccess(successResult);

        }
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        id messageInfo = [NSJSONSerialization JSONObjectWithData:operation.responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *messageStr ;
        if ([messageInfo isKindOfClass:[NSString class]]) {
            messageStr = messageInfo;
        }else {
            NSDictionary *messageDic = (NSDictionary *)messageInfo;
            
            messageStr = [messageDic objectForKey:@"Message"];
        }
        
        isFavoriteFail([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,messageStr]);
    }];
}

#pragma mark - 购物车 -
//将产品加入购物车
- (void)httpProductToShoppingCarWithFormatId:(NSString *)sidStr withProductCount:(NSString *)countStr withSuccessToShoppingCarResult:(SuccessResult)successToShoppingCarResult withFailToShoppingCarResult:(FailResult)failToShoppingCarResult {
    
    NSArray *itemArr = @[@{@"sid":sidStr,@"number":countStr}];
    NSDictionary *valueDic = @{@"userid":self.memberInfoModel.u_id,@"item":itemArr};
    
    //给value加密
    NSString *secretStr = [self digest:[NSString stringWithFormat:@"%@Nongyao_Com001", [self dictionaryToJson:@[valueDic]]]];
    
    NSDictionary *parametersDic = @{@"m":secretStr,@"value":@[valueDic]};
    
    [[NetManager shareInstance] postRequestWithURL:[[InterfaceManager shareInstance] shoppingCarBaseURL] withParameters:parametersDic withContentTypes:@"string" withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@" %ld",operation.response.statusCode);
        //请求一下购物车角标
        [self httpShoppingCarNumberWithUserid:self.memberInfoModel.u_id withNumberSuccess:nil withNumberFail:nil];
        
        successToShoppingCarResult(successResult);

    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"请求失败 %ld--%@",operation.response.statusCode,[operation.responseObject objectForKey:@"Message"]);
        id messageInfo = [NSJSONSerialization JSONObjectWithData:operation.responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *messageStr ;
        if ([messageInfo isKindOfClass:[NSString class]]) {
            messageStr = messageInfo;
        }else {
            NSDictionary *messageDic = (NSDictionary *)messageInfo;
            
            messageStr = [messageDic objectForKey:@"Message"];
        }

        failToShoppingCarResult([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,messageStr]);

    }];
    
    
}

//购物车数量
- (void)httpShoppingCarNumberWithUserid:(NSString *)userId withNumberSuccess:(SuccessResult )numberSuccess withNumberFail:(FailResult)numberFail {
    
    NSString *url = [NSString stringWithFormat:@"%@?id=%@&num=", [[InterfaceManager shareInstance] shoppingCarBaseURL],userId ];
    [[NetManager shareInstance] getRequestWithURL:url withParameters:nil withContentTypes:@"string" withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%ld",operation.response.statusCode);
        if (operation.response.statusCode == 200) {
            if ([successResult isEqualToString:@"0"]) {
                self.shoppingNumberStr = nil;
            }else {
                self.shoppingNumberStr = successResult;
            }
            //发送通知，刷新购物车角标
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshShoppingCarNumber" object:self userInfo:nil];
            if (numberSuccess != nil) {
                numberSuccess(successResult);

            }
        }
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld",operation.response.statusCode);
        id messageInfo = [NSJSONSerialization JSONObjectWithData:operation.responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *messageStr ;
        if ([messageInfo isKindOfClass:[NSString class]]) {
            messageStr = messageInfo;
        }else {
            NSDictionary *messageDic = (NSDictionary *)messageInfo;
            
            messageStr = [messageDic objectForKey:@"Message"];
        }

        if (numberFail != nil) {
            numberFail([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,messageStr]);

        }
    }];
}


- (NSMutableArray *)shoppingCarDataSourceArr {
    if (!_shoppingCarDataSourceArr) {
        self.shoppingCarDataSourceArr = [NSMutableArray array];
    }
    return _shoppingCarDataSourceArr;
}

//判断是否全选了
- (void)isAllSelectForShoppingCarAction {
    //如果有一个没被选择，那么就是非全选
    if (self.shoppingCarDataSourceArr.count > 0) {
        for (ShoppingCarModel *tempModel in self.shoppingCarDataSourceArr) {
            if (tempModel.isSelectedShoppingCar == NO) {
                
                self.isAllSelectForShoppingCar = NO;
                
                return ;
            }
        }
        self.isAllSelectForShoppingCar = YES;

    }else {
        //如果购物车没有东西，那么就是非全选
        self.isAllSelectForShoppingCar = NO;
    }
    
}


//判断是否有选择产品
- (BOOL)isSelectAnyOneProduct {
    //如果有一个被选择，那么就返回yes；否则就是no
    if (self.shoppingCarDataSourceArr.count > 0) {
        for (ShoppingCarModel *tempModel in self.shoppingCarDataSourceArr) {
            if (tempModel.isSelectedShoppingCar == YES) {
                
                return YES;
            }
        }
    }
    return NO;
}

//所有选择的产品的总件数
- (NSInteger )isSelectProductCount {
    NSInteger isSelectCount = 0;
    if (self.shoppingCarDataSourceArr.count > 0) {
        for (ShoppingCarModel *tempModel in self.shoppingCarDataSourceArr) {
            if (tempModel.isSelectedShoppingCar == YES) {
                //如果这个产品被选择
                isSelectCount += [tempModel.c_number integerValue];
                
            }
        }
    }
    return isSelectCount ;
}



//网络得到购物车数据
- (void)httpShoppingCarDataWithUserId:(NSString *)userId WithSuccessResult:(SuccessResult)shoppingCarSuccessResult withFailResult:(FailResult)failResult {
    
    [[NetManager shareInstance] getRequestWithURL:[[InterfaceManager shareInstance] getShoppingCarProductUrlWithUserId:userId] withParameters:nil withContentTypes:nil withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        //清空原有数据
        self.shoppingCarDataSourceArr = nil;
        
        NSLog(@"--%ld",operation.response.statusCode);
        if (operation.response.statusCode == 200) {
            //请求成功，封装模型
            [self analyzeShoppingCarDataWithJsonData:successResult WithSuccessResult:shoppingCarSuccessResult];
            //请求一下购物车的数量
            [self httpShoppingCarNumberWithUserid:self.memberInfoModel.u_id withNumberSuccess:nil withNumberFail:nil];

            
        }else {
            failResult(@"未知错误，请稍后再试");
        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"购物车请求失败 %ld--%@",operation.response.statusCode,[operation.responseObject objectForKey:@"Message"]);
        
        failResult([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,[operation.responseObject objectForKey:@"Message"]]);

    }];
    
}

//封装购物车模型
- (void)analyzeShoppingCarDataWithJsonData:(NSArray *)jsonDataArr WithSuccessResult:(SuccessResult)successResult {
    
    if (jsonDataArr.count > 0) {
        for (NSDictionary *tempJsonDic in jsonDataArr) {
            //封装产品
            ProductModel *tempProductModel = [[ProductModel alloc] init];
            [tempProductModel setValuesForKeysWithDictionary:tempJsonDic];
            //封装购物车信息
            ShoppingCarModel *tempShoppingCarModel = [[ShoppingCarModel alloc] init];
            [tempShoppingCarModel setValuesForKeysWithDictionary:tempJsonDic];
            tempShoppingCarModel.shoppingCarProduct = tempProductModel;
            tempShoppingCarModel.isSelectedShoppingCar = NO;
            tempShoppingCarModel.productErrorMsg = @"";
            //加到数组中
            [self.shoppingCarDataSourceArr addObject:tempShoppingCarModel];
        }
    }
    //计算全选状态
    [self isAllSelectForShoppingCarAction];
    
    successResult(self.shoppingCarDataSourceArr);
}


//删除购物车的内容
- (void)deleteShoppingCarWithProductIndexSet:(NSMutableIndexSet *)productIndexSet WithSuccessResult:(SuccessResult)deleteSuccessResult withFailResult:(FailResult)deleteFailResult {
    
    //遍历产品集合，然后拼成字符串
    __block NSString *tempUrl = @""  ;
    [productIndexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        //从数组中得到具体的产品模型
        ShoppingCarModel *tempModel = self.shoppingCarDataSourceArr[idx];
        
        tempUrl = [tempUrl stringByAppendingString:tempModel.c_id];
        tempUrl = [tempUrl stringByAppendingString:@","];
    }];
    tempUrl = [tempUrl substringToIndex:tempUrl.length-1];
    
    //对id加密，id+Nongyao_Com001
    //明文
    NSString *clearStr = [NSString stringWithFormat:@"%@Nongyao_Com001",tempUrl];
    NSString *secretStr = [self digest:clearStr];
    
    
    [[NetManager shareInstance] deleteRequestWithURL:[[InterfaceManager shareInstance] deleteShoppingCarProductUrlWithShoppingCarID:tempUrl withSecret:secretStr] withParameters:nil withContentTypes:@"string" withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%ld -- %@",operation.response.statusCode,successResult);
        
        if (operation.response.statusCode == 200) {
            //远程数据库删除成功,本地删除数据源
            //删除数据源
            [self.shoppingCarDataSourceArr removeObjectsAtIndexes:productIndexSet];
            
            //判断一下是否全选了
            [self isAllSelectForShoppingCarAction];
            //请求购物车的数量
            [self httpShoppingCarNumberWithUserid:self.memberInfoModel.u_id withNumberSuccess:nil withNumberFail:nil];

            
            //block返回，刷新UI
            deleteSuccessResult(productIndexSet);
        }
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        //删除失败
        id messageInfo = [NSJSONSerialization JSONObjectWithData:operation.responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *messageStr ;
        if ([messageInfo isKindOfClass:[NSString class]]) {
            messageStr = messageInfo;
        }else {
            NSDictionary *messageDic = (NSDictionary *)messageInfo;
            
            messageStr = [messageDic objectForKey:@"Message"];
        }

        deleteFailResult([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,messageStr]);
    }];
    
}

- (void)addOrLessShoppingCarProductCountWithShoppingModel:(ShoppingCarModel *)shoppingModel withIsAddOrLess:(BOOL)isAdd withAddOrLessSuccessResult:(SuccessResult)addOrLessSuccessResult withaddOrLessFailResult:(FailResult)addOrLessFailResult {
    
    NSInteger tempCount = [shoppingModel.c_number integerValue];
    if (isAdd == YES) {
        tempCount++;
    }else {
        
        //如果个数已经是1了，就不能再减少了
        if (tempCount == 1) {
            addOrLessFailResult(@"商品最少为1");
            return;
        }
        tempCount--;
    }
    NSString *tempCountStr = [NSString stringWithFormat:@"%ld",tempCount];
    
    NSDictionary *valueDic = @{@"userid":self.memberInfoModel.u_id,@"number":tempCountStr};
    
    //给value加密
    NSString *secretStr = [self digest:[NSString stringWithFormat:@"%@Nongyao_Com001", [self dictionaryToJson:@[valueDic]]]];
    
    NSDictionary *parametersDic = @{@"m":secretStr,@"value":@[valueDic]};
    
    [[NetManager shareInstance] putRequestWithURL:[[InterfaceManager shareInstance] shoppingAdd:shoppingModel.c_id] withParameters:parametersDic withContentTypes:@"string" withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        
        NSLog(@"%ld -- %@",operation.response.statusCode,successResult);
        
        if (operation.response.statusCode == 200) {
            //修改数据源个数
            shoppingModel.c_number = tempCountStr;
            //修改数据源总价
            shoppingModel.totalprice = [NSString stringWithFormat:@"%.2f", [shoppingModel.shoppingCarProduct.productPrice floatValue] * [shoppingModel.c_number integerValue] ];
            //刷新
            addOrLessSuccessResult(shoppingModel);
        }else {
            addOrLessFailResult(@"增加数量失败");
        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        id messageInfo = [NSJSONSerialization JSONObjectWithData:operation.responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *messageStr ;
        if ([messageInfo isKindOfClass:[NSString class]]) {
            messageStr = messageInfo;
        }else {
            NSDictionary *messageDic = (NSDictionary *)messageInfo;
            
            messageStr = [messageDic objectForKey:@"Message"];
        }

        
        addOrLessFailResult([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,messageStr]);
    }];
    
}


//计算总金额
- (float)selectProductTotalPrice {
    float totalPrice = 0;
    for (ShoppingCarModel *tempModel in self.shoppingCarDataSourceArr) {
        //判断这个产品是否被选中
        if (tempModel.isSelectedShoppingCar == YES) {
            // 一个产品的总价格 = 单价*数量
            totalPrice += [tempModel.totalprice floatValue];
        }
    }
    return totalPrice;
}

//立即支付，进入预订单
- (void)httpOrderPreviewWithShoppingCarIDArr:(NSMutableArray *)shoppingCarIDArr withPreviewSuccessResult:(SuccessResult)previewSuccessResult withPreviewFailResult:(FailResult)previewFailResult {
    
    NSMutableArray *valueArr = [NSMutableArray array];
    for (NSString *shoppingID in shoppingCarIDArr) {
        [valueArr addObject:@{@"cartid":shoppingID}];        
    }

    //给value加密
    NSString *secretStr = [self digest:[NSString stringWithFormat:@"%@Nongyao_Com001", [self dictionaryToJson:valueArr]]];
    
    NSDictionary *parametersDic = @{@"m":secretStr,@"value":valueArr};

    
    [[NetManager shareInstance] postRequestWithURL:[[InterfaceManager shareInstance] orderPreviewUrl] withParameters:parametersDic withContentTypes:nil withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%ld ",operation.response.statusCode);
        if (operation.response.statusCode == 200) {
            previewSuccessResult(successResult);

        }
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld -- %@",operation.response.statusCode,errorResult);
        previewFailResult([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,[operation.responseObject objectForKey:@"Message"]]);

    }];
    
}

#pragma mark - 订单 -
//优惠券
- (void)httpCouponListWithUserID:(NSString *)userID withCouponSuccessResult:(SuccessResult )couponSuccessResult withCouponFailResult:(FailResult)couponFailResult {
    
    [[NetManager shareInstance] getRequestWithURL:[[InterfaceManager shareInstance] getCouponListWithUserId:userID] withParameters:nil withContentTypes:nil withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        
        NSLog(@"%ld",operation.response.statusCode);
        NSLog(@"%@",[self dictionaryToJson:successResult]);
        //解析
        if (operation.response.statusCode == 200) {
            [self analyzeCouponDataArr:successResult withCouponSuccessResult:couponSuccessResult];

        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld--%@",operation.response.statusCode,errorResult);
        couponFailResult([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,[operation.responseObject objectForKey:@"Message"]]);
    }];
    
}


- (void)analyzeCouponDataArr:(NSArray *)couponDataArr withCouponSuccessResult:(SuccessResult )couponSuccessResult {
    
    NSMutableArray *couponArr = [NSMutableArray array];
    
    for (NSDictionary *couponDataDic in couponDataArr) {
        CouponModel *couponModel = [[CouponModel alloc] init];
        [couponModel setValuesForKeysWithDictionary:couponDataDic];
        [couponArr addObject:couponModel];
    }
    
    couponSuccessResult(couponArr);
}


//添加优惠券
- (void)addCouponWithCouponId:(NSString *)couponId withUserId:(NSString *)userId withAddCouponSuccess:(SuccessResult )addCouponSuccess withAddCouponFail:(FailResult)addCouponFail {
    NSString *url = [NSString stringWithFormat:@"%@?id=%@",[[InterfaceManager shareInstance] couponBase] ,couponId];
    
    NSDictionary *valueDic = @{@"userid":userId};
    //给value加密
    NSString *secretStr = [self digest:[NSString stringWithFormat:@"%@Nongyao_Com001", [self dictionaryToJson:@[valueDic]]]];
    NSDictionary *parametersDic = @{@"m":secretStr,@"value":@[valueDic]};

    [[NetManager shareInstance] putRequestWithURL:url withParameters:parametersDic withContentTypes:@"string" withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%ld--%@",operation.response.statusCode,successResult);
        addCouponSuccess(@"添加成功");

    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld--%@",operation.response.statusCode,errorResult);
        id messageInfo = [NSJSONSerialization JSONObjectWithData:operation.responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *messageStr ;
        if ([messageInfo isKindOfClass:[NSString class]]) {
            messageStr = messageInfo;
        }else {
            NSDictionary *messageDic = (NSDictionary *)messageInfo;
            
            messageStr = [messageDic objectForKey:@"Message"];
        }

        addCouponFail([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,messageStr]);
    }];
    
    
}

//计算优惠券的金额
- (void)httpComputeCouponMoneyWithUserID:(NSString *)userID withCouponID:(NSString *)couponID withShoppingCarIDArr:(NSArray *)shoppingCarIDArr withComputeMoneySuccessResult:(SuccessResult)computeMoneySuccessResult withComputeMoneyFailResult:(FailResult)computeMoneyFailResult {

    NSMutableArray *idArr = [NSMutableArray array];
    for (NSString *shoppingID in shoppingCarIDArr) {
        [idArr addObject:@{@"cartid":shoppingID}];
    }
    NSArray *valueArr = @[@{@"userid":userID,@"couponid":couponID,@"item":idArr}];
    
    //给value加密
    NSString *secretStr = [self digest:[NSString stringWithFormat:@"%@Nongyao_Com001", [self dictionaryToJson:valueArr]]];
    
    NSDictionary *parametersDic = @{@"m":secretStr,@"value":valueArr};
    
    [[NetManager shareInstance] postRequestWithURL:[[InterfaceManager shareInstance] computeCouponMoneyPOST] withParameters:parametersDic withContentTypes:@"string" withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        
        if (operation.response.statusCode == 200) {
            computeMoneySuccessResult(successResult);

        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld--%@",operation.response.statusCode,errorResult);
        id messageInfo = [NSJSONSerialization JSONObjectWithData:operation.responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *messageStr ;
        if ([messageInfo isKindOfClass:[NSString class]]) {
            messageStr = messageInfo;
        }else {
            NSDictionary *messageDic = (NSDictionary *)messageInfo;
            
            messageStr = [messageDic objectForKey:@"Message"];
        }

        computeMoneyFailResult([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,messageStr]);
    }];
    
}


- (NSMutableDictionary *)orderListDataSourceDic {
    if (_orderListDataSourceDic == nil) {

        self.orderListDataSourceDic = [NSMutableDictionary dictionary];
        for (int i = 1; i <= 4; i++) {
            NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSMutableArray array],@"content", @"0",@"totalpages", nil];

            [self.orderListDataSourceDic setObject:tempDic forKey:[NSString stringWithFormat:@"%d",i]];
            
        }
        
    }
    return _orderListDataSourceDic;
}
//订单列表。 pageIndex页数,pageSize多少数据
- (void)getOrderListDataWithUserID:(NSString *)userID withType:(NSString *)type withCode:(NSString *)code withWhichTableView:(NSString *)whichTableView withPageIndex:(NSInteger)pageIndex withPageSize:(NSInteger )pageSize withOrderListSuccessResult:(SuccessResult)orderListSuccessResult withOrderListFailResult:(FailResult)orderListFailResult {
    NSString *orderStatusStr ;
    //全部
    if ([whichTableView isEqualToString:@"1"]) {
        orderStatusStr = @"";
    }
    //待付款
    if ([whichTableView isEqualToString:@"2"]) {
        orderStatusStr = @"0,1B,1A";
    }
    //进行中
    if ([whichTableView isEqualToString:@"3"]) {
        orderStatusStr = @"1";
    }
    //已完成
    if ([whichTableView isEqualToString:@"4"]) {
        orderStatusStr = @"9";
    }
    
    
    //网络请求
    [[NetManager shareInstance] getRequestWithURL:[[InterfaceManager shareInstance] orderListWithUserID:userID withType:type withCode:code withOrderStatus:orderStatusStr withPageIndex:pageIndex withPageSize:pageSize] withParameters:nil withContentTypes:nil withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        
        NSLog(@"%@",[self dictionaryToJson:successResult]);
        //请求成功
        if (operation.response.statusCode == 200) {
            //请求第一页数据，就要清空原有数据
            if (pageIndex == 1) {
                [[[self.orderListDataSourceDic objectForKey:whichTableView] objectForKey:@"content"] removeAllObjects];

            }
            //解析数据
            [self analyzeOrderListWithJsonDic:successResult withOrderStatus:whichTableView];

            orderListSuccessResult(@"请求成功");
            
        }
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"请求失败");
        orderListFailResult([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,[operation.responseObject objectForKey:@"Message"]]);
    }];
    
}

//解析订单列表
- (void)analyzeOrderListWithJsonDic:(NSDictionary *)jsonDic withOrderStatus:(NSString *)orderStatus {
    
    //得到模型数组
    NSMutableDictionary *orderListDic = [self.orderListDataSourceDic objectForKey:orderStatus];
    NSLog(@"%@",[self dictionaryToJson:jsonDic]);
    [orderListDic setObject:[jsonDic objectForKey:@"totalpages"] forKey:@"totalpages"];
    NSMutableArray *orderListArr = [orderListDic objectForKey:@"content"];
    
    for (NSDictionary *contentDic in [jsonDic objectForKey:@"content"]) {
        
        NSMutableArray *sonOrderArr = [NSMutableArray array];
        
        NSArray *itemArr = [contentDic objectForKey:@"item"];
        for (NSDictionary *itemDic in itemArr) {
            SonOrderModel *sonOrderModel = [[SonOrderModel alloc] init];
            [sonOrderModel setValuesForKeysWithDictionary:itemDic];
            [sonOrderArr addObject:sonOrderModel];
        }
        
        SupOrderModel *supOrderModel = [[SupOrderModel alloc] init];
        [supOrderModel setValuesForKeysWithDictionary:contentDic];
        supOrderModel.subOrderArr = sonOrderArr;
        supOrderModel.isSelectOrder = NO;
        //加入数组
        
        [orderListArr addObject:supOrderModel];
    }
    
}

//生成订单
- (void)creatOrderWithUserID:(NSString *)userID withReceivedID:(NSString *)receivedID withTotalAmount:(NSString *)totalAmount withDiscount:(NSString *)discount withCouponId:(NSString *)couponId withArr:(NSMutableArray *)itemArr withOrderSuccessResult:(SuccessResult)orderSuccessResult withOrderFailResult:(FailResult)orderFailResult {

    NSMutableArray *carIDArr = [NSMutableArray array];
    for (ShoppingCarModel *shoppingModel in itemArr) {
        [carIDArr addObject:@{@"cartid":shoppingModel.c_id}];
    }

    NSDictionary *valueDic = @{@"userid":userID,@"receiveid":receivedID,@"discount":discount,@"totalamount":totalAmount,@"couponid":couponId,@"facilitytype":@"4",@"item":carIDArr};
    
    
    //给value加密
    NSString *secretStr = [self digest:[NSString stringWithFormat:@"%@Nongyao_Com001", [self dictionaryToJson:@[valueDic]]]];
    
    NSDictionary *parametersDic = @{@"m":secretStr,@"value":@[valueDic]};

    [[NetManager shareInstance] postRequestWithURL:[[InterfaceManager shareInstance] creatOrderPOSTUrl] withParameters:parametersDic withContentTypes:@"string" withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        
        NSLog(@"%ld",operation.response.statusCode);

//        NSString *successStr = [[NSString alloc]initWithData:successResult encoding:NSUTF8StringEncoding];
//        successStr = [successStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
//        NSLog(@"%@",successStr);

        if (operation.response.statusCode == 200) {
            orderSuccessResult(successResult);
            // 发送通知到购物车界面，刷新
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshShoppingCarVC" object:self userInfo:nil];
        }

    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld--%@",operation.response.statusCode,errorResult);
        id messageInfo = [NSJSONSerialization JSONObjectWithData:operation.responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *messageStr ;
        if ([messageInfo isKindOfClass:[NSString class]]) {
            messageStr = messageInfo;
        }else {
            NSDictionary *messageDic = (NSDictionary *)messageInfo;
            
            messageStr = [messageDic objectForKey:@"Message"];
        }

        orderFailResult([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,messageStr]);
    }];
}

//取消父订单
- (void)cancelSupOrderWithUserID:(NSString *)userID wiOrderID:(NSString *)orderID withCancelSuccessResult:(SuccessResult )cancelSuccessResult withCancelFailResult:(FailResult)cancelFailResult {

    NSDictionary *valueDic = @{@"userid":userID,@"message":@"不喜欢"};
    
    //给value加密
    NSString *secretStr = [self digest:[NSString stringWithFormat:@"%@Nongyao_Com001", [self dictionaryToJson:@[valueDic]]]];
    
    NSDictionary *parametersDic = @{@"m":secretStr,@"value":@[valueDic]};

    
    [[NetManager shareInstance] putRequestWithURL:[[InterfaceManager shareInstance] cancelOrderWithOrderID:orderID] withParameters:parametersDic withContentTypes:nil withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%ld",operation.response.statusCode);
        if (operation.response.statusCode == 200) {
            /*取消订单成功后，需要做的操作
             1、在全部订单数据源中，将这个订单的状态改为9，值为已结束，(包括父订单和子订单)
             2、在待付款数据源中，将这个订单删除
             3、在已完成数据源中，将这个订单添加进去
             */
            //将取消后的订单，封装为模型
            NSMutableArray *sonOrderArr = [NSMutableArray array];
            
            NSArray *itemArr = [successResult[0] objectForKey:@"item"];
            for (NSDictionary *itemDic in itemArr) {
                SonOrderModel *sonOrderModel = [[SonOrderModel alloc] init];
                [sonOrderModel setValuesForKeysWithDictionary:itemDic];
                [sonOrderArr addObject:sonOrderModel];
            }
            
            SupOrderModel *changedOrderModel = [[SupOrderModel alloc] init];
            [changedOrderModel setValuesForKeysWithDictionary:successResult[0]];
            changedOrderModel.subOrderArr = sonOrderArr;
            changedOrderModel.isSelectOrder = NO;

            [self cancelOrderUpdateDataSourceWithChangedOrder:changedOrderModel];
            
            //取消订单后，就可以刷新UI了，用block返回刷新
            cancelSuccessResult(changedOrderModel);
            
        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld--%@",operation.response.statusCode,errorResult);
        cancelFailResult([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,[operation.responseObject objectForKey:@"Message"]]);
    }];
}

//取消父订单后，改变数据源的操作
- (void)cancelOrderUpdateDataSourceWithChangedOrder:(SupOrderModel *)changedOrder {
    /*取消订单成功后，需要做的操作
     1、在全部订单数据源中，将这个订单的状态改为9，值为已结束，(包括父订单和子订单)
     2、在待付款数据源中，将这个订单删除
     3、在已完成数据源中，将这个订单添加进去
     */
    
    //1、改变全部订单的数据源。
    //从全部订单中，找到这个产品
    NSMutableArray *allOrderArr = [[self.orderListDataSourceDic objectForKey:@"1"] objectForKey:@"content"];
    for (SupOrderModel *tempSupOrderModel in allOrderArr) {
        if ([tempSupOrderModel.p_id isEqualToString:changedOrder.p_id]) {
            //找到这个订单后，改变父订单状态为9,值为已结束
            tempSupOrderModel.p_status = @"9";
            tempSupOrderModel.statusvalue = @"已结束";
            
            //修改子订单,改变子订单状态为9，值为已结束
            for (SonOrderModel *tempSonOrderModel in tempSupOrderModel.subOrderArr) {
                tempSonOrderModel.o_status = @"9";
                tempSonOrderModel.statusvalue = @"已经结束";
            }
            

            
        }
    }
    
    //2、改变待付款的数据源
    //从待付款订单中，找到这个订单
    NSMutableArray *waitOrderArr = [[self.orderListDataSourceDic objectForKey:@"2"] objectForKey:@"content"];
    
    for (SupOrderModel *tempSupOrderModel in waitOrderArr) {
        if ([tempSupOrderModel.p_id isEqualToString:changedOrder.p_id]) {
            //找到后，删除
            [waitOrderArr removeObject:tempSupOrderModel];
            //立刻跳出循环，否则会崩溃，因为不许循环删除同时进行，
            break;
        }
    }
    
    //3、在已完成中添加这个订单
    NSMutableArray *finishOrderArr = [[self.orderListDataSourceDic objectForKey:@"4"] objectForKey:@"content"];
    [finishOrderArr addObject:changedOrder];
    
    
}

//取消子订单
- (void)cancelSonOrderWithUserId:(NSString *)userid withOrderID:(NSString *)orderID withCancelMessage:(NSString *)cancelMessage withCancelSuccessResult:(SuccessResult )cancelSuccessResult withCancelFailResult:(FailResult )cancelFailResult {

    NSDictionary *valueDic = @{@"userid":userid,@"message":cancelMessage,@"oid":orderID};
    
    //给value加密
    NSString *secretStr = [self digest:[NSString stringWithFormat:@"%@Nongyao_Com001", [self dictionaryToJson:@[valueDic]]]];
    
    NSDictionary *parametersDic = @{@"m":secretStr,@"value":@[valueDic]};

    [[NetManager shareInstance] postRequestWithURL:[[InterfaceManager shareInstance] cancelSonOrderPOST] withParameters:parametersDic withContentTypes:nil withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%ld",operation.response.statusCode);

        if (operation.response.statusCode == 200) {
            if ([successResult count] > 0) {
                
                NSMutableArray *sonArr = [NSMutableArray array];
                for (NSDictionary *tempSonDic in [successResult[0] objectForKey:@"item"]) {
                    SonOrderModel *cancelSonOrder = [[SonOrderModel alloc] init];
                    [cancelSonOrder setValuesForKeysWithDictionary:tempSonDic];
                    [sonArr addObject:cancelSonOrder];
                }
                
                SupOrderModel *cancelOrder = [[SupOrderModel alloc] init];
                cancelOrder.subOrderArr = sonArr;
                [cancelOrder setValuesForKeysWithDictionary:successResult[0]];
                cancelSuccessResult(cancelOrder);
            }
            
        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld--%@",operation.response.statusCode,errorResult);
        NSLog(@"%@",[operation.responseObject objectForKey:@"Message"]);
        cancelFailResult ([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,[operation.responseObject objectForKey:@"Message"]]);
    }];
}


//物流信息
- (void)orderLogisticsWithOrderId:(NSString *)orderID withSuccessLogisticsBlock:(SuccessResult )successLogisticsBlock withFailLogisticsBlock:(FailResult)failLogisticsBlock {
    
    
    [[NetManager shareInstance] getRequestWithURL:[[InterfaceManager shareInstance] logisticsWithOrderId:orderID withType:@"user"] withParameters:nil withContentTypes:nil withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%ld",operation.response.statusCode);
        NSLog(@"%@",[self dictionaryToJson:successResult]);
        if (operation.response.statusCode == 200) {
            successLogisticsBlock(successResult);

        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld--%@",operation.response.statusCode,errorResult);
        failLogisticsBlock([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,[operation.responseObject objectForKey:@"Message"]]);
    }];
}


//售后列表
- (void)httpOrderReturnListWithUserId:(NSString *)userId withCode:(NSString *)code withPageIndex:(NSInteger )pageIndex withPageSize:(NSInteger )pageSize withOrderReturnSuccess:(SuccessResult )orderReturnSuccess withOrderReturnFail:(FailResult)orderReturnFail {
    
    [[NetManager shareInstance] getRequestWithURL:[[InterfaceManager shareInstance] orderReturnListUserId:userId withCode:code withPageIndex:pageIndex withPageSize:pageSize] withParameters:nil withContentTypes:nil withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%ld",operation.response.statusCode);
        NSLog(@"%@",[self dictionaryToJson:successResult]);
        if (operation.response.statusCode == 200) {
            //如果是pageIndex为1，就是刷新了
            if (pageIndex == 1) {
                self.afterMarketArr = [NSMutableArray array];
            }
            
            [self analyzeOrderReturnListWithJson:successResult];
            
            orderReturnSuccess([successResult objectForKey:@"totalpages"]);

        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld--%@",operation.response.statusCode,errorResult);
        orderReturnFail([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,[operation.responseObject objectForKey:@"Message"]]);
    }];
    
    
}


//解析售后
- (void)analyzeOrderReturnListWithJson:(NSDictionary *)jsonDic{
    //得到模型数组
    NSLog(@"%@",[self dictionaryToJson:jsonDic]);
    for (NSDictionary *contentDic in [jsonDic objectForKey:@"content"]) {
        
        NSMutableArray *sonOrderArr = [NSMutableArray array];
        
        NSArray *itemArr = [contentDic objectForKey:@"item"];
        for (NSDictionary *itemDic in itemArr) {
            SonOrderModel *sonOrderModel = [[SonOrderModel alloc] init];
            [sonOrderModel setValuesForKeysWithDictionary:itemDic];
            [sonOrderArr addObject:sonOrderModel];
        }
        
        SupOrderModel *supOrderModel = [[SupOrderModel alloc] init];
        [supOrderModel setValuesForKeysWithDictionary:contentDic];
        supOrderModel.subOrderArr = sonOrderArr;

        //加入数组
        
        [self.afterMarketArr addObject:supOrderModel];
    }

}

//子订单确认收货
- (void)httpSonOrderEnterReceiptWithUserId:(NSString *)userId withSonOrderId:(NSString *)sonOrderId withReceiptSuccess:(SuccessResult)receiptSuccess withReceiptFail:(FailResult)receiptFail {
    NSDictionary *valueDic = @{@"userid":userId,@"oid":sonOrderId};
    
    //给value加密
    NSString *secretStr = [self digest:[NSString stringWithFormat:@"%@Nongyao_Com001", [self dictionaryToJson:@[valueDic]]]];
    
    NSDictionary *parametersDic = @{@"m":secretStr,@"value":@[valueDic]};
    
    [[NetManager shareInstance] postRequestWithURL:[[InterfaceManager shareInstance] UserReceiptBase] withParameters:parametersDic withContentTypes:nil withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%ld",operation.response.statusCode);
        if (operation.response.statusCode == 200) {
            
            if ([successResult count] > 0) {
                
                NSMutableArray *sonArr = [NSMutableArray array];
                for (NSDictionary *tempSonDic in [successResult[0] objectForKey:@"item"]) {
                    SonOrderModel *enterSonOrder = [[SonOrderModel alloc] init];
                    [enterSonOrder setValuesForKeysWithDictionary:tempSonDic];
                    [sonArr addObject:enterSonOrder];
                }
                
                SupOrderModel *enterOrder = [[SupOrderModel alloc] init];
                enterOrder.subOrderArr = sonArr;
                [enterOrder setValuesForKeysWithDictionary:successResult[0]];
                receiptSuccess(enterOrder);
            }
        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld",operation.response.statusCode);
        receiptFail([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,[operation.responseObject objectForKey:@"Message"]]);
    }];
    
}

//通过订单id获取订单信息
- (void)httpGetOrderInfoWithOrderId:(NSString *)orderId withOrderInfoSuccess:(SuccessResult)orderInfoSuccess withOrderInfoFail:(FailResult)orderInfoFail {
    NSString *url = [NSString stringWithFormat:@"%@?id=%@&type=pid&code=&status=&pageindex=1&pagesize=1",[[InterfaceManager shareInstance] creatOrderPOSTUrl],orderId];
    [[NetManager shareInstance] getRequestWithURL:url withParameters:nil withContentTypes:nil withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%@",[self dictionaryToJson:successResult]);
        if (operation.response.statusCode == 200) {
            //解析
            NSMutableArray *sonArr = [NSMutableArray array];
            for (NSDictionary *tempSonDic in [[[successResult objectForKey:@"content"] objectAtIndex:0] objectForKey:@"item"]) {
                SonOrderModel *enterSonOrder = [[SonOrderModel alloc] init];
                [enterSonOrder setValuesForKeysWithDictionary:tempSonDic];
                [sonArr addObject:enterSonOrder];
            }
            
            SupOrderModel *enterOrder = [[SupOrderModel alloc] init];
            enterOrder.subOrderArr = sonArr;
            [enterOrder setValuesForKeysWithDictionary:[[successResult objectForKey:@"content"] objectAtIndex:0]];
            orderInfoSuccess(enterOrder);
            
            
        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        orderInfoFail([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,[operation.responseObject objectForKey:@"Message"]]);
    }];
}



#pragma mark - 个人中心 之 意见反馈 -
//提交 意见反馈
- (void)httpSubmitFeedbackWithUserId:(NSString *)userId withContent:(NSString *)content withPhone:(NSString *)phone withFeedbackSuccess:(SuccessResult )feedbackSuccess withFeedbackFail:(FailResult)feedbackFail {
    
    NSDictionary *valueDic = @{@"userid":userId,@"content":content,@"name":self.memberInfoModel.u_truename,@"tel":phone,@"email":self.memberInfoModel.u_email,@"qq":self.memberInfoModel.u_qq,@"standard":@"",@"type":@"0",@"image":@""};
    
    //给value加密
    NSString *secretStr = [self digest:[NSString stringWithFormat:@"%@Nongyao_Com001", [self dictionaryToJson:@[valueDic]]]];
    
    NSDictionary *parametersDic = @{@"m":secretStr,@"value":@[valueDic]};

    
    [[NetManager shareInstance] postRequestWithURL:[[InterfaceManager shareInstance] userFeedBackBase] withParameters:parametersDic withContentTypes:@"string" withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%ld--%@",operation.response.statusCode,successResult);
        if (operation.response.statusCode == 200) {
            feedbackSuccess(@"提交成功");
        }

    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld--%@",operation.response.statusCode,errorResult);
        id messageInfo = [NSJSONSerialization JSONObjectWithData:operation.responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *messageStr ;
        if ([messageInfo isKindOfClass:[NSString class]]) {
            messageStr = messageInfo;
        }else {
            NSDictionary *messageDic = (NSDictionary *)messageInfo;
            
            messageStr = [messageDic objectForKey:@"Message"];
        }

        feedbackFail([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,messageStr]);
    }];
    
}

#pragma mark - 评价 -
- (void)productCommentListWithProductId:(NSString *)productId withPageIndex:(NSInteger )pageIndex withPageSize:(NSInteger )pageSize withCommentListSuccess:(SuccessResult )commentListSuccess withCommentListFail:(FailResult)commentListFail {
    NSString *url = [NSString stringWithFormat:@"%@?id=%@&pageindex=%ld&pagesize=%ld",[[InterfaceManager shareInstance] userOrderReviewBase],productId,pageIndex,pageSize];
    [[NetManager shareInstance] getRequestWithURL:url withParameters:nil withContentTypes:nil withHeaderArr:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%ld",operation.response.statusCode);
        NSLog(@"%@",[self dictionaryToJson:successResult]);
        
        if (operation.response.statusCode == 200) {
            commentListSuccess(successResult);
        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld--%@",operation.response.statusCode,errorResult);
        commentListFail([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,[operation.responseObject objectForKey:@"Message"]]);
    }];
    
}


//发起评论
- (void)orderCommentWithUserid:(NSString *)userId withOrderId:(NSString *)orderId withStarLevel:(NSString *)starLevel withContent:(NSString *)content withCommentSuccessBlock:(SuccessResult)commentSuccessBock withCommentFailBlock:(FailResult)commentFailBlock {
    
    NSDictionary *valueDic = @{@"userid":userId,@"oid":orderId,@"level":starLevel,@"content":content};
    
    //给value加密
    NSString *secretStr = [self digest:[NSString stringWithFormat:@"%@Nongyao_Com001", [self dictionaryToJson:@[valueDic]]]];
    
    NSDictionary *parametersDic = @{@"m":secretStr,@"value":@[valueDic]};

    
    [[NetManager shareInstance] postRequestWithURL:[[InterfaceManager shareInstance] userOrderReviewBase] withParameters:parametersDic withContentTypes:@"string" withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%ld",operation.response.statusCode);
        if (operation.response.statusCode == 200) {
            commentSuccessBock(@"评论成功");
        }

    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        id messageInfo = [NSJSONSerialization JSONObjectWithData:operation.responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *messageStr ;
        if ([messageInfo isKindOfClass:[NSString class]]) {
            messageStr = messageInfo;
        }else {
            NSDictionary *messageDic = (NSDictionary *)messageInfo;
            
            messageStr = [messageDic objectForKey:@"Message"];
        }

        commentFailBlock([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,messageStr]);
    }];
    
}

#pragma mark - 支付 -
//支付前验证
- (void)paybeforeVerifyWithUserId:(NSString *)userID withTotalAmount:(NSString *)totalAmount withBalance:(NSString *)balance withPayAmount:(NSString *)payAmount withOrderIdArr:(NSArray *)orderIdArr withPayType:(NSString *)payType withVerifySuccessBlock:(SuccessResult )verifySuccessBlock withVerfityFailBlock:(FailResult)verfityFailBlock {
    NSMutableArray *itemArr = [NSMutableArray array];
    for (NSString *tempOrder in orderIdArr) {
        NSRange range = [tempOrder rangeOfString:@","];
        if (range.length == 1) {
            NSString *tempOrderId = [tempOrder substringToIndex:range.location];
            [itemArr addObject:@{@"pid":tempOrderId}];

        }else{
            [itemArr addObject:@{@"pid":tempOrder}];

        }

    }

    NSDictionary *valueDic = @{@"userid":userID,@"totalamount":totalAmount,@"balance":balance,@"payamount":payAmount,@"paytype":payType,@"ftype":@"4",@"item":itemArr};
    
    
    //给value加密
    NSString *secretStr = [self digest:[NSString stringWithFormat:@"%@Nongyao_Com001", [self dictionaryToJson:@[valueDic]]]];
    
    NSDictionary *parametersDic = @{@"m":secretStr,@"value":@[valueDic]};

    
    [[NetManager shareInstance] postRequestWithURL:[[InterfaceManager shareInstance] paybeforeVerifyPOST] withParameters:parametersDic withContentTypes:nil withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%ld",operation.response.statusCode);
        if (operation.response.statusCode == 200) {
//            NSString *payID = [[NSString alloc] initWithData:successResult encoding:NSUTF8StringEncoding];
//            payID = [payID stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            
            //将支付id返回
            verifySuccessBlock(successResult);
        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld--%@",operation.response.statusCode,errorResult);
        NSLog(@"%@",[operation.responseObject objectForKey:@"Message"]);
        verfityFailBlock([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,[operation.responseObject objectForKey:@"Message"]]);
    }];
    
}

//支付宝获取签名 dataStr是待签名的字符串
- (void)aliPaySignDataStr:(NSString *)dataStr withSignSuccessResult:(SuccessResult)signSuccessResult withSignFailResult:(FailResult)signFailResult {

    NSDictionary *valueDic = @{@"data":dataStr};
    
    
    //给value加密
    NSString *secretStr = [self digest:[NSString stringWithFormat:@"%@Nongyao_Com001", [self dictionaryToJson:@[valueDic]]]];
    
    NSDictionary *parametersDic = @{@"m":secretStr,@"value":@[valueDic]};

    
    [[NetManager shareInstance] postRequestWithURL:[[InterfaceManager shareInstance] AliPaySignPOST] withParameters:parametersDic withContentTypes:nil withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%ld",operation.response.statusCode);
        if (operation.response.statusCode == 200) {
            //返回block
            signSuccessResult(successResult);
        }
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld--%@",operation.response.statusCode,errorResult);
        signFailResult([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,[operation.responseObject objectForKey:@"Message"]]);
    }];
}

//用户确认支付
- (void)userConfirmPayWithUserID:(NSString *)userID withRID:(NSString *)rid withPayCode:(NSString *)payCode withBank:(NSString *)bank withUserConfirmPaySuccess:(SuccessResult)paySuccess withPayFail:(FailResult)payFail {
    
    NSDictionary *valueDic = @{@"userid":userID,@"rid":rid,@"paycode":payCode,@"bank":bank};
    
    //给value加密
    NSString *secretStr = [self digest:[NSString stringWithFormat:@"%@Nongyao_Com001", [self dictionaryToJson:@[valueDic]]]];
    
    NSDictionary *parametersDic = @{@"m":secretStr,@"value":@[valueDic]};

    [[NetManager shareInstance] postRequestWithURL:[[InterfaceManager shareInstance] userConfirmPayPOST] withParameters:parametersDic withContentTypes:@"string" withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%ld",operation.response.statusCode);
        if (operation.response.statusCode == 200) {
            paySuccess(@"支付成功");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMoney" object:self userInfo:nil];


        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        id messageInfo = [NSJSONSerialization JSONObjectWithData:operation.responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *messageStr ;
        if ([messageInfo isKindOfClass:[NSString class]]) {
            messageStr = messageInfo;
        }else {
            NSDictionary *messageDic = (NSDictionary *)messageInfo;
            
            messageStr = [messageDic objectForKey:@"Message"];
        }

        payFail([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,messageStr]);
    }];
    
}


//支付后，去后台验证
- (void)afterPayOrderPaymentVerifyWithPayId:(NSString *)payId withVerifyCount:(NSInteger )verifyCount withPaymentVerifySuccess:(SuccessResult )paymentVerifySuccess withPaymentVerifyFail:(FailResult)paymentVerifyFail {

    __block NSInteger tempVerifyCount = verifyCount;

    [[NetManager shareInstance] getRequestWithURL:[[InterfaceManager shareInstance] orderPaymentVerifyWithPayid:payId] withParameters:nil withContentTypes:@"string" withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%ld",operation.response.statusCode);
        if (operation.response.statusCode == 200) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMoney" object:self userInfo:nil];
            paymentVerifySuccess(@"恭喜你支付成功");
        }
        
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld--%@",operation.response.statusCode,errorResult);
        tempVerifyCount--;

        //如果失败，再次请求，最多5次
        if (tempVerifyCount > 0) {
            [self afterPayOrderPaymentVerifyWithPayId:payId withVerifyCount:tempVerifyCount withPaymentVerifySuccess:paymentVerifySuccess withPaymentVerifyFail:paymentVerifyFail];
        }else {
            //如果5次都是失败，就是验证失败了
            id messageInfo = [NSJSONSerialization JSONObjectWithData:operation.responseObject options:NSJSONReadingAllowFragments error:nil];
            NSString *messageStr ;
            if ([messageInfo isKindOfClass:[NSString class]]) {
                messageStr = messageInfo;
            }else {
                NSDictionary *messageDic = (NSDictionary *)messageInfo;
                
                messageStr = [messageDic objectForKey:@"Message"];
            }

            paymentVerifyFail([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,messageStr]);
        }
    }];
    
}

#pragma mark - 个人中心 之 充值 -
//获取充值信息
- (void)userUserRechargeWithUserId:(NSString *)userId withAmount:(NSString *)amount withPayType:(NSInteger )payType withPayRechargeSuccess:(SuccessResult )rechargeSuccess withPayRechargeFail:(FailResult)rechargeFail {
    
    NSDictionary *valueDic = @{@"userid":userId,@"amount":amount,@"paytype":[NSString stringWithFormat:@"%ld",payType],@"ftype":@"4"};
    
    //给value加密
    NSString *secretStr = [self digest:[NSString stringWithFormat:@"%@Nongyao_Com001", [self dictionaryToJson:@[valueDic]]]];
    
    NSDictionary *parametersDic = @{@"m":secretStr,@"value":@[valueDic]};

    [[NetManager shareInstance] postRequestWithURL:[[InterfaceManager shareInstance] userRechargeBase] withParameters:parametersDic withContentTypes:nil withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        
        NSLog(@"%ld--%@",operation.response.statusCode,successResult);
        if (operation.response.statusCode == 200) {

            
            rechargeSuccess(successResult);

        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld--%@",operation.response.statusCode,errorResult);
        rechargeFail([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,[operation.responseObject objectForKey:@"Message"]]);
    }];
    
}

//充值后验证
- (void)afterRechargeWithTradeno:(NSString *)tradeNo withVerifyCount: (NSInteger )verifyCount withVerifySuccess:(SuccessResult )verifySuccess withVerifyFail:(FailResult )verifyFail {
    __block NSInteger tempVerifyCount = verifyCount;
    
    NSString *url = [NSString stringWithFormat:@"%@?did=%@",[[InterfaceManager shareInstance] userRechargeBase],tradeNo];
    
    [[NetManager shareInstance] getRequestWithURL:url withParameters:nil withContentTypes:@"string" withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%ld",operation.response.statusCode);
        if (operation.response.statusCode == 200) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMoney" object:self userInfo:nil];

            verifySuccess(@"恭喜你充值成功");
        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld--%@",operation.response.statusCode,errorResult);
        
        tempVerifyCount--;
        //如果失败，再次请求，最多5次
        if (tempVerifyCount > 0) {
            [self afterRechargeWithTradeno:tradeNo withVerifyCount:tempVerifyCount withVerifySuccess:verifySuccess withVerifyFail:verifyFail];

        }else {
            //如果5次都是失败，就是验证失败了
            id messageInfo = [NSJSONSerialization JSONObjectWithData:operation.responseObject options:NSJSONReadingAllowFragments error:nil];
            NSString *messageStr ;
            if ([messageInfo isKindOfClass:[NSString class]]) {
                messageStr = messageInfo;
            }else {
                NSDictionary *messageDic = (NSDictionary *)messageInfo;
                
                messageStr = [messageDic objectForKey:@"Message"];
            }

            verifyFail([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,messageStr]);
        }
    }];

    
}



#pragma mark - 个人信息 -
- (NSMutableDictionary *)myWalletDic {
    if (_myWalletDic == nil) {
        self.myWalletDic = [NSMutableDictionary dictionary];
    }
    return _myWalletDic;
}
//个人中心我的钱包数据
- (void)httpMyWalletWithUserId:(NSString *)userId withMyWalletSuccess:(SuccessResult )walletSuccess withMyWalletFail:(FailResult)walletFail {
    
    NSString *url = [NSString stringWithFormat:@"%@?id=%@",[[InterfaceManager shareInstance] userDataBase],userId];
    [[NetManager shareInstance] getRequestWithURL:url withParameters:nil withContentTypes:nil withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        self.myWalletDic = successResult;
        
        walletSuccess(successResult);
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld--%@",operation.response.statusCode,errorResult);
        walletFail([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,[operation.responseObject objectForKey:@"Message"]]);
    }];
}




- (void)searchUserAmount:(NSString *)userId withAmountSuccessBlock:(SuccessResult )amountSuccessBlock withAmountFailBlock:(FailResult)amountFailBlcok {
    [[NetManager shareInstance] getRequestWithURL:[[InterfaceManager shareInstance] searchUserAmountWithUserID:userId] withParameters:nil withContentTypes:nil withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%ld",operation.response.statusCode);
        if (operation.response.statusCode == 200) {
            amountSuccessBlock(successResult);

        }
        
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld--%@",operation.response.statusCode,errorResult);
        amountFailBlcok([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,[operation.responseObject objectForKey:@"Message"]]);
    }];
}

//获取收货地址列表
- (void)receiveAddressListWithUserIdOrReceiveId:(NSString *)userIdOrReceiveId withAddressListSuccess:(SuccessResult)addressListSuccessBlock withAddressListFail:(FailResult)addressListFailBlock {
    
    [[NetManager shareInstance] getRequestWithURL:[[InterfaceManager shareInstance] receiveAddressWithUserIdOrReceiveId:userIdOrReceiveId] withParameters:nil withContentTypes:nil withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%@",[self dictionaryToJson:successResult]);
        //获取成功
        if (operation.response.statusCode == 200) {
            self.receiveAddressArr = [NSMutableArray array];
            
            //解析数据
            [self analyzeReceiveAddressListWithJsonArr:successResult withAddressListSuccess:addressListSuccessBlock];
        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld--%@",operation.response.statusCode,errorResult);
        addressListFailBlock([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,[operation.responseObject objectForKey:@"Message"]]);
    }];
    
}

- (void)analyzeReceiveAddressListWithJsonArr:(NSArray *)jsonArr  withAddressListSuccess:(SuccessResult)addressListSuccessBlock {

    //封装模型
    for (NSDictionary *jsonDic in jsonArr) {
        ReceiveAddressModel *receiveModel = [[ReceiveAddressModel alloc] init];
        [receiveModel setValuesForKeysWithDictionary:jsonDic];
        
        [self.receiveAddressArr addObject:receiveModel];
    }
    
    addressListSuccessBlock(self.receiveAddressArr);
    
}

//获取已经选择的收货地址
- (ReceiveAddressModel *)selectedReceiveAddressModel {
    
    for (ReceiveAddressModel *receiveModel in self.receiveAddressArr) {
        if (receiveModel.isSelect == YES) {
            return receiveModel;
        }
    }
    return 0;
}

//修改某个收货地址
- (void)motifyReceiveAddressWithReceiveAddressModel:(ReceiveAddressModel *)tempReceiveAddressModel withMotifySuccess:(SuccessResult )motifySuccess withMotifyFail:(FailResult)motifyFail {
    
    NSString *defaltStr ;
    if (tempReceiveAddressModel.defaultAddress == YES) {
        defaltStr = @"1";
    }else {
        defaltStr = @"0";
    }


    
    
    NSDictionary *valueDic = @{@"name":tempReceiveAddressModel.receiverName,@"address":tempReceiveAddressModel.receiveAddress,@"mobile":tempReceiveAddressModel.receiveMobile,@"areaid":tempReceiveAddressModel.areaID,@"defaultaddress":defaltStr};

    //给value加密
    NSString *secretStr = [self digest:[NSString stringWithFormat:@"%@Nongyao_Com001", [self dictionaryToJson:@[valueDic]]]];
    
    NSDictionary *parametersDic = @{@"m":secretStr,@"value":@[valueDic]};

    
    [[NetManager shareInstance] putRequestWithURL:[[InterfaceManager shareInstance] receiveAddressWithUserIdOrReceiveId:tempReceiveAddressModel.receiverID] withParameters:parametersDic withContentTypes:@"string" withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%ld--",operation.response.statusCode);
        if (operation.response.statusCode == 200) {
            motifySuccess(@"修改地址成功");

        }
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld--%@",operation.response.statusCode,errorResult);
        id messageInfo = [NSJSONSerialization JSONObjectWithData:operation.responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *messageStr ;
        if ([messageInfo isKindOfClass:[NSString class]]) {
            messageStr = messageInfo;
        }else {
            NSDictionary *messageDic = (NSDictionary *)messageInfo;
            
            messageStr = [messageDic objectForKey:@"Message"];
        }

        motifyFail([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,messageStr]);
    }];
}

//添加收货地址
- (void)addReceiveAddressWithReceiveAddressModel:(ReceiveAddressModel *)tempReceiveAddressModel withUserId:(NSString *)userid withAddReceiveAddressSuccess:(SuccessResult )addReceiveAddressSuccess withAddReceiveAddressFail:(FailResult)addReceiveAddressFail {
    
    NSString *defaltStr ;
    if (tempReceiveAddressModel.defaultAddress == YES) {
        defaltStr = @"1";
    }else {
        defaltStr = @"0";
    }
    
    NSDictionary *valueDic = @{@"name":tempReceiveAddressModel.receiverName,@"address":tempReceiveAddressModel.receiveAddress,@"mobile":tempReceiveAddressModel.receiveMobile,@"userid":userid,@"areaid":tempReceiveAddressModel.areaID,@"defaultaddress":defaltStr};
    
    //给value加密
    NSString *secretStr = [self digest:[NSString stringWithFormat:@"%@Nongyao_Com001", [self dictionaryToJson:@[valueDic]]]];
    
    NSDictionary *parametersDic = @{@"m":secretStr,@"value":@[valueDic]};

    
    [[NetManager shareInstance]postRequestWithURL:[[InterfaceManager shareInstance] receiveAddressBase] withParameters:parametersDic withContentTypes:@"string" withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%ld--%@",operation.response.statusCode,successResult);
        if (operation.response.statusCode == 200) {
            addReceiveAddressSuccess(successResult);

        }
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld--%@",operation.response.statusCode,errorResult);
        id messageInfo = [NSJSONSerialization JSONObjectWithData:operation.responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *messageStr ;
        if ([messageInfo isKindOfClass:[NSString class]]) {
            messageStr = messageInfo;
        }else {
            NSDictionary *messageDic = (NSDictionary *)messageInfo;
            
            messageStr = [messageDic objectForKey:@"Message"];
        }

        addReceiveAddressFail([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,messageStr]);
                                 
    }];
    
}

//设置默认地址
- (void)defaultReceiveAddressWithAddressModel:(ReceiveAddressModel *)tempReceiveAddressModel withDefaultSuccess:(SuccessResult )defaultSuccess withDefaultFail:(FailResult)defaultFail {
    
    NSDictionary *valueDic = @{@"rid":tempReceiveAddressModel.receiverID};
    
    //给value加密
    NSString *secretStr = [self digest:[NSString stringWithFormat:@"%@Nongyao_Com001", [self dictionaryToJson:@[valueDic]]]];
    
    NSDictionary *parametersDic = @{@"m":secretStr,@"value":@[valueDic]};
    
    [[NetManager shareInstance] putRequestWithURL:[[InterfaceManager shareInstance] receiveAddressBase] withParameters:parametersDic withContentTypes:@"string" withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        
        NSLog(@"%ld",operation.response.statusCode);
        if (operation.response.statusCode == 200) {
            //将列表中的所有地址取消默认
            for (ReceiveAddressModel *tempModel in self.receiveAddressArr) {
                tempModel.defaultAddress = NO;
            }
            
            //将这个模型设置为默认地址
            tempReceiveAddressModel.defaultAddress = YES;
            defaultSuccess(@"设置默认成功");

        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld--%@",operation.response.statusCode,errorResult);
        id messageInfo = [NSJSONSerialization JSONObjectWithData:operation.responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *messageStr ;
        if ([messageInfo isKindOfClass:[NSString class]]) {
            messageStr = messageInfo;
        }else {
            NSDictionary *messageDic = (NSDictionary *)messageInfo;
            
            messageStr = [messageDic objectForKey:@"Message"];
        }

        defaultFail([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,messageStr]);
    }];
    
    
}

//删除地址
- (void)deleteReceiveAddressWithAddressModel:(ReceiveAddressModel *)tempReceiveAddressModel withDeleteAddressSuccess:(SuccessResult)deleteAddressSuccess withDeleteAddressFail:(FailResult)deleteAddressFail {
    
    NSString *secretStr = [self digest:[NSString stringWithFormat:@"%@Nongyao_Com001", tempReceiveAddressModel.receiverID]];
    
    NSString *url = [NSString stringWithFormat:@"%@?id=%@&m=%@",[[InterfaceManager shareInstance] receiveAddressBase],tempReceiveAddressModel.receiverID,secretStr];
    
    [[NetManager shareInstance] deleteRequestWithURL:url withParameters:nil withContentTypes:@"string" withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%ld",operation.response.statusCode);
        if (operation.response.statusCode == 200) {
            //删除成功
            if ([self.receiveAddressArr containsObject:tempReceiveAddressModel]) {
                
                [self.receiveAddressArr removeObject:tempReceiveAddressModel];
                if (tempReceiveAddressModel.defaultAddress == YES) {
                    deleteAddressSuccess(@"1");//删除成功，由于删除的是默认的地址，所以要重新请求

                }else {
                    deleteAddressSuccess(@"0");//删除成功，直接刷新UI

                }
                
                

            }
            
        }
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld--%@",operation.response.statusCode,errorResult);
        id messageInfo = [NSJSONSerialization JSONObjectWithData:operation.responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *messageStr ;
        if ([messageInfo isKindOfClass:[NSString class]]) {
            messageStr = messageInfo;
        }else {
            NSDictionary *messageDic = (NSDictionary *)messageInfo;
            
            messageStr = [messageDic objectForKey:@"Message"];
        }

        deleteAddressFail([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,messageStr]);

    }];
    
    
}

//个人中心--我的评价
- (void)myCommentListWithUserId:(NSString *)userId withPageIndex:(NSInteger )pageIndex withPageSize:(NSInteger )pageSize withMyCommentSuccessBlock:(SuccessResult )commentSuccessBlock withMyCommentFailBlock:(FailResult)commentFailBlock {
    
    NSString *url = [NSString stringWithFormat:@"%@?id=%@&sdt=&edt=&pageindex=%ld&pagesize=%ld",[[InterfaceManager shareInstance] userOrderReviewBase],userId,pageIndex,pageSize];
    
    [[NetManager shareInstance] getRequestWithURL:url withParameters:nil withContentTypes:nil withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        
        NSLog(@"%ld",operation.response.statusCode);
        NSLog(@"%@",[self dictionaryToJson:successResult]);
        //如果是pageIndex为1，就是刷新了
        if (pageIndex == 1) {
            self.myCommentArr = [NSMutableArray array];
        }
        
        for (NSDictionary *tempDic in [successResult objectForKey:@"content"]) {
            
            MyCommentListModel *commentModel = [[MyCommentListModel alloc] init];
            [commentModel setValuesForKeysWithDictionary:tempDic];
            
            [self.myCommentArr addObject:commentModel];
        }
        
        commentSuccessBlock([successResult objectForKey:@"totalpages"]);
        
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld--%@",operation.response.statusCode,errorResult);
        commentFailBlock([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,[operation.responseObject objectForKey:@"Message"]]);
    }];
    
}



#pragma mark - 收藏 -
//添加到收藏
- (void)httpAddFavoriteWithUserId:(NSString *)userId withFormatIdArr:(NSMutableArray *)formatIdArr withAddFavoriteSuccess:(SuccessResult )addFavoriteSuccess withAddFavoriteFail:(FailResult )addFavoriteFail {
    
    NSMutableArray *tempFormatIdArr = [NSMutableArray array];
    for (NSString *formatId in formatIdArr) {
        [tempFormatIdArr addObject:@{@"sid":formatId}];
    }
    NSDictionary *valueDic = @{@"userid":userId,@"item":tempFormatIdArr};
    
    //给value加密
    NSString *secretStr = [self digest:[NSString stringWithFormat:@"%@Nongyao_Com001", [self dictionaryToJson:@[valueDic]]]];
    
    NSDictionary *parametersDic = @{@"m":secretStr,@"value":@[valueDic]};
    
    [[NetManager shareInstance] postRequestWithURL:[[InterfaceManager shareInstance] favoriteBase] withParameters:parametersDic withContentTypes:@"string" withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        
        NSLog(@"%ld-",operation.response.statusCode);
        if (operation.response.statusCode == 200) {
            //发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMyFavorite" object:self userInfo:nil];
            addFavoriteSuccess(@"200");
        }
       
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld--%@",operation.response.statusCode,errorResult);
        id messageInfo = [NSJSONSerialization JSONObjectWithData:operation.responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *messageStr ;
        if ([messageInfo isKindOfClass:[NSString class]]) {
            messageStr = messageInfo;
        }else {
            NSDictionary *messageDic = (NSDictionary *)messageInfo;
            
            messageStr = [messageDic objectForKey:@"Message"];
        }

        addFavoriteFail([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,messageStr]);
        
    }];
    
}


- (NSMutableArray *)myFavoriteArr {
    if (!_myFavoriteArr ) {
        self.myFavoriteArr = [NSMutableArray array];
    }
    return _myFavoriteArr;
}
//收藏列表
- (void)httpMyFavoriteListWithUserId:(NSString *)userId withMyFavoriteSuccess:(SuccessResult )favoriteSuccess withMyFavoriteFail:(FailResult )favoriteFail {
    
    [[NetManager shareInstance] getRequestWithURL:[[InterfaceManager shareInstance] myFavoriteListWithUserId:userId] withParameters:nil withContentTypes:nil withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%ld",operation.response.statusCode);
        NSLog(@"%@",[self dictionaryToJson:successResult]);
        if (operation.response.statusCode == 200) {
            //清空原有数据
            self.myFavoriteArr = nil;
            
            for (NSDictionary *tempDic in successResult) {
                MyFavoriteListModel *tempModel = [[MyFavoriteListModel alloc] init];
                [tempModel setValuesForKeysWithDictionary:tempDic];
                [self.myFavoriteArr addObject:tempModel];
            }
            
            favoriteSuccess(@"200");

        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld--%@",operation.response.statusCode,errorResult);
        favoriteFail([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,[operation.responseObject objectForKey:@"Message"]]);
    }];
    
}

//删除收藏产品
- (void)httpDeleteFavoriteProductWithFavoriteArr:(NSMutableArray *)deleteFavoriteArr withDeleteFavoriteSuccess:(SuccessResult)favoriteSuccess withDeleteFavoriteFail:(FailResult)favoriteFail {
    
    NSString *idArrStr = @"" ;
    for (MyFavoriteListModel *tempFavoriteModel in deleteFavoriteArr) {
        idArrStr = [idArrStr stringByAppendingString:tempFavoriteModel.myFavoriteId];
        idArrStr = [idArrStr stringByAppendingString:@","];
    
    }
    idArrStr = [idArrStr substringToIndex:idArrStr.length-1];
    
    NSString *secretStr = [self digest:[NSString stringWithFormat:@"%@Nongyao_Com001", idArrStr]];
    
    NSString *url = [NSString stringWithFormat:@"%@?id=%@&m=%@",[[InterfaceManager shareInstance] favoriteBase],idArrStr,secretStr];
    
    [[NetManager shareInstance] deleteRequestWithURL:url withParameters:nil withContentTypes:@"string" withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%ld--",operation.response.statusCode);
        if (operation.response.statusCode == 200) {
            [self.myFavoriteArr removeObjectsInArray:deleteFavoriteArr];
            
            favoriteSuccess(@"删除成功");
        }

    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld--%@",operation.response.statusCode,errorResult);
        id messageInfo = [NSJSONSerialization JSONObjectWithData:operation.responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *messageStr ;
        if ([messageInfo isKindOfClass:[NSString class]]) {
            messageStr = messageInfo;
        }else {
            NSDictionary *messageDic = (NSDictionary *)messageInfo;
            
            messageStr = [messageDic objectForKey:@"Message"];
        }

        favoriteFail([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,messageStr]);
    
    }];
}

#pragma mark - 我的钱包 -
//流水账查询
- (void)httpSearchUserAccountListWithUserId:(NSString *)userId withSdt:(NSString *)sdt withEdt:(NSString *)edt withPageIndex:(NSInteger )pageIndex withPageSize:(NSInteger)pageSize withSearchSuccess:(SuccessResult )searchSuccess withSearchFail:(FailResult)searchFail {
    
    NSString *url = [NSString stringWithFormat:@"%@?id=%@&sdt=%@&edt=%@&pageindex=%ld&pagesize=%ld",[[InterfaceManager shareInstance] userAccountBase],userId,sdt,edt,pageIndex,pageSize];
    
    
    [[NetManager shareInstance] getRequestWithURL:url withParameters:nil withContentTypes:nil withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%ld",operation.response.statusCode);
        NSLog(@"%@",[self dictionaryToJson:successResult]);
        
        if (pageIndex == 1) {
            
            self.tradeDateKeyArr = nil;
            self.tradeDetailDic = nil;

        }
        
        for (NSDictionary *tempDic in [successResult objectForKey:@"content"]) {
            
            //封装模型
            MyTradeRecordModel *tempModel = [[MyTradeRecordModel alloc] init];
            [tempModel setValuesForKeysWithDictionary:tempDic];
            tempModel.time_dateComponents = [self dateStrToDateAndComponentWithDatestr:tempModel.d_time_create];

            //插入模型到数据源
            [self insertcashRecordArrOrTradeRecordArrWithTempModel:tempModel withIsCash:NO];
            
        }
        
        searchSuccess([successResult objectForKey:@"totalpages"]);
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld--%@",operation.response.statusCode,errorResult);
        searchFail([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,[operation.responseObject objectForKey:@"Message"]]);
    }];
    
    
}

//提现记录
- (void)httpSearchUserAgentCashListWithUserId:(NSString *)userId withPageIndex:(NSInteger )pageIndex withPageSize:(NSInteger)pageSize withSearchSuccess:(SuccessResult )searchSuccess withSearchFail:(FailResult)searchFail {
    
    NSString *url = [NSString stringWithFormat:@"%@?id=%@&isHandle=&pageindex=%ld&pagesize=%ld",[[InterfaceManager shareInstance] AgentCashBase],userId,pageIndex,pageSize];
    
    [[NetManager shareInstance] getRequestWithURL:url withParameters:nil withContentTypes:nil withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%ld",operation.response.statusCode);
        NSLog(@"%@",[self dictionaryToJson:successResult]);
        
        if (pageIndex == 1) {
            self.cashDateKeyArr = nil;
            self.cashDetailDic = nil;
            
        }
        
        for (NSDictionary *tempDic in [successResult objectForKey:@"content"]) {
            
            //封装模型
            MyAgentCashModel *tempModel = [[MyAgentCashModel alloc] init];
            [tempModel setValuesForKeysWithDictionary:tempDic];
            tempModel.time_dateComponents = [self dateStrToDateAndComponentWithDatestr:tempModel.w_time_create];
            
            //插入模型到数据源
            [self insertcashRecordArrOrTradeRecordArrWithTempModel:tempModel withIsCash:YES];
            
        }
        
        searchSuccess([successResult objectForKey:@"totalpages"]);
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld--%@",operation.response.statusCode,errorResult);
        searchFail([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,[operation.responseObject objectForKey:@"Message"]]);
    }];
    
    
}


//提现记录字典懒加载
- (NSMutableDictionary *)cashDetailDic {
    if (_cashDetailDic == nil) {
        
        self.cashDetailDic = [[NSMutableDictionary alloc] init];
    }
    return _cashDetailDic;
}

- (NSMutableArray *)cashDateKeyArr{
    if (_cashDateKeyArr == nil) {
        self.cashDateKeyArr = [NSMutableArray arrayWithArray:self.cashDetailDic.allKeys] ;
        //对keyArray做排序操作
        [self.cashDateKeyArr sortUsingSelector:@selector(compare:)];
        //倒序
        NSEnumerator *enumerator = [self.cashDateKeyArr reverseObjectEnumerator];
        self.cashDateKeyArr =[[NSMutableArray alloc]initWithArray: [enumerator allObjects]];
        
    }
    return _cashDateKeyArr;
}


//交易记录字典懒加载
- (NSMutableDictionary *)tradeDetailDic {
    if (_tradeDetailDic == nil) {

        self.tradeDetailDic = [[NSMutableDictionary alloc] init];
    }
    return _tradeDetailDic;
}

- (NSMutableArray *)tradeDateKeyArr{
    if (_tradeDateKeyArr == nil) {
        self.tradeDateKeyArr = [NSMutableArray arrayWithArray:self.tradeDetailDic.allKeys] ;
        //对keyArray做排序操作
        [self.tradeDateKeyArr sortUsingSelector:@selector(compare:)];
        //倒序
        NSEnumerator *enumerator = [self.tradeDateKeyArr reverseObjectEnumerator];
        self.tradeDateKeyArr =[[NSMutableArray alloc]initWithArray: [enumerator allObjects]];
    
    }
    return _tradeDateKeyArr;
}



- (void)insertcashRecordArrOrTradeRecordArrWithTempModel:(id )tempModel withIsCash:(BOOL)isCash {
    
    //得到时间的年月字符串
    
    NSString *tempYearMonthStr = [NSString stringWithFormat:@"%ld-%ld", [tempModel time_dateComponents].year,[tempModel time_dateComponents].month];

    NSMutableArray *tempArr = nil;
    
    if (isCash == YES) {
        //取现记录
        if ([self.cashDateKeyArr containsObject:tempYearMonthStr]) {
            //有这个时间段,找到这个数组，直接添加
            tempArr = [self.cashDetailDic objectForKey:tempYearMonthStr];
            [tempArr addObject:tempModel];
            
        }else {
            //如果没有，那么就创建数组
            tempArr = [NSMutableArray array];
            //添加到数组中
            [tempArr addObject:tempModel];
            //将数组放进字典
            [self.cashDetailDic setObject:tempArr forKey:tempYearMonthStr];
            //将这个时间放进键数组中
            [self.cashDateKeyArr addObject:tempYearMonthStr];
            //排序(正序)
            [self.cashDateKeyArr sortUsingSelector:@selector(compare:)];
            //倒序
            NSEnumerator *enumerator = [self.cashDateKeyArr reverseObjectEnumerator];
            self.cashDateKeyArr =[[NSMutableArray alloc]initWithArray: [enumerator allObjects]];
            
        }

        
    }else {
        //交易记录
        if ([self.tradeDateKeyArr containsObject:tempYearMonthStr]) {
            //有这个时间段,找到这个数组，直接添加
            tempArr = [self.tradeDetailDic objectForKey:tempYearMonthStr];
            [tempArr addObject:tempModel];
            
        }else {
            //如果没有，那么就创建数组
            tempArr = [NSMutableArray array];
            //添加到数组中
            [tempArr addObject:tempModel];
            //将数组放进字典
            [self.tradeDetailDic setObject:tempArr forKey:tempYearMonthStr];
            //将这个时间放进键数组中
            [self.tradeDateKeyArr addObject:tempYearMonthStr];
            //排序(正序)
            [self.tradeDateKeyArr sortUsingSelector:@selector(compare:)];
            //倒序
            NSEnumerator *enumerator = [self.tradeDateKeyArr reverseObjectEnumerator];
            self.tradeDateKeyArr =[[NSMutableArray alloc]initWithArray: [enumerator allObjects]];
            
        }
    }
}

//提现申请
- (void)httpUserAgentCashApplicationWithUserId:(NSString *)userId withType:(NSString *)type withBankName:(NSString *)bankName withName:(NSString *)name withCode:(NSString *)code withAmount:(NSString *)amount withNote:(NSString *)note withAgentCashSuccess:(SuccessResult )agentCashSuccess withAgentCashFail:(FailResult)agentCashFail {
    
    NSDictionary *valueDic = @{@"userid":userId,@"type":type,@"bankname":bankName,@"name":name,@"code":code,@"amount":amount,@"note":note};
    
    //给value加密
    NSString *secretStr = [self digest:[NSString stringWithFormat:@"%@Nongyao_Com001", [self dictionaryToJson:@[valueDic]]]];
    
    NSDictionary *parametersDic = @{@"m":secretStr,@"value":@[valueDic]};

    [[NetManager shareInstance] postRequestWithURL:[[InterfaceManager shareInstance] AgentCashBase] withParameters:parametersDic withContentTypes:@"string" withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        
        NSLog(@"%ld -- %@",operation.response.statusCode,successResult);
        if (operation.response.statusCode == 200) {
            agentCashSuccess(@"提现申请成功");

        }

    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld -- %@",operation.response.statusCode,errorResult);
        id messageInfo = [NSJSONSerialization JSONObjectWithData:operation.responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *messageStr ;
        if ([messageInfo isKindOfClass:[NSString class]]) {
            messageStr = messageInfo;
        }else {
            NSDictionary *messageDic = (NSDictionary *)messageInfo;
            
            messageStr = [messageDic objectForKey:@"Message"];
        }

        agentCashFail([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,messageStr]);
    }];
    
}


#pragma mark - 修改个人资料 -
//修改个人头像
- (void)httpMotifyMemberAvatarWithUserId:(NSString *)userId withMotifyAvatarImage:(UIImage *)avatarImg withMotifyAvatarSuccess:(SuccessResult)motifyAvatarSuccess withMotifyAvatarFail:(FailResult)motifyAvatarFail {
    
    //先上传头像
    [self uploadImageWithUploadImage:avatarImg withUploadSuccess:^(id successResult) {
        NSString *iconUrl = successResult;
        //上传头像成功，然后进行用户头像的修改
        NSDictionary *valueDic = @{@"userid":userId,@"icon":iconUrl};
        
        //给value加密
        NSString *secretStr = [self digest:[NSString stringWithFormat:@"%@Nongyao_Com001", [self dictionaryToJson:@[valueDic]]]];
        
        NSDictionary *parametersDic = @{@"m":secretStr,@"value":@[valueDic]};
        
        [[NetManager shareInstance] postRequestWithURL:[[InterfaceManager shareInstance] userIconBase] withParameters:parametersDic withContentTypes:@"string" withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
            if (operation.response.statusCode == 200) {
                motifyAvatarSuccess(iconUrl);
            }
            
        } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
            NSDictionary *messageDic = [NSJSONSerialization JSONObjectWithData:operation.responseObject options:NSJSONReadingAllowFragments error:nil];
            NSString *messageStr = [messageDic objectForKey:@"Message"];
            motifyAvatarSuccess([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,messageStr]);
        }];

        
        
    } withUploadFail:^(NSString *failResultStr) {

        motifyAvatarFail(failResultStr);
        
    }];
    
}

//修改个人资料
- (void)httpMotifyMemberInfoWithUserID:(NSString *)userID withUsername:(NSString *)userName withEmail:(NSString *)email withQQ:(NSString *)qq withAreaId:(NSString *)areaId WithMotifyMemberSuccess:(SuccessResult )motifySuccess withMotifyMemberFail:(FailResult)motifyFail {
    
    NSDictionary *valueDic = @{@"username":userName,@"email":email,@"qq":qq,@"areaid":areaId,@"status":@"1"};
    
    //给value加密
    NSString *secretStr = [self digest:[NSString stringWithFormat:@"%@Nongyao_Com001", [self dictionaryToJson:@[valueDic]]]];
    
    NSDictionary *parametersDic = @{@"m":secretStr,@"value":@[valueDic]};
    
    NSString *url = [NSString stringWithFormat:@"%@?id=%@",[[InterfaceManager shareInstance] userBase],userID];
    [[NetManager shareInstance] putRequestWithURL:url withParameters:parametersDic withContentTypes:@"string" withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        
        NSLog(@"%ld",operation.response.statusCode);
        motifySuccess(@"修改成功");

    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        
        NSLog(@"%ld -- %@",operation.response.statusCode,errorResult);
        id messageInfo = [NSJSONSerialization JSONObjectWithData:operation.responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *messageStr ;
        if ([messageInfo isKindOfClass:[NSString class]]) {
            messageStr = messageInfo;
        }else {
            NSDictionary *messageDic = (NSDictionary *)messageInfo;
            
            messageStr = [messageDic objectForKey:@"Message"];
        }

        motifyFail([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,messageStr]);
    }];
    
    
}

//修改密码
- (void)httpMotifyPasswordWithUserId:(NSString *)userId withPassword:(NSString *)password withMotifyPasswordSuccess:(SuccessResult )motifyPasswordSuccess withMotifyPasswordFail:(FailResult )motifyPasswordFail {
    
    NSDictionary *valueDic = @{@"userid":userId,@"pwd":password};
    
    //给value加密
    NSString *secretStr = [self digest:[NSString stringWithFormat:@"%@Nongyao_Com001", [self dictionaryToJson:@[valueDic]]]];
    
    NSDictionary *parametersDic = @{@"m":secretStr,@"value":@[valueDic]};

    [[NetManager shareInstance] postRequestWithURL:[[InterfaceManager shareInstance] motifyPasswordBase] withParameters:parametersDic withContentTypes:@"string" withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        
        
        NSLog(@"%ld ",operation.response.statusCode);
        //修改成功，就封装模型。保存本地
        self.memberInfoModel.userPassword = password;
        
        //账号密码登录，需要存到本地
        //存到本地利用归档
        BOOL saveResult = [self saveMemberInfoModelToLocationWithMemberInfo:self.memberInfoModel];
        if (saveResult == YES) {
            //存入本地成功
            motifyPasswordSuccess(@"修改成功");

        }else{
            //存入本地失败
            motifyPasswordSuccess(@"存入本地失败");
        }


    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld -- %@",operation.response.statusCode,errorResult);
        id messageInfo = [NSJSONSerialization JSONObjectWithData:operation.responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *messageStr ;
        if ([messageInfo isKindOfClass:[NSString class]]) {
            messageStr = messageInfo;
        }else {
            NSDictionary *messageDic = (NSDictionary *)messageInfo;
            
            messageStr = [messageDic objectForKey:@"Message"];
        }

        motifyPasswordFail([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,messageStr]);
    }];
    
}

#pragma mark - 我的代理 -
- (NSMutableDictionary *)myAgentDic {
    if (_myAgentDic == nil) {
        self.myAgentDic = [NSMutableDictionary dictionary];
    }
    return _myAgentDic;
}

//我的代理基本数据
- (void)httpMyAgentBaseDataWithUserId:(NSString *)userId withMyAgentSuccess:(SuccessResult )myAgentSuccess withMyagentFail:(FailResult )myAgentFail {
    NSString *url = [NSString stringWithFormat:@"%@?id=%@",[[InterfaceManager shareInstance] myAgentDataBase],userId];
    
    [[NetManager shareInstance] getRequestWithURL:url withParameters:nil withContentTypes:nil withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%ld ",operation.response.statusCode);
        if (operation.response.statusCode == 200) {
            //收益
            [self.myAgentDic setValue:[successResult objectForKey:@"u_amount_avail"] forKey:@"u_amount_avail"];
            //订单
            [self.myAgentDic setValue:[successResult objectForKey:@"ordernum"] forKey:@"ordernum"];
            //人数
            [self.myAgentDic setValue:[successResult objectForKey:@"peonum"] forKey:@"peonum"];
            
            myAgentSuccess(@"成功");

        }
      
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld -- %@",operation.response.statusCode,errorResult);
        myAgentFail([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,[operation.responseObject objectForKey:@"Message"]]);
    }];
}

//我的代理 人员数据
- (void)httpMyAgentPeopleListDataWithUserId:(NSString *)userId withPageindex:(NSInteger )pageIndex withMyAgentSuccess:(SuccessResult)myAgentSuccess withMyagentFail:(FailResult)myAgentFail {
    
    NSString *url = [NSString stringWithFormat:@"%@?id=%@&pageindex=%ld&pagesize=10",[[InterfaceManager shareInstance] myAgentPeopleListBase],userId,pageIndex];
    
    [[NetManager shareInstance] getRequestWithURL:url withParameters:nil withContentTypes:nil withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%ld",operation.response.statusCode);
        NSLog(@"%@",[self dictionaryToJson:successResult]);
        
        if (pageIndex == 1 ) {
            //重新刷新数据，即需要清除原有数据
            [[self.myAgentDic objectForKey:@"people"] removeAllObjects];
        }
        //解析模型
        [self analyzeMyAgentPeopleListDataWithJsonArr:[successResult objectForKey:@"content"]];
        myAgentSuccess([successResult objectForKey:@"totalpages"]);
        
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld -- %@",operation.response.statusCode,errorResult);
        myAgentFail([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,[operation.responseObject objectForKey:@"Message"]]);
        
    }];
    
}

- (void)analyzeMyAgentPeopleListDataWithJsonArr:(NSArray *)jsonArr {
    NSMutableArray *peopleArr = nil;
    if ([self.myAgentDic objectForKey:@"people"] == nil) {
        peopleArr = [NSMutableArray array];
        [self.myAgentDic setObject:peopleArr forKey:@"people"];
    }else {
        peopleArr = [self.myAgentDic objectForKey:@"people"];
    }
    
    for (NSDictionary *jsonDic in jsonArr) {
        MyAgentPeopleModel *agentPeopleModel = [[MyAgentPeopleModel alloc] init];
        [agentPeopleModel setValuesForKeysWithDictionary:jsonDic];
        [peopleArr addObject:agentPeopleModel];
    }
}

//我的代理 订单数据
- (void)httpMyAgentOrderListDataWithUserId:(NSString *)userId withPageindex:(NSInteger )pageIndex withMyAgentSuccess:(SuccessResult)myAgentSuccess withMyagentFail:(FailResult)myAgentFail {
    
    NSString *url = [NSString stringWithFormat:@"%@?id=%@&pageindex=%ld&pagesize=10",[[InterfaceManager shareInstance] myAgentOrderListBase],userId,pageIndex];
    [[NetManager shareInstance] getRequestWithURL:url withParameters:nil withContentTypes:nil withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%ld",operation.response.statusCode);
        NSLog(@"%@",[self dictionaryToJson:successResult]);

        if (pageIndex == 1 ) {
            //重新刷新数据，即需要清除原有数据
            [[self.myAgentDic objectForKey:@"order"] removeAllObjects];
        }
        //解析模型
        [self analyzeMyAgentOrderListDataWithJsonArr:[successResult objectForKey:@"content"]];

        myAgentSuccess([successResult objectForKey:@"totalpages"]);

    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld -- %@",operation.response.statusCode,errorResult);
        myAgentFail([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,[operation.responseObject objectForKey:@"Message"]]);
        
    }];

}

- (void)analyzeMyAgentOrderListDataWithJsonArr:(NSArray *)jsonArr {
    NSMutableArray *orderArr = nil;
    if ([self.myAgentDic objectForKey:@"order"] == nil) {
        orderArr = [NSMutableArray array];
        [self.myAgentDic setObject:orderArr forKey:@"order"];
    }else {
        orderArr = [self.myAgentDic objectForKey:@"order"];
    }
    
    for (NSDictionary *jsonDic in jsonArr) {
        MyAgentOrderModel *agentOrderModel = [[MyAgentOrderModel alloc] init];
        [agentOrderModel setValuesForKeysWithDictionary:jsonDic];
        [orderArr addObject:agentOrderModel];
    }
}

#pragma mark - 浏览记录 -
- (NSMutableArray *)mybrowseListArr {
    if (_mybrowseListArr == nil) {
        self.mybrowseListArr = [NSMutableArray array];
    }
    return _mybrowseListArr;
}

//从本地获取浏览记录
- (void)getLocationBrowseList {
    NSArray *_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *_documentPath = [_paths lastObject];
    NSLog(@"%@",_documentPath);
    NSString *_personFilePath = [_documentPath stringByAppendingPathComponent:@"browseList.plist"];
    
    self.mybrowseListArr = [NSKeyedUnarchiver unarchiveObjectWithFile:_personFilePath];
    
}

//将浏览记录保存到本地
- (BOOL)saveBrowseListToLocation {
    
    NSArray *_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *_documentPath = [_paths lastObject];
    NSLog(@"%@",_documentPath);
    NSString *_personFilePath = [_documentPath stringByAppendingPathComponent:@"browseList.plist"];
    
//    //实例化一个可变二进制数据的对象
//    NSMutableData *_writingData = [NSMutableData data];
//    //根据_writingData创建归档器对象
//    NSKeyedArchiver *_archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:_writingData];
//    //对指定数据做归档，并将归档数据写入到_writingData中
//    [_archiver encodeObject:memberInfo forKey:@"memberInfoModel"];
//    //完成归档
//    [_archiver finishEncoding];
    
    //将_writingData写入到指定文件路径

    if (self.mybrowseListArr != nil) {
        
        BOOL result = [NSKeyedArchiver archiveRootObject:self.mybrowseListArr toFile:_personFilePath];;
        
        NSLog(@"%@",result ? @"写入文件成功" : @"写入文件失败");
        return result;
    }else {
        return NO;
    }
    
}

//添加浏览记录
- (BOOL)addBrowseListActionWithBrowseProduct:(ProductDetailModel *)browseProduct {
    //先看看是否添加的有这个元素
    BOOL isCanAdd = YES;
    for (ProductDetailModel *tempModel in self.mybrowseListArr) {
        if ([tempModel.productModel.productFormatID isEqualToString:browseProduct.productModel.productFormatID]) {
            isCanAdd = NO;
        }
    }
    
    //这个产品可以添加到里面
    if (isCanAdd == YES) {
        //最多保存20条数据
        if (self.mybrowseListArr.count > 19) {
            //删除第一个数据
            [self.mybrowseListArr removeObjectAtIndex:0];
        }
        
        [self.mybrowseListArr addObject:browseProduct];
        //保存到本地
        BOOL addResult = [self saveBrowseListToLocation];
        if (addResult == NO) {
            //如果添加失败，就恢复原状
            [self.mybrowseListArr removeObject:browseProduct];
        }
        
        return addResult;

    }else {
        return NO;
    }
    
}
//删除浏览记录
- (BOOL)deleteBrowseListActionWithBrowseWithIndex:(NSInteger)deleteIndex {
    
    ProductDetailModel *deleteModel = self.mybrowseListArr[deleteIndex];
    
    [self.mybrowseListArr removeObjectAtIndex:deleteIndex];
    //保存到本地
    BOOL deleteResult = [self saveBrowseListToLocation];
    if (deleteResult == NO) {
        //如果删除失败，就恢复原状
        [self.mybrowseListArr addObject:deleteModel];
    }
    return deleteResult;
}




#pragma mark - 注册登录 -
//密码登录
- (void)loginActionWithUserID:(NSString *)userID withPassword:(NSString *)password withLoginSuccessResult:(SuccessResult )loginSuccessResult withLoginFailResult:(FailResult)loginFailResult {
    //清空原有的个人数据
    self.memberInfoModel = nil;

    NetManager *netManager = [NetManager shareInstance];
    //参数.密码需要md5加密
    NSDictionary *parameter = @{@"loginname": userID, @"password": password,@"facility":@"4",@"isadmin":@"0"};

    [netManager postRequestWithURL:[[InterfaceManager shareInstance] loginPOSTAndPUTUrl] withParameters:parameter withContentTypes:nil withHeaderArr:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        if (operation.response.statusCode == 200) {
            
            if ([[successResult[0] objectForKey:@"code"] isEqualToString:@"0"]) {
                //需要重新设置密码
                loginSuccessResult(successResult);
                
            }else {

                //解析数据，保存到本地
                BOOL locationResult = [self analyzeMemberWithJsonDic:successResult[0] withPassword:password];
                //如果存入本地成功
                if (locationResult == YES) {
                    loginSuccessResult(successResult);
#warning 登录成功发送通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"logedIn" object:self userInfo:nil];
                    //登录成功，就重新请求购物车数量
                    [self httpShoppingCarNumberWithUserid:self.memberInfoModel.u_id withNumberSuccess:nil withNumberFail:nil];
                    
                }else{
                    loginFailResult(@"未知错误，登录失败，请稍后再试");
                }


            }
            
        
        }else{
            loginFailResult(@"未知服务器错误，请联系客服");

        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        
        //得到网络请求状态码
        NSLog(@"%ld -- %@",operation.response.statusCode,[operation.responseObject objectForKey:@"Message"]);

        if (operation.response.statusCode == 400 ) {
            loginFailResult([operation.responseObject objectForKey:@"Message"]);
        }else if(operation.response.statusCode == 500) {
            loginFailResult(@"未知服务器错误，请联系客服");
        }else {
            loginFailResult(@"网络连接失败，请检查网络后重试");
        }
        
    }];
}


//验证码登录
- (void)loginActionWithMobile:(NSString *)mobile withMobileCode:(NSString *)mobileCode withLoginSuccessResult:(SuccessResult)loginSuccessResult withLoginFailResult:(FailResult)loginFailResult {
    
    //清空原有的个人数据
    self.memberInfoModel = nil;
    //    {"loginname":"admin","password":"3CBFCCCB67766883CF4F03B74A763CDC","facility":"1"}
    NetManager *netManager = [NetManager shareInstance];
    //参数.密码需要md5加密
    NSDictionary *parameter = @{@"tel": mobile, @"code": mobileCode,@"facility":@"4",@"isadmin":@"0"};
    
    [netManager putRequestWithURL:[[InterfaceManager shareInstance] loginPOSTAndPUTUrl] withParameters:parameter withContentTypes:nil withHeaderArr:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        //得到网络请求状态码
        NSLog(@"%ld",operation.response.statusCode);
        if (operation.response.statusCode == 200) {
            //登录成功，解析数据，
            BOOL locationResult = [self analyzeMemberWithJsonDic:successResult[0] withPassword:nil];
            //不需要存入本地，即写死成了YES
            if (locationResult == YES) {
                loginSuccessResult(successResult);
                
#warning 登录成功发送通知
                //登录成功，就重新请求购物车数量
                [self httpShoppingCarNumberWithUserid:self.memberInfoModel.u_id withNumberSuccess:nil withNumberFail:nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"logedIn" object:self userInfo:nil];
                
            }else {
                loginFailResult(@"未知错误，登录失败，请稍后再试");

            }
        }else{
            loginFailResult(@"未知服务器错误，请联系客服");
            
        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        
        //得到网络请求状态码
        NSLog(@"%ld -- %@",operation.response.statusCode,[operation.responseObject objectForKey:@"Message"]);
        
        if (operation.response.statusCode == 400 ) {
            loginFailResult([operation.responseObject objectForKey:@"Message"]);
        }else if(operation.response.statusCode == 500) {
            loginFailResult(@"未知服务器错误，请联系客服");
        }else {
            loginFailResult(@"网络连接失败，请检查网络后重试");
        }
        
    }];

    
}

- (BOOL)analyzeMemberWithJsonDic:(NSDictionary *)jsonDic withPassword:(NSString *)password {
    
    MemberInfoModel *memberInfoModel = [[MemberInfoModel alloc] init];
    [memberInfoModel setValuesForKeysWithDictionary:jsonDic ];

//    memberInfoModel.u_mobile = [[jsonDic objectForKey:@"user"] objectForKey:@"u_mobile"];
    memberInfoModel.userPassword = password;
    if (password == nil) {
        //验证码登录，不需存到本地
        self.memberInfoModel = memberInfoModel;
        return YES;
    }else {
        //账号密码登录，需要存到本地
        //存到本地利用归档
        BOOL saveResult = [self saveMemberInfoModelToLocationWithMemberInfo:memberInfoModel];
        if (saveResult == YES) {
            //存入本地成功
            self.memberInfoModel = memberInfoModel;
            return YES;
        }else{
            return NO;
            
        }

    }
    
}

#pragma mark - 忘记密码 -
- (void)httpForgetPasswordWithMobile:(NSString *)mobile withPassword:(NSString *)password withForgetSuccess:(SuccessResult)forgetSuccess withForgetFail:(FailResult)forgetFail {
    
    NSDictionary *valueDic = @{@"mobile":mobile,@"pwd":[self digest:password]};
    
    //给value加密
    NSString *secretStr = [self digest:[NSString stringWithFormat:@"%@Nongyao_Com001", [self dictionaryToJson:@[valueDic]]]];
    
    NSDictionary *parametersDic = @{@"m":secretStr,@"value":@[valueDic]};
    
    [[NetManager shareInstance] putRequestWithURL:[[InterfaceManager shareInstance] motifyPasswordBase] withParameters:parametersDic withContentTypes:@"string" withHeaderArr:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        
        NSLog(@"%ld",operation.response.statusCode);
        if (operation.response.statusCode == 200) {
            forgetSuccess(@"修改成功");

        }

    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld",operation.response.statusCode);
        id messageInfo = [NSJSONSerialization JSONObjectWithData:operation.responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *messageStr ;
        if ([messageInfo isKindOfClass:[NSString class]]) {
            messageStr = messageInfo;
        }else {
            NSDictionary *messageDic = (NSDictionary *)messageInfo;
            
            messageStr = [messageDic objectForKey:@"Message"];
        }

        forgetFail([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,messageStr]);
    }];
    
    
}

#pragma mark - 发送银行卡号 -
- (void)httpSendBankCardWithTel:(NSString *)telStr withBankType:(NSInteger)bankType withSendBankSuccess:(SuccessResult )sendBankSuccess withSendBankFail:(FailResult)sendBankFail {
    NSDictionary *valueDic = @{@"tel":telStr,@"bankindex":[NSString stringWithFormat:@"%ld", bankType ]};
    
    //给value加密
    NSString *secretStr = [self digest:[NSString stringWithFormat:@"%@Nongyao_Com001", [self dictionaryToJson:@[valueDic]]]];
    
    NSDictionary *parametersDic = @{@"m":secretStr,@"value":@[valueDic]};
    
    [[NetManager shareInstance] postRequestWithURL:[[InterfaceManager shareInstance] sendBankCard] withParameters:parametersDic withContentTypes:@"string" withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%ld",operation.response.statusCode);
        if (operation.response.statusCode == 200) {
            sendBankSuccess(@"发送成功");
        }
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld",operation.response.statusCode);
        id messageInfo = [NSJSONSerialization JSONObjectWithData:operation.responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *messageStr ;
        if ([messageInfo isKindOfClass:[NSString class]]) {
            messageStr = messageInfo;
        }else {
            NSDictionary *messageDic = (NSDictionary *)messageInfo;
            
            messageStr = [messageDic objectForKey:@"Message"];
        }

        sendBankFail([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,messageStr]);
    }];
    
}

#pragma mark - 消息通知 -
- (NSMutableArray *)messageArr {
    if (_messageArr == nil) {
        self.messageArr = [NSMutableArray array];
    }
    return _messageArr;
}

//消息通知
- (void)httpMessageNotificationWithType:(NSString *)type withTitle:(NSString *)title withKeyword:(NSString *)keyword withIntroduce:(NSString *)introduce withPageindex:(NSInteger )pageIndex withMessageSuccess:(SuccessResult)messageSuccess withMessageFail:(FailResult)messageFail {
    
    NSString *url = [NSString stringWithFormat:@"%@?type=%@&title=%@&keyword=%@&introduce=%@&pageindex=%ld&pagesize=10",[[InterfaceManager shareInstance] messageNotificationBase],type,title,keyword,introduce,pageIndex];
    [[NetManager shareInstance] getRequestWithURL:url withParameters:nil withContentTypes:nil withHeaderArr:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%ld",operation.response.statusCode);
        NSLog(@"%@",[self dictionaryToJson:successResult]);

        //如果是pageIndex为1，就是刷新了
        if (pageIndex == 1) {
            self.messageArr = [NSMutableArray array];
        }
        
        
        for (NSDictionary *jsonDic in [successResult objectForKey:@"content"]) {
            
            MessageNotificationModel *messageModel = [[MessageNotificationModel alloc] init];
            [messageModel setValuesForKeysWithDictionary:jsonDic];
            [self.messageArr addObject:messageModel];
        }
        
       
        messageSuccess([successResult objectForKey:@"totalpages"]);
        
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld",operation.response.statusCode);
        messageFail([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,[operation.responseObject objectForKey:@"Message"]]);
    }];
    
    
    
}


- (void)httpMessageDetailInfoWithPestsId:(NSString *)pestsid withDetailInfoSuccess:(SuccessResult)detailInfoSuccess withDetailInfoFail:(FailResult)detailInfoFail {
    NSString *url = [NSString stringWithFormat:@"%@?id=%@&type=id&isfo=1", [[InterfaceManager shareInstance] messageNotificationBase],pestsid ];
    [[NetManager shareInstance] getRequestWithURL:url withParameters:nil withContentTypes:nil withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        if (operation.response.statusCode == 200) {
            
            PestsDetailModel *pestsDetailModel = [[PestsDetailModel alloc] init];
            [pestsDetailModel setValuesForKeysWithDictionary:successResult[0]];
            
            detailInfoSuccess(pestsDetailModel);

        }
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        detailInfoFail([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,[operation.responseObject objectForKey:@"Message"]]);

    }];
}


#pragma mark - MD5加密 -
//  封装字符串加密方法
- (NSString *)digest:(NSString *)sourceStr {
    //把OC要转化为C语言字符串
    const char * cStr = [sourceStr UTF8String];
    
    //得到C语言字符串的长度
    unsigned long cStrLenth = strlen(cStr);
    //  声明一个字符数组,个数为16
    unsigned char theResult[CC_MD5_DIGEST_LENGTH];
    //使用这个函数进行加密。参数1：要加密的字符串；参数2：C语言字符串的长度。参数3：MD5函数声明的密文由16个16进制的字符组成，这个参数，其实就是一个数组首地址的指针，这个数组用来存放这个函数生成16个16进制的字符
    CC_MD5(cStr, (CC_LONG)cStrLenth, theResult);
    
    //遍历这个数组，把他们拼接起来就是加密后的字符串(密文)了
    NSMutableString *secretStr = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        NSLog(@"%02X",theResult[i]);
        //这个数组中的类型是%02X
        [secretStr appendFormat:@"%02X",theResult[i]];
    }
    return secretStr;
}

#pragma mark - 归档，将个人信息存入本地 - 
//归档 写入沙盒
- (BOOL)saveMemberInfoModelToLocationWithMemberInfo:(MemberInfoModel *)memberInfo {
    NSArray *_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *_documentPath = [_paths lastObject];
    NSLog(@"%@",_documentPath);
    NSString *_personFilePath = [_documentPath stringByAppendingPathComponent:@"memberInfoModel.archiver"];
    
    //实例化一个可变二进制数据的对象
    NSMutableData *_writingData = [NSMutableData data];
    //根据_writingData创建归档器对象
    NSKeyedArchiver *_archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:_writingData];
    //对指定数据做归档，并将归档数据写入到_writingData中
    [_archiver encodeObject:memberInfo forKey:@"memberInfoModel"];
    //完成归档
    [_archiver finishEncoding];
    
    //将_writingData写入到指定文件路径
    return  [_writingData writeToFile:_personFilePath atomically:YES];
}

//反归档，从沙盒中读取
- (BOOL)readMemberInfoModelFromLocation {
    NSArray *_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *_documentPath = [_paths lastObject];
    NSLog(@"%@",_documentPath);
    
    NSString *_personFilePath = [_documentPath stringByAppendingPathComponent:@"memberInfoModel.archiver"];
    //获取二进制字节流对象
    NSData *_readingData = [NSData dataWithContentsOfFile:_personFilePath];
    //通过_readingData对象来创建解档器对象
    NSKeyedUnarchiver *_unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:_readingData];
    if (_unarchiver == nil) {
        return NO;
    }else {
        //对二进制字节流做解档操作
        MemberInfoModel *membermodel = [_unarchiver decodeObjectForKey:@"memberInfoModel"];
        //完成解档
        [_unarchiver finishDecoding];
        //将从沙盒读取的个人信息，赋给当前的单例model
        if (membermodel.u_mobile != nil || ![membermodel.u_mobile isEqualToString:@""]) {
            self.memberInfoModel = membermodel;
            return YES;
        }else{
            return NO;
        }
        
    }
    
}

//是否已经登陆了
- (BOOL)isLoggedInStatus {
    if ([Manager shareInstance].memberInfoModel.u_id != nil && ![[Manager shareInstance].memberInfoModel.u_id isEqualToString:@""]) {
        return YES;
    }else {
        return NO;
    }

}
//退出登录
- (void)logOffAction {
    //清空单例模型
    self.memberInfoModel = nil;
    //清空本地存储的模型
    [self clearMemberInfoFromLocation];
    //清空一些数据个人数据
    self.shoppingCarDataSourceArr = nil;
    self.orderListDataSourceDic = nil;
    self.receiveAddressArr = nil;
    self.myCommentArr = nil;
    self.myFavoriteArr = nil;
    self.cashDateKeyArr = nil;
    self.cashDetailDic = nil;
    self.tradeDateKeyArr = nil;
    self.tradeDetailDic = nil;
    self.myAgentDic = nil;
    self.myWalletDic = nil;
    self.mybrowseListArr = nil;
    self.afterMarketArr = nil;
    //清空一下本地的浏览记录
    [self clearBrowseFromLocation];
    //清空角标
    self.shoppingNumberStr = nil;
    
    
    //发送通知
#warning 退出登录发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"logOff" object:self userInfo:nil];
    //发送通知刷新角标
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshShoppingCarNumber" object:self userInfo:nil];

    
}
//清空本地的用户信息
- (void)clearMemberInfoFromLocation {
    NSArray *_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *_documentPath = [_paths lastObject];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *memberInfoPath = [_documentPath stringByAppendingPathComponent:@"memberInfoModel.archiver"];
    
    BOOL isExists = [fileManager fileExistsAtPath:memberInfoPath];
    
    if (isExists) {
        
        NSError *err;
        
        [fileManager removeItemAtPath:memberInfoPath error:&err];
        
    }
}

//清空本地的浏览记录
- (void)clearBrowseFromLocation {
    NSArray *_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *_documentPath = [_paths lastObject];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *memberInfoPath = [_documentPath stringByAppendingPathComponent:@"browseList.plist"];
    
    BOOL isExists = [fileManager fileExistsAtPath:memberInfoPath];
    
    if (isExists) {
        
        NSError *err;
        
        [fileManager removeItemAtPath:memberInfoPath error:&err];
        
    }

}



//获取手机验证码
- (void)httpMobileCodeWithMobileNumber:(NSString *)mobileNumber withCodeSuccessResult:(SuccessResult)codeSuccessResult withCodeFailResult:(FailResult)codeFailResult {
    
    NSDictionary *valueDic = @{@"tel":mobileNumber};
    
    //给value加密
    NSString *secretStr = [self digest:[NSString stringWithFormat:@"%@Nongyao_Com001", [self dictionaryToJson:@[valueDic]]]];
    
    NSDictionary *parametersDic = @{@"m":secretStr,@"value":@[valueDic]};
    
    [[NetManager shareInstance] postRequestWithURL:[[InterfaceManager shareInstance] mobileCodePOST] withParameters:parametersDic withContentTypes:@"string" withHeaderArr:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%ld",operation.response.statusCode);
        codeSuccessResult(@"200");
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"请求失败 %ld--%@",operation.response.statusCode,[operation.responseObject objectForKey:@"Message"]);
        id messageInfo = [NSJSONSerialization JSONObjectWithData:operation.responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *messageStr ;
        if ([messageInfo isKindOfClass:[NSString class]]) {
            messageStr = messageInfo;
        }else {
            NSDictionary *messageDic = (NSDictionary *)messageInfo;
            
            messageStr = [messageDic objectForKey:@"Message"];
        }

        codeFailResult([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,messageStr]);
    }];
    
}

//检验手机验证码
- (void)httpCheckMobileCodeWithMobileNumber:(NSString *)mobileNumber withCode:(NSString *)code withCodeSuccessResult:(SuccessResult)codeSuccessResult withCodeFailResult:(FailResult)codeFailResult {
    [[NetManager shareInstance] getRequestWithURL:[[InterfaceManager shareInstance] checkMobileCodeWithMobileNumber:mobileNumber withCode:code] withParameters:nil withContentTypes:@"string" withHeaderArr:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%ld",operation.response.statusCode);
        codeSuccessResult(@"200");
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {

        id messageInfo = [NSJSONSerialization JSONObjectWithData:operation.responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *messageStr ;
        if ([messageInfo isKindOfClass:[NSString class]]) {
            messageStr = messageInfo;
        }else {
            NSDictionary *messageDic = (NSDictionary *)messageInfo;
            
            messageStr = [messageDic objectForKey:@"Message"];
        }

        codeFailResult([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,messageStr]);
    }];
}

//注册
- (void)httpRegisterWithMobileNumber:(NSString *)mobileNumber withPassword:(NSString *)password withUserType:(NSString *)usertType withAreaId:(NSString *)areaId withRegisterSuccess:(SuccessResult )registerSuccessResult withRegisterFailResult:(FailResult)registerFailResult {
    
    password = [self digest:password];
    
//    NSDictionary *valueDic = @{@"password":password,@"usertype":usertType,@"username":mobileNumber,@"email":@"",@"mobile":mobileNumber,@"qq":@"",@"areaid":areaId};
    
    NSArray *valueArr = @[@{@"password":password},@{@"usertype":usertType},@{@"username":mobileNumber},@{@"email":@""},@{@"mobile":mobileNumber},@{@"qq":@""},@{@"areaid":areaId},@{@"status":@"1"}];
    
    NSString *newJsonStr = [self changeJsonStrSortWithOldStr:[self dictionaryToJson:valueArr]];
    
    //给value加密
    NSString *secretStr = [self digest:[NSString stringWithFormat:@"%@Nongyao_Com001", newJsonStr]];
    
    NSString *parametersStr = [NSString stringWithFormat:@"{\"m\":\"%@\",\"value\":%@}",secretStr,newJsonStr];
    
    
    [[NetManager shareInstance] postRequestWithURL:[[InterfaceManager shareInstance] userBase] withParameters:parametersStr withContentTypes:@"string" withHeaderArr:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        
//        NSLog(@"%@",[[NSString alloc] initWithData:successResult encoding:NSUTF8StringEncoding]  );
        NSLog(@"%ld",operation.response.statusCode);
        registerSuccessResult(@"注册成功");
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        id messageInfo = [NSJSONSerialization JSONObjectWithData:operation.responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *messageStr ;
        if ([messageInfo isKindOfClass:[NSString class]]) {
            messageStr = messageInfo;
        }else {
            NSDictionary *messageDic = (NSDictionary *)messageInfo;
            
            messageStr = [messageDic objectForKey:@"Message"];
        }

        registerFailResult([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,messageStr]);
                                 
    }];
    
}


//注册代理商
- (void)httpRegisterDelegateWithTrueName:(NSString *)trueName withPhone:(NSString *)phone withAreaId:(NSString *)areaId withRegisterSuccessResult:(SuccessResult)registerSuccessResult withRegisterFailResult:(FailResult)registerFailResult {
    
    NetManager *netManager = [NetManager shareInstance];

    NSDictionary *valueDic = @{@"name":trueName,@"tel":phone,@"areaid":areaId};

    //给value加密
    NSString *secretStr = [self digest:[NSString stringWithFormat:@"%@Nongyao_Com001", [self dictionaryToJson:@[valueDic]]]];
    
    NSDictionary *parametersDic = @{@"m":secretStr,@"value":@[valueDic]};

    [netManager postRequestWithURL:[[InterfaceManager shareInstance] AgentMerchantsBase] withParameters:parametersDic withContentTypes:@"string" withHeaderArr:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%ld",operation.response.statusCode);
        if (operation.response.statusCode == 200) {
            registerSuccessResult(@"我们正在审核中，请耐心等待");
        }else {
            registerFailResult(@"请稍后再试，或者联系客服");
        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {

        id messageInfo = [NSJSONSerialization JSONObjectWithData:operation.responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *messageStr ;
        if ([messageInfo isKindOfClass:[NSString class]]) {
            messageStr = messageInfo;
        }else {
            NSDictionary *messageDic = (NSDictionary *)messageInfo;
            
            messageStr = [messageDic objectForKey:@"Message"];
        }

        registerFailResult([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,messageStr]);
    }];
    
}

//注册时 检验是否注册了
- (void)httpCheckIsUserRegisterWithMobile:(NSString *)mobile withIsRegisterSuccess:(SuccessResult )isRegisterSuccess withIsRegisterFail:(FailResult)isRegisterFail {
    NSString *url = [NSString stringWithFormat:@"%@?mobile=%@", [[InterfaceManager shareInstance] isUserRegisterBase],mobile];
    [[NetManager shareInstance] getRequestWithURL:url withParameters:nil withContentTypes:@"string" withHeaderArr:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%ld",operation.response.statusCode);
        
        if (operation.response.statusCode == 200) {
            isRegisterSuccess(@"该手机号码未注册");

        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld",operation.response.statusCode);

        if (operation.response.statusCode == 400) {
            isRegisterFail(@"该手机好已经注册了");
        }else {
            isRegisterFail([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,[operation.responseObject objectForKey:@"Message"]]);
        }

    }];
    
}

//登录时，检查是否注册了
- (void)httpCheckIsUserRegisterForLoginWithMobile:(NSString *)mobile withIsRegisterSuccess:(SuccessResult )isRegisterSuccess withIsRegisterFail:(FailResult)isRegisterFail {
    NSString *url = [NSString stringWithFormat:@"%@?mobile=%@&s", [[InterfaceManager shareInstance] isUserRegisterBase],mobile];
    [[NetManager shareInstance] getRequestWithURL:url withParameters:nil withContentTypes:@"string" withHeaderArr:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%ld",operation.response.statusCode);
        
        if (operation.response.statusCode == 200) {
            isRegisterSuccess(@"该手机号码已经注册");
            
        }
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld",operation.response.statusCode);
        
        if (operation.response.statusCode == 400) {
            isRegisterFail(@"该手机号未注册了");
        }else {
            isRegisterFail([NSString stringWithFormat:@"%ld-%@",operation.response.statusCode,[operation.responseObject objectForKey:@"Message"]]);
        }
        
    }];
    
}


#pragma mark - 图片连接处理 -
- (NSURL *)webImageURlWith:(NSString *)imageUrlStr {
    if ([imageUrlStr containsString:@"http://"]) {
        return [NSURL URLWithString:imageUrlStr];
    }else{
        return [NSURL URLWithString:[NSString stringWithFormat:@"http://ima.ertj.cn:8002/%@",imageUrlStr]];

    }
}

#pragma mark - 压缩 -
- (UIImage *)compressOriginalImage:(UIImage *)originalImage toMaxDataSizeKBytes:(CGFloat)size {
    //声明压缩图片 并且将原图赋值给要压缩的图片
    UIImage *scaleImage = [[UIImage alloc] init];
    scaleImage = [self imageWithImage:originalImage scaledToSize:originalImage.size];
    
    //计算原来的大小
    NSData *tempData = UIImageJPEGRepresentation(originalImage, 1.0);
    
    CGFloat tempM = tempData.length/1024.0;
    //默认比例
    CGFloat scaleFloat = 0.9;
    while (tempM > size && scaleFloat > 0) {
        //        NSLog(@"压缩比例%f",scaleFloat);
        //        NSLog(@"%f--%f",originalImage.size.width,originalImage.size.height);
        //        NSLog(@"%f--%f",originalImage.size.width*scaleFloat, originalImage.size.height*scaleFloat);
        //太大了，需要压缩
        scaleImage = [self imageWithImage:originalImage scaledToSize:CGSizeMake(originalImage.size.width*scaleFloat, originalImage.size.height*scaleFloat)];
        //将压缩的图片转成data格式.
        tempData = UIImageJPEGRepresentation(scaleImage, 1.0);
        tempM = tempData.length/1024.0;
        //将压缩比例调小，以便一次压缩
        scaleFloat -= 0.05;
        
    }
    //压缩完毕后
    
    //    NSData *orData = UIImageJPEGRepresentation(originalImage, 1.0);
    //    NSData *scData = UIImageJPEGRepresentation(scaleImage, 1.0);
    
    return scaleImage;
    
}

- (UIImage *)imageWithImage:(UIImage*)image
               scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
    
}


#pragma mark - 其他 -
//上传图片附件
- (void)uploadImageWithUploadImage:(UIImage *)uploadImage withUploadSuccess:(SuccessResult )uploadSuccess withUploadFail:(FailResult)uploadFail {

    NSString *url = [[InterfaceManager shareInstance]uploadImage];
    
    NSArray *imageInfo = [self image2DataURL:uploadImage];
    //imageInfo 下标0是类型 下标1是base64字符串
    NSDictionary *valueDic = @{@"ext":imageInfo[0],@"file":imageInfo[1]};
    
    //给value加密
    NSString *secretStr = [self digest:[NSString stringWithFormat:@"%@Nongyao_Com001", [self dictionaryToJson:@[valueDic]]]];
    
    NSDictionary *parametersDic = @{@"m":secretStr,@"value":@[valueDic]};
    [[NetManager shareInstance] postRequestWithURL:url withParameters:parametersDic withContentTypes:nil withHeaderArr:@[@{@"Authorization":self.memberInfoModel.token}] withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
        NSLog(@"%ld",operation.response.statusCode);

        NSString *imgPath = [[successResult objectForKey:@"path"] objectAtIndex:0];
        uploadSuccess(imgPath);
        
    } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
        NSLog(@"%ld",operation.response.statusCode);
        uploadFail(@"上传图片失败");
    }];
    

}

//图片  ->  base64
- (BOOL) imageHasAlpha: (UIImage *) image
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}
- (NSArray *) image2DataURL: (UIImage *) image
{
    NSData *imageData = nil;
    NSString *mimeType = nil;
    
    if ([self imageHasAlpha: image]) {
        imageData = UIImagePNGRepresentation(image);
        mimeType = @".png";
    } else {
        imageData = UIImageJPEGRepresentation(image, 1.0f);
        mimeType = @".jpeg";
    }
    //0是类型，1是base64转码
    NSString *base64Str = [NSString stringWithFormat:@"%@",[imageData base64EncodedStringWithOptions:0]];
    NSArray *infoArr = @[mimeType,base64Str];
    return infoArr;
}


//将字典变为json格式的字符串 -
- (NSString *)dictionaryToJson:(id )dic {
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *tempStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    tempStr = [tempStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    tempStr = [tempStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    return tempStr;
}

//处理字典顺序
- (NSString *)changeJsonStrSortWithOldStr:(NSString *)oldJsonStr {
    oldJsonStr = [oldJsonStr stringByReplacingOccurrencesOfString:@"{" withString:@""];
    oldJsonStr = [oldJsonStr stringByReplacingOccurrencesOfString:@"}" withString:@""];
    oldJsonStr = [oldJsonStr stringByReplacingOccurrencesOfString:@"[" withString:@"{"];
    oldJsonStr = [oldJsonStr stringByReplacingOccurrencesOfString:@"]" withString:@"}"];
    oldJsonStr = [NSString stringWithFormat:@"[%@]",oldJsonStr];
    
    return oldJsonStr;
}

//获取当前时间
- (NSString *)getNowTimeStr {
    NSDate *date = [NSDate date]; // 获得时间对象
    NSDateFormatter *forMatter = [[NSDateFormatter alloc] init];
    
    [forMatter setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
    
    NSString *dateStr = [forMatter stringFromDate:date];
    NSLog(@"%@",dateStr);
    return dateStr;
}

//地区信息懒加载、
- (NSArray *)areaArr {
    if (!_areaArr ) {
        self.areaArr = [NSArray array];
    }
    return _areaArr;
}
//获取地区信息
- (void)httpAreaTreeWithSuccessAreaInfo:(SuccessResult )successAreaInfo withFailAreaInfo:(FailResult)failAreaInfo {
    //地区信息的存储的本地路径
    NSArray *_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"沙盒文件夹路径 = %@",_paths);
    NSString *_documentPath = [_paths lastObject];
    //为数组指定写入的文件路径，在documents文件下
    NSString *_areaInfoPath = [_documentPath stringByAppendingPathComponent:@"areaInfo.txt"];
    
    //从路径读取地区信息
    NSArray *areaInfoArr = [NSArray arrayWithContentsOfFile:_areaInfoPath];

    //如果有信息就直接返回，如果没有，就网络请求
    if (areaInfoArr != nil && areaInfoArr.count > 0) {
        self.areaArr = areaInfoArr;
        //有信息，直接返回
        NSLog(@"读取地理信息");
        successAreaInfo( self.areaArr);

    }else {
        
        //没有信息 网络请求
        [[NetManager shareInstance] getRequestWithURL:[[InterfaceManager shareInstance] getAreaTree] withParameters:nil withContentTypes:nil withHeaderArr:nil withSuccessResult:^(AFHTTPRequestOperation *operation, id successResult) {
            if (operation.response.statusCode == 200) {
                NSLog(@"网络请求");
                self.areaArr = successResult;
                
                //将请求的地区信息存储到本地
                [self.areaArr writeToFile:_areaInfoPath atomically:YES];
                //返回
                successAreaInfo(self.areaArr);
            }
            
        } withError:^(AFHTTPRequestOperation *operation, NSError *errorResult) {
            NSLog(@"%ld",operation.response.statusCode);
            failAreaInfo(@"地区读取失败，请稍后再试");
        }];
        
    }
}

//从NSdate中得到年月日等信息
- (NSDateComponents *)dateStrToDateAndComponentWithDatestr:(NSString *)dateStr {

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-ddHH:mm:ss"];
    NSDate *newDate = [formatter dateFromString:dateStr];
    NSLog(@"newDate = %@", newDate);
    
    //从NSDate得到年月日，时分秒等信息
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComps = [cal components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekOfYear|NSCalendarUnitTimeZone fromDate:newDate];
    
    return dateComps;
    
}


//截屏
-(UIImage *)screenShot {
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [keyWindow bounds];
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0); //currentView 当前的view  创建一个基于位图的图形上下文并指定大小为

    [keyWindow.layer renderInContext:UIGraphicsGetCurrentContext()];//renderInContext呈现接受者及其子范围到指定的上下文
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();//返回一个基于当前图形上下文的图片
    UIGraphicsEndImageContext();//移除栈顶的基于当前位图的图形上下文
    
    return viewImage;
//    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);//然后将该图片保存到图片图

}

@end
