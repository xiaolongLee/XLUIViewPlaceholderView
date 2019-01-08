//
//  UIView+PlaceholderView.h
//  XLUIViewPlaceholderViewDemo
//
//  Created by Mac-Qke on 2019/1/8.
//  Copyright © 2019 Mac-Qke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/** UIView的占位图类型 */
typedef NS_ENUM(NSInteger, XLPlaceholderViewType){
    /** 没网*/
    XLPlaceholderViewTypeNoNetwork,
    /** 没商品*/
    XLPlaceholderViewTypeNoGoods,
    /** 没评论 */
    XLPlaceholderViewTypeNoComment
};
@interface UIView (PlaceholderView)
/** 占位图 */
@property (nonatomic, strong,readonly) UIView *xl_placeholderView;
#pragma mark - 展示占位图
/**
 展示UIView及其子类的占位图，大小和view一样（本质是在这个view上添加一个自定义view）
 
 @param type 占位图类型
 @param reloadBlock 重新加载回调的block
 */
- (void)xl_showPlaceholderViewWithType:(XLPlaceholderViewType)type reloadBlock:(void(^)(void))reloadBlock;
#pragma mark - 主动移除占位图
/**
 主动移除占位图
 占位图会在你点击“重新加载”按钮的时候自动移除，你也可以调用此方法主动移除
 */
- (void)xl_removePlaceholderView;
@end

NS_ASSUME_NONNULL_END
