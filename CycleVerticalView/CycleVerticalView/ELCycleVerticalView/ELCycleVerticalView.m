//
//  ELCycleVerticalView.m
//  CycleVerticalView
//
//  Created by etouch on 16/11/1.
//  Copyright © 2016年 EL. All rights reserved.
//

#import "ELCycleVerticalView.h"
#import "ELCycleVerticalSingleView.h"

@implementation ELCycleVerticalView{
    CGRect          _topRect;
    CGRect          _middleRect;
    CGRect          _btmRect;
    NSInteger       _indexNow;

    UIButton        *_button;
    
    NSMutableArray  *_animationViewArray;
    NSTimer         *_timer;
    
    ELCycleVerticalSingleView *_tmpAnimationView1;
    ELCycleVerticalSingleView *_tmpAnimationView2;
    
    ELCycleVerticalSingleView *_tmpBtmView;
    ELCycleVerticalSingleView *_tmpMiddleView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _showTime = 3;
        _animationTime = 0.5;
        [self initUI];
    }
    return self;
}

- (void)initUI{
    _middleRect = self.bounds;
    _topRect = CGRectMake(0, -self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
    _btmRect = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
    
    _tmpAnimationView1 = [[ELCycleVerticalSingleView alloc] initWithFrame:_middleRect];
    _tmpAnimationView1.backgroundColor = [UIColor whiteColor];
    [self addSubview:_tmpAnimationView1];
    
    _tmpAnimationView2 = [[ELCycleVerticalSingleView alloc] initWithFrame:_btmRect];
    _tmpAnimationView2.backgroundColor = [UIColor whiteColor];
    [self addSubview:_tmpAnimationView2];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.backgroundColor = [UIColor clearColor];
    _button.frame = _middleRect;
    [_button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_button];
    
    _animationViewArray = [NSMutableArray array];
    [_animationViewArray addObject:_tmpAnimationView1];
    [_animationViewArray addObject:_tmpAnimationView2];
    self.clipsToBounds = YES;
}

- (void)setDataSource:(NSArray *)dataSource{
    _dataSource = dataSource;
    _indexNow = 0;
    [self startAnimation];
}

- (void)startAnimation{
    [self setViewInfo];
    if (_dataSource.count > 1) {
        [self stopTimer];
        _timer = [NSTimer scheduledTimerWithTimeInterval:_showTime target:self selector:@selector(executeAnimation) userInfo:nil repeats:YES];
    }
}

- (void)executeAnimation{
    [self setViewInfo];
    [UIView animateWithDuration:_animationTime delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _tmpMiddleView.frame = _topRect;
        _tmpBtmView.frame = _middleRect;
    }completion:^(BOOL finished){
        if(finished){
            _tmpMiddleView.frame = _btmRect;
            _indexNow++;
        }
    }];
}

- (void)setViewInfo{
    for(ELCycleVerticalSingleView *animationView in _animationViewArray){
        if(animationView.frame.origin.y == 0){
            _tmpMiddleView = animationView;
        }else if (animationView.frame.origin.y > 0){
            _tmpBtmView = animationView;
        }
    }
    _tmpMiddleView.text = _dataSource[_indexNow%(_dataSource.count)];
    if(_dataSource.count > 1){
        _tmpBtmView.text = _dataSource[(_indexNow+1)%(_dataSource.count)];
    }
}

- (void)stopAnimation{
    [self stopTimer];
    [self.layer removeAllAnimations];
}

- (void)stopTimer{
    if(_timer){
        if([_timer isValid]){
            [_timer invalidate];
        }
        _timer = nil;
    }
}

- (void)btnClick{
    if(_delegate && [_delegate respondsToSelector:@selector(elCycleVerticalView:didClickItemIndex:)]){
        [_delegate elCycleVerticalView:self didClickItemIndex:_indexNow%(_dataSource.count)];
    }
}

- (void)dealloc{
    self.delegate = nil;
}

@end
