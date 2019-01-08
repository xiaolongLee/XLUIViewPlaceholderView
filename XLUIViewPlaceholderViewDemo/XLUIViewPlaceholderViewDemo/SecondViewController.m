//
//  SecondViewController.m
//  XLUIViewPlaceholderViewDemo
//
//  Created by Mac-Qke on 2019/1/8.
//  Copyright © 2019 Mac-Qke. All rights reserved.
//

#import "SecondViewController.h"
#import "UIView+PlaceholderView.h"
#import "SVProgressHUD.h"
#import "RACEXTScope.h"
#import "Masonry.h"
@interface SecondViewController ()
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    for (int i =0 ; i < 3; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(90, 90 + i * 80, 200, 40)];
        [self.tableView addSubview:button];
        button.tag = 100 + i;
        button.backgroundColor = [UIColor orangeColor];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        switch (i) {
            case 0:
                {
                    [button setTitle:@"模拟获取数据" forState:UIControlStateNormal];
                }
                break;
            case 1:
            {
                [button setTitle:@"没网" forState:UIControlStateNormal];
            }
                break;
            case 2:
            {
                [button setTitle:@"评论数量0" forState:UIControlStateNormal];
            }
                break;
            default:
                break;
        }
    }
    
    [SVProgressHUD setMaximumDismissTimeInterval:1];
}

- (void)buttonClicked:(UIButton *)sender {
    switch (sender.tag) {
        case 100: // 模拟获取数据
        {
            [self getData];
        }
            break;
         case 101: // 没网
        {
            @weakify(self);
            [self.view xl_showPlaceholderViewWithType:XLPlaceholderViewTypeNoNetwork reloadBlock:^{
                @strongify(self);
                [SVProgressHUD showSuccessWithStatus:@"重新加载按钮点击"];
                self.view.backgroundColor = [UIColor redColor];
            }];
        }
            break;
            
         case 102:
        {
            [self.tableView xl_showPlaceholderViewWithType:XLPlaceholderViewTypeNoComment reloadBlock:nil];
            self.tableView.xl_placeholderView.backgroundColor = [UIColor redColor];
            // 重新设置占位图约束
            [self.tableView.xl_placeholderView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self.view);
                make.top.mas_equalTo(self.tableView).mas_offset(50);
                make.bottom.mas_equalTo(self.view).mas_offset(-30);
            }];
            
            // 1秒后调用方法主动移除占位图
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD showInfoWithStatus:@"调用方法移除占位图"];
                [self.tableView xl_removePlaceholderView];
            });
            
        }
            break;
        default:
            break;
    }
}

// 模拟获取数据
- (void)getData{
    [SVProgressHUD show];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 是否成功获取数据
        BOOL  isGetData = arc4random() % 2;
        // 是否数据源为空
        BOOL isEmpty = arc4random() % 2;
        
        if (isGetData) {
            if (isEmpty) {
               // 展示空数据占位图
                [self.tableView xl_showPlaceholderViewWithType:XLPlaceholderViewTypeNoGoods reloadBlock:nil];
                [SVProgressHUD showWithStatus:@"数据源空"];
                
            }else{
               // 展示数据
                [SVProgressHUD showSuccessWithStatus:@"数据正常展示"];
            }
        }else{
            @weakify(self);
            // 未成功获取数据，展示无网占位图
            [self.tableView xl_showPlaceholderViewWithType:XLPlaceholderViewTypeNoNetwork reloadBlock:^{
                @strongify(self);
                [self getData];
            }];
            [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        }
    });
    
}

- (void)dealloc {
    NSLog(@"页面2已释放");
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
