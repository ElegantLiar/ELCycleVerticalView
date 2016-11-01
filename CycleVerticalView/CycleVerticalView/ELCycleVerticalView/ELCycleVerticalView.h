//
//  ELCycleVerticalView.h
//  CycleVerticalView
//
//  Created by etouch on 16/11/1.
//  Copyright © 2016年 EL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ELCycleVerticalView;
@protocol ELCycleVerticalViewDelegate <NSObject>
// 当前点击数据源的第几个item
- (void)elCycleVerticalView:(ELCycleVerticalView *)view didClickItemIndex:(NSInteger)index;
@end

@interface ELCycleVerticalView : UIView

@property (nonatomic, strong) NSArray *dataSource;          // 数据源
@property (nonatomic, weak) id<ELCycleVerticalViewDelegate> delegate;

// 开启动画 (主要用于进入其他页面返回时开启)
- (void)startAnimation;

// 关闭动画 (进入其他页面时调用)
- (void)stopAnimation;
@end
