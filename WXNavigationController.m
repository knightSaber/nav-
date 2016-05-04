//
//  WXNavigationController.m
//  UWeer
//
//  Created by 陈波涛 on 16/03/17.
//  Copyright © 2016年 weixun. All rights reserved.
//

#import "WXNavigationController.h"
#import <objc/runtime.h>

@interface WXNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation WXNavigationController

#pragma mark -侧滑范围变大
- (void)setRecognizerForScreen{

    // 获取系统自带滑动手势的target对象
    id target = self.interactivePopGestureRecognizer.delegate;
    // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    // 设置手势代理，拦截手势触发
    pan.delegate = self;
    // 给导航控制器的view添加全屏滑动手势
    [self.view addGestureRecognizer:pan];
    // 禁止使用系统自带的滑动手势
    self.interactivePopGestureRecognizer.enabled = NO;
    
    // 在根控制器器如果在右侧按住向右滑动，然后再点击 PUSH 按钮，则无法 PUSH 出新的控制器
    // 解决办法
    // 1. 设置 interactivePopGestureRecognizer 的代理
    // 2. 实现代理方法，并且在根视图控制器时不支持手势返回
    self.interactivePopGestureRecognizer.delegate = self;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setRecognizerForScreen];
    
    //将透明效果去掉
    [self.navigationBar setTranslucent:NO];
    
    //修改状态栏的颜色
    self.navigationBar.barTintColor = [UIColor blackColor];
    
    //修改字体
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark -推出另外一个控制器的逻辑控制
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
  
    if (self.childViewControllers.count > 0) {
//        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem ff_barButtonWithTitle:@"" imageName:@"navigationbar_back_withtext" target:self action:@selector(goBack)];

        
        UIButton * button = [[UIButton alloc] init];
        
        [button setImage:[UIImage imageNamed:@"123"] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem * item =  [[UIBarButtonItem alloc] initWithCustomView:button];
        
        viewController.navigationItem.leftBarButtonItem = item;
        
        
    }
    
    [super pushViewController:viewController animated:animated];
}


#pragma mark - UIGestureRecognizerDelegate
/// 手势识别将要开始
///
/// @param gestureRecognizer 手势识别
///
/// @return 返回 NO，放弃当前识别到的手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // 如果是根视图控制器，则不支持手势返回
    return self.childViewControllers.count > 1;
}

#pragma mark - 监听方法
/// 返回上级视图控制器
- (void)goBack {
    [self popViewControllerAnimated:YES];
}

@end
