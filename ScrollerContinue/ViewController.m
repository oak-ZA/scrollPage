//
//  ViewController.m
//  ScrollerContinue
//
//  Created by 张奥 on 2019/9/23.
//  Copyright © 2019 张奥. All rights reserved.
//

#import "ViewController.h"
#import "ZAScrollerView.h"
#define SCREEN_Width [UIScreen mainScreen].bounds.size.width
#define SCREEN_Height [UIScreen mainScreen].bounds.size.height


@interface ViewController ()<UIScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    ZAScrollerView *scrollView = [[ZAScrollerView alloc] initWithFrame:CGRectMake(0, 200, SCREEN_Width, 200)];
    scrollView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:scrollView];
    NSArray *imageArr = @[@"https://v5oss.vchat6.com/prod/image/1599289_1558699716000_h4yiymr072932t2j7n0n",
                          @"https://v5oss.vchat6.com/prod/image/513842_1541954254000_czjbe8y7vuap4nl5q2m8",
                          @"https://v5oss.vchat6.com/prod/image/663596_1559535520097_xx23w1ms5jt95dtkynak",
                          @"https://v5oss.vchat6.com/prod/image/4086421_1563440604000_qs9bheqv3ad3jvdhit90",
                          @"https://v5oss.vchat6.com/prod/image/3937318_1563122104000_dcjw4d1kq2onz0m0avq5",
                          @"https://v5oss.vchat6.com/prod/image/1082163_1542114436000_9p2mx49otdqkq24kdmk1"];
    [scrollView setDataSuroces:imageArr withCallBackBlock:^(NSInteger pageIndex) {
        NSLog(@"%ld",pageIndex);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
