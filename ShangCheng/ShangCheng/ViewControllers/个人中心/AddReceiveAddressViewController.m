//
//  AddReceiveAddressViewController.m
//  ShangCheng
//
//  Created by TongLi on 2016/12/30.
//  Copyright © 2016年 TongLi. All rights reserved.
//  新增收货地址，或者编辑收货地址

#import "AddReceiveAddressViewController.h"
#import "SelectAddressView.h"
@interface AddReceiveAddressViewController ()
@property (weak, nonatomic) IBOutlet UITextField *receiverNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *receiveAddressTextField;



@property (weak, nonatomic) IBOutlet UIButton *areaButton;
//设为默认地址button
@property (weak, nonatomic) IBOutlet UIButton *defaultAddressButton;
//拷贝一个副本，编辑是对其做操作，
@property (nonatomic,strong)ReceiveAddressModel *addressModelCopy;
//地区选择器
@property (nonatomic,strong) SelectAddressView *selectAddressView;

@end

@implementation AddReceiveAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //加载地区pickView
    self.selectAddressView = [[[NSBundle mainBundle] loadNibNamed:@"SelectAddressView" owner:self options:nil] firstObject];
    self.selectAddressView.frame = self.view.frame;
    //首先先隐藏
    self.selectAddressView.hidden = YES;
    [self.view addSubview:self.selectAddressView];
    

    
    if (self.tempReceiveAddressModel != nil) {
        self.title = @"编辑地址";
        //拷贝一个副本，对其做操作
        self.addressModelCopy = [self.tempReceiveAddressModel mutableCopy];
        //把传过来的模型对这个页面的UI进行赋值，即默认值
        [self updateDefalutUIWithModel:self.addressModelCopy];

    }else {
        self.title = @"新增地址";
        
    }
    
        //
    
}



- (void)updateDefalutUIWithModel:(ReceiveAddressModel *)model {
    self.receiverNameTextField.text = model.receiverName;
    self.mobileTextField.text = model.receiveMobile;
    [self.areaButton setTitle:[NSString stringWithFormat:@"%@ %@ %@",model.capitalname,model.cityname,model.countyname] forState:UIControlStateNormal];
    
    self.receiveAddressTextField.text = model.receiveAddress;
    //查看是否是默认地址
    if (model.defaultAddress == YES) {
        self.defaultAddressButton.backgroundColor = [UIColor redColor];
    }else {
        self.defaultAddressButton.backgroundColor = [UIColor lightGrayColor];
    }

}


- (IBAction)areaButtonAction:(UIButton *)sender {
    //得到地区数据，然后显示
    Manager *manager = [Manager shareInstance];
    if (manager.areaArr.count > 0 ) {
        //说明有数据
        NSLog(@"地区成功1");
        //显示pickView
        [self showAddressPickView];
        
    }else {
        //没有数据，就从本地获取或者网络请求
        [manager httpAreaTreeWithSuccessAreaInfo:^(id successResult) {
            NSLog(@"地区成功2");
            //刷新pickView
            [self showAddressPickView];
            
        } withFailAreaInfo:^(NSString *failResultStr) {
            NSLog(@"地区请求失败");
        }];
    }
}

//显示pickView
- (void)showAddressPickView {
    [self.selectAddressView showPickerViewEnterSelectAreaWithAreaInfo:^(NSString *areaId, NSString *shengStr, NSString *shiStr, NSString *quStr) {
        //
        NSLog(@"地区id%@",areaId);
        
        [self.areaButton setTitle:[NSString stringWithFormat:@"%@ %@ %@",shengStr,shiStr,quStr] forState:UIControlStateNormal];
        self.addressModelCopy.areaID = areaId;
        self.addressModelCopy.capitalname = shengStr;
        self.addressModelCopy.cityname = shiStr;
        self.addressModelCopy.countyname = quStr;
        
        
    }];
}

- (IBAction)defaultAddressButtonAction:(UIButton *)sender {
    self.addressModelCopy.defaultAddress = !self.addressModelCopy.defaultAddress;
    //改变默认地址按钮UI
    if (self.addressModelCopy.defaultAddress == YES) {
        self.defaultAddressButton.backgroundColor = [UIColor redColor];
    }else {
        self.defaultAddressButton.backgroundColor = [UIColor lightGrayColor];
    }

}

//添加收货地址
- (IBAction)addReceiveAddressButtonAction:(UIButton *)sender {
    
    
//    Manager *manager = [Manager shareInstance];
//    if (self.tempReceiveAddressModel != nil) {
//        //修改
//       /*
//        1、改变收货人
//        2、改变手机号
//        3、改变详细地址
//        注：默认地址和地去已经修改
//        */
//        self.addressModelCopy.receiverName = self.receiverNameTextField.text;
//        self.addressModelCopy.receiveMobile = self.mobileTextField.text;
//        self.addressModelCopy.receiveAddress = self.receiveAddressTextField.text;
//        //发起数据请求修改
//        [manager motifyReceiveAddressWithReceiveAddressModel:self.addressModelCopy withMotifySuccess:^(id successResult) {
//            
//        } withMotifyFail:^(NSString *failResultStr) {
//            
//        }];
//        
//    }else {
//        //新增
//    }
    

    
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
