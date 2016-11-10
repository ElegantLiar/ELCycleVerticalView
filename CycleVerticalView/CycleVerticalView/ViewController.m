//
//  ViewController.m
//  CycleVerticalView
//
//  Created by etouch on 16/11/1.
//  Copyright © 2016年 EL. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /*  使用          进入其他二级页面时请调用stopAnimation 否则有几率出现内存上升 数据混乱
     1. 创建view
     2. 设置数据源
     3. 设置代理
     **/
    
    ELCycleVerticalView *cycVerticalView = [[ELCycleVerticalView alloc] initWithFrame:CGRectMake(80, 200, 200, 50)];
    cycVerticalView.delegate = self;
    [self.view addSubview:cycVerticalView];
    cycVerticalView.animationTime = 0.1;
    cycVerticalView.showTime = 1.5;
    cycVerticalView.dataSource = @[
                                   @"我是第1条",
                                   @"我是第2条",
                                   @"我是第3条",
                                   @"我是第4条"
                                   ];
    
}

- (void)elCycleVerticalView:(ELCycleVerticalView *)view didClickItemIndex:(NSInteger)index{
    NSLog(@"%ld", index);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
