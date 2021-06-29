//
//  ViewController.m
//  FWTimePickView
//
//  Created by fuwu on 2018/3/30.
//  Copyright © 2018年 符武. All rights reserved.
//

#import "ViewController.h"
#import "FWTimePickViews.h"

@interface ViewController ()

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *bottonBtn;

@property (nonatomic, strong) UIView *ssView;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    UIButton *timeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    timeBtn.frame = CGRectMake(0, 0, 100, 100);
    timeBtn.center = self.view.center;
    [timeBtn setTitle:@"选择时间" forState:UIControlStateNormal];
    timeBtn.backgroundColor = [UIColor cyanColor];
    [timeBtn addTarget:self action:@selector(times:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:timeBtn];

}

- (void)times:(UIButton *)sender {
    FWTimePickViews *picVC = [[FWTimePickViews alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:picVC];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
