//
//  ShoppingCarViewController.m
//  ShangCheng
//
//  Created by TongLi on 2016/11/19.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "ShoppingCarViewController.h"
#import "ShoppingCarTableViewCell.h"
#import "Manager.h"
@interface ShoppingCarViewController ()<UITableViewDataSource,UITableViewDelegate>
//判断是否需要刷新
@property (nonatomic,assign)BOOL isRefreshVC;
@property (weak, nonatomic) IBOutlet UITableView *shoppingTableView;

//是否正在编辑
@property (nonatomic,assign)NSInteger isEditing;
//不在编辑
@property (weak, nonatomic) IBOutlet UIView *notEditingView;
//正在编辑
@property (weak, nonatomic) IBOutlet UIView *editingView;
//全选按钮
@property (weak, nonatomic) IBOutlet UIButton *allSelectButton;
//金额label
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation ShoppingCarViewController
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //通知，需要刷新
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshShoppingCarNotification:) name:@"refreshShoppingCarVC" object:nil];

        
    }
    return self;
}

- (void)refreshShoppingCarNotification:(NSNotification *)sender {
    self.isRefreshVC = YES;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.isRefreshVC == YES) {
        //需要刷新
        [self httpShoppingCarVCDataAction];
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self httpShoppingCarVCDataAction];
    
}
//请求数据的操作
- (void)httpShoppingCarVCDataAction {
    Manager *manager = [Manager shareInstance];
    
    [manager httpShoppingCarDataWithUserId:@"93364C0CECBC4F12BDA6B47AF22C8352" WithSuccessResult:^(id successResult) {
        
        [self.shoppingTableView reloadData];
        //刷新了，将bool值变为No
        self.isRefreshVC = NO;
        //计算金额
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[manager selectProductTotalPrice]];
        
    } withFailResult:^(NSString *failResultStr) {
        NSLog(@"请求失败");
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [Manager shareInstance].shoppingCarDataSourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShoppingCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shoppingCarCell" forIndexPath:indexPath];
    Manager *manager = [Manager shareInstance];

    //删除block
    cell.deleteSuccessBlock = ^(NSIndexPath *deletePath) {
        //删除TableView的ui
        [tableView deleteRowsAtIndexPaths:@[deletePath] withRowAnimation:UITableViewRowAnimationNone];
        //刷新一下全选按钮
        if (manager.isAllSelectForShoppingCar == YES) {
            self.allSelectButton.backgroundColor = [UIColor redColor];
        }else{
            self.allSelectButton.backgroundColor = [UIColor lightGrayColor];
        }
        //计算金额
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[manager selectProductTotalPrice]];
    };
    
    //刷新全选block
    cell.totalPriceBlock = ^{
        if (manager.isAllSelectForShoppingCar == YES) {
            self.allSelectButton.backgroundColor = [UIColor redColor];
        }else{
            self.allSelectButton.backgroundColor = [UIColor lightGrayColor];
        }
        //计算金额
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[manager selectProductTotalPrice]];

    };
    
    //刷新UI
    [cell updateCellWithCellIndex:indexPath];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld",indexPath.row);
    
    

}

#pragma mark - 导航栏上的功能 -
//导航栏右边编辑按钮
- (IBAction)editBarButtonAction:(UIBarButtonItem *)sender {
    
    self.isEditing = !self.isEditing;
    
    if (self.isEditing == YES) {
        //正在编辑状态
        sender.title = @"完成";
        self.editingView.hidden = YES;
        self.notEditingView.hidden = NO;
        
        
    }else {
        //不在编辑状态
        sender.title = @"编辑";
        self.editingView.hidden = NO;
        self.notEditingView.hidden = YES;
        
    }
}

#pragma mark - 底部功能 -
//全选
- (IBAction)allSelectButtonAction:(UIButton *)sender {
    
    Manager *manager = [Manager shareInstance];
    //如果现在是全选状态，那么就全不选
    if (manager.isAllSelectForShoppingCar == YES) {
        
        for (ShoppingCarModel *tempModel in manager.shoppingCarDataSourceArr) {
            tempModel.isSelectedShoppingCar = NO;
            
        }
        
    }else {
        for (ShoppingCarModel *tempModel in manager.shoppingCarDataSourceArr) {
            tempModel.isSelectedShoppingCar = YES;
            
        }
    }
    //刷新UI
    [self.shoppingTableView reloadData];
    
    //判断一下是否全选
    [manager isAllSelectForShoppingCarAction];
    //需要刷新全选按钮
    if (manager.isAllSelectForShoppingCar == YES) {
        self.allSelectButton.backgroundColor = [UIColor redColor];
    }else {
        self.allSelectButton.backgroundColor = [UIColor lightGrayColor];
    }
    //计算总价格
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[manager selectProductTotalPrice]];

    
    
    
}


//编辑状态的删除按钮
- (IBAction)editDeleteButtonAction:(UIButton *)sender {
    
    Manager *manager = [Manager shareInstance];
    //设置set为了删除数据源
    NSMutableIndexSet *deleteIndexSet = [NSMutableIndexSet indexSet];
    //从所有产品中，得到选中的产品的下标，即i的值
    for (int i = 0; i < manager.shoppingCarDataSourceArr.count; i++) {
        if ([manager.shoppingCarDataSourceArr[i] isSelectedShoppingCar] == YES) {
            //如果选中了这个产品，那么就将下标加入
            [deleteIndexSet addIndex:i];
            
        }
    }
    //删除
    [[Manager shareInstance] deleteShoppingCarWithProductIndexSet:deleteIndexSet WithSuccessResult:^(id successResult) {
        //刷新UI
        NSMutableArray *deleteIndexArr = [NSMutableArray array];
        //遍历删除的集合，弄成数组
        [(NSIndexSet *)successResult enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
            //
            NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:idx inSection:0];
            [deleteIndexArr addObject:tempIndexPath];
        }];
        [self.shoppingTableView deleteRowsAtIndexPaths:deleteIndexArr withRowAnimation:UITableViewRowAnimationNone];
        
        //需要刷新全选按钮
        if (manager.isAllSelectForShoppingCar == YES) {
            self.allSelectButton.backgroundColor = [UIColor redColor];
        }else {
            self.allSelectButton.backgroundColor = [UIColor lightGrayColor];
        }
        //计算总金额
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[manager selectProductTotalPrice]];

        
    } withFailResult:^(NSString *failResultStr) {
        //删除失败
    }];
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
