//
//  UIView+PlaceholderView.m
//  XLUIViewPlaceholderViewDemo
//
//  Created by Mac-Qke on 2019/1/8.
//  Copyright © 2019 Mac-Qke. All rights reserved.
//

#import "UIView+PlaceholderView.h"
#import "Masonry.h"
#import "ReactiveCocoa.h"
#import "RACEXTScope.h"
#import <objc/runtime.h>

@interface UIView ()
/** 用来记录UIScrollView最初的scrollEnabled */
@property (nonatomic, assign) BOOL xl_originalScrollEnabled;
@end

@implementation UIView (PlaceholderView)

static void *placeholderViewKey = &placeholderViewKey;
static void *originalScrollEnabledKey = &originalScrollEnabledKey;


- (UIView *)xl_placeholderView {
    return objc_getAssociatedObject(self, &placeholderViewKey);
}

- (void)setXl_placeholderView:(UIView * _Nonnull)xl_placeholderView {
    
    objc_setAssociatedObject(self, &placeholderViewKey, xl_placeholderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)xl_originalScrollEnabled {
    return [objc_getAssociatedObject(self, &originalScrollEnabledKey) boolValue];
}

- (void)setXl_originalScrollEnabled:(BOOL)xl_originalScrollEnabled {
    objc_setAssociatedObject(self, &originalScrollEnabledKey, @(xl_originalScrollEnabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - 展示UIView或其子类的占位图
/**
 展示UIView或其子类的占位图
 
 @param type 占位图类型
 @param reloadBlock 重新加载回调的block
 */

- (void)xl_showPlaceholderViewWithType:(XLPlaceholderViewType)type reloadBlock:(void (^)(void))reloadBlock {
    // 如果是UIScrollView及其子类，占位图展示期间禁止scroll
    if ([self isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self;
        // 先记录原本的scrollEnabled
        self.xl_originalScrollEnabled = scrollView.scrollEnabled;
        // 再将scrollEnabled设为NO
        scrollView.scrollEnabled = NO;
    }
    
    //------- 占位图 -------//
    if (self.xl_placeholderView) {
        [self.xl_placeholderView removeFromSuperview];
        self.xl_placeholderView = nil;
    }
    
    self.xl_placeholderView = [[UIView alloc] init];
    [self addSubview:self.xl_placeholderView];
    self.xl_placeholderView.backgroundColor = [UIColor whiteColor];
    [self.xl_placeholderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(self);
    }];
    
    //------- 图标 -------//
    UIImageView *imageView = [[UIImageView alloc] init];
    [self.xl_placeholderView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(imageView.superview);
        make.centerY.mas_equalTo(imageView.superview).mas_offset(-80);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    
     //------- 描述 -------//
    UILabel *descLabel = [[UILabel alloc] init];
    [self.xl_placeholderView addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(descLabel.superview);
        make.top.mas_equalTo(imageView.mas_bottom).mas_offset(20);
        make.height.mas_equalTo(15);
    }];
    
     //------- 重新加载button -------//
    UIButton *reloadButton = [[UIButton alloc] init];
    [self.xl_placeholderView addSubview:reloadButton];
    [reloadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [reloadButton setTitle:@"重新加载" forState:UIControlStateNormal];
    reloadButton.layer.borderWidth = 1;
    reloadButton.layer.borderColor = [UIColor blackColor].CGColor;
    @weakify(self);
    [[reloadButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        // 执行block回调
        if (reloadBlock) {
            reloadBlock();
        }
        // 从父视图移除
        [self.xl_placeholderView removeFromSuperview];
        self.xl_placeholderView = nil;
        // 复原UIScrollView的scrollEnabled
        if ([self isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)self;
            scrollView.scrollEnabled = self.xl_originalScrollEnabled;
        }
    }];
    
    [reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(reloadButton.superview);
        make.top.mas_equalTo(descLabel.mas_bottom).mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(120, 30));
    }];
    
     //------- 根据type设置不同UI -------//
    switch (type) {
        case XLPlaceholderViewTypeNoNetwork: // 网络不好
            {
                NSString *path = [[NSBundle mainBundle] pathForResource:@"无网" ofType:@"png"];
                imageView.image = [UIImage imageWithContentsOfFile:path];
                descLabel.text = @"网络异常";
            }
            break;
           case XLPlaceholderViewTypeNoGoods: // 没商品
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"无商品" ofType:@"png"];
            imageView.image = [UIImage imageWithContentsOfFile:path];
            descLabel.text = @"一个商品都没有";
        }
            break;
           case XLPlaceholderViewTypeNoComment: // 没评论
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"沙发" ofType:@"png"];
            imageView.image = [UIImage imageWithContentsOfFile:path];
            descLabel.text = @"抢沙发！";
        }
            break;
        default:
            break;
    }
}

#pragma mark - 主动移除占位图
/**
 主动移除占位图
 占位图会在你点击“重新加载”按钮的时候自动移除，你也可以调用此方法主动移除
 */
- (void)xl_removePlaceholderView {
    if (self.xl_placeholderView) {
        [self.xl_placeholderView removeFromSuperview];
        self.xl_placeholderView = nil;
    }
    
    // 复原UIScrollView的scrollEnabled
    if ([self isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self;
        scrollView.scrollEnabled = self.xl_originalScrollEnabled;
    }
    
}
@end
