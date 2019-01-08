//
//  ViewController.m
//  XLUIViewPlaceholderViewDemo
//
//  Created by Mac-Qke on 2019/1/8.
//  Copyright © 2019 Mac-Qke. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveCocoa.h"
#import "RACEXTScope.h"
#import "SecondViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(90, 90, 200, 30);
    [self.view addSubview:button];
    [button setTitle:@"去下一页" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    
    @weakify(self);
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        SecondViewController  *secondVC = [SecondViewController new];
        [self.navigationController pushViewController:secondVC animated:YES];
    }];
}


@end
