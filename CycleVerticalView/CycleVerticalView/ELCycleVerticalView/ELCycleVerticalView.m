//
//  ELCycleVerticalView.m
//  CycleVerticalView
//
//  Created by etouch on 16/11/1.
//  Copyright © 2016年 EL. All rights reserved.
//

#import "ELCycleVerticalView.h"

@implementation ELCycleVerticalView{
    CGRect          _topRect;
    CGRect          _middleRect;
    CGRect          _btmRect;
    NSInteger       _indexNow;
    
    double          _showTime;
    double          _animationTime;
    ELCycleVerticalViewScrollDirection  _direction;

    UIButton        *_button;
    
    NSMutableArray  *_animationViewArray;
    NSTimer         *_timer;
    
    UILabel *_tmpAnimationView1;
    UILabel *_tmpAnimationView2;
    
    UILabel *_tmpTopView;
    UILabel *_tmpBtmView;
    UILabel *_tmpMiddleView;
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
    
    _tmpAnimationView1 = [[UILabel alloc] initWithFrame:_middleRect];
    _tmpAnimationView1.backgroundColor = [UIColor whiteColor];
    [self addSubview:_tmpAnimationView1];
    
    _tmpAnimationView2 = [[UILabel alloc] init];
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

- (void)configureShowTime:(double)showTime
            animationTime:(double)animationTime
                direction:(ELCycleVerticalViewScrollDirection)direction
          backgroundColor:(UIColor *)backgroundColor
                textColor:(UIColor *)textColor font:(UIFont *)font
            textAlignment:(NSTextAlignment)textAlignment{
    _showTime = showTime;
    _animationTime = animationTime;
    _direction = direction;
    _tmpAnimationView1.backgroundColor = _tmpAnimationView2.backgroundColor = backgroundColor;
    _tmpAnimationView1.textColor = _tmpAnimationView2.textColor = textColor;
    _tmpAnimationView1.font = _tmpAnimationView2.font = font;
    _tmpAnimationView1.textAlignment = _tmpAnimationView2.textAlignment = textAlignment;
    _tmpAnimationView2.frame = _direction == ELCycleVerticalViewScrollDirectionDown ? _topRect : _btmRect;
}

- (void)setDirection:(ELCycleVerticalViewScrollDirection)direction{
    _direction = direction;
    _tmpAnimationView2.frame = _direction == ELCycleVerticalViewScrollDirectionDown ? _topRect : _btmRect;
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
        _tmpMiddleView.frame = _direction == ELCycleVerticalViewScrollDirectionDown ? _btmRect : _topRect;
        if (_direction == ELCycleVerticalViewScrollDirectionDown) {
            _tmpTopView.frame = _middleRect;
        } else {
            _tmpBtmView.frame = _middleRect;
        }
    }completion:nil];
    [self performSelector:@selector(finished)
               withObject:nil
               afterDelay:_animationTime];
    
}

- (void)finished{
    _tmpMiddleView.frame = _direction == ELCycleVerticalViewScrollDirectionDown ? _topRect : _btmRect;
    _indexNow++;
}

- (void)setViewInfo{
    if (_direction == ELCycleVerticalViewScrollDirectionDown) {
        if (_tmpAnimationView1.frame.origin.y == 0) {
            _tmpMiddleView = _tmpAnimationView1;
            _tmpTopView = _tmpAnimationView2;
        } else {
            _tmpMiddleView = _tmpAnimationView2;
            _tmpTopView = _tmpAnimationView1;
        }
    } else {
        if (_tmpAnimationView1.frame.origin.y == 0) {
            _tmpMiddleView = _tmpAnimationView1;
            _tmpBtmView = _tmpAnimationView2;
        } else {
            _tmpMiddleView = _tmpAnimationView2;
            _tmpBtmView = _tmpAnimationView1;
        }
    }
    _tmpMiddleView.text = _dataSource[_indexNow%(_dataSource.count)];
    if(_dataSource.count > 1){
        if (_direction == ELCycleVerticalViewScrollDirectionDown) {
            _tmpTopView.text = _dataSource[(_indexNow+1)%(_dataSource.count)];
        } else {
            _tmpBtmView.text = _dataSource[(_indexNow+1)%(_dataSource.count)];
        }
    }
}

- (void)stopAnimation{
    [self stopTimer];
    [self.layer removeAllAnimations];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
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
