//
//  ELCycleVerticalSingleView.m
//  CycleVerticalView
//
//  Created by etouch on 16/11/1.
//  Copyright © 2016年 EL. All rights reserved.
//

#import "ELCycleVerticalSingleView.h"

@implementation ELCycleVerticalSingleView{
    UILabel *_textLabel;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    _textLabel = [[UILabel alloc] initWithFrame:self.bounds];
    [self addSubview:_textLabel];
}

- (void)setText:(NSString *)text{
    _text = text;
    _textLabel.text = _text;
}
@end
