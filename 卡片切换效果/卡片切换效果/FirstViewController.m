//
//  FirstViewController.m
//  卡片切换效果
//
//  Created by skma on 16/3/2.
//  Copyright © 2016年 skma. All rights reserved.
//

#import "FirstViewController.h"
#import "SecondViewController.h"
#import "UIImage+Blur.h"
#import "MyScrollView.h"
#import "UIImageView+WebCache.h"



#define sWIDTH [[UIScreen mainScreen] bounds].size.width
#define sHEIGHT [[UIScreen mainScreen] bounds].size.height

@interface FirstViewController ()<UIScrollViewDelegate>

/**
 * 给Scrollview添加点击手势
 **/
@property (nonatomic, strong) UITapGestureRecognizer *tap;

/**
 * 定义属性
 **/
@property (nonatomic, strong) MyScrollview *scrollView;

/**
 * 模糊图片
 **/
@property (nonatomic, strong) UIImageView *imageView;

/**
 * 辅助图片
 **/

@property (nonatomic, strong) UIImageView * behideImageView;
@property (nonatomic, strong) UIImageView *auxiliaryImageView;

/**
 * 图片网址数组
 **/
@property (nonatomic, strong) NSArray *urlArray;

/**
 * 用来接收是第几张图
 **/
@property (nonatomic) int x;

/**
 * 定义pageControl
 **/
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.hidden = YES;
    
    
    self.urlArray = @[@"Irelia_0.jpg",
                      @"Irelia_1.jpg",
                      @"Irelia_2.jpg",
                      @"Irelia_3.jpg",
                      @"Irelia_4.jpg",
                      @"Irelia_5.jpg"];
    
    _behideImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [_behideImageView setImage:[UIImage imageNamed:self.urlArray[0]]];
    [self.view addSubview:_behideImageView];
    
    // 创建imageView
    self.imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_imageView];
    
    
    // 创建自定义的scrollV
    self.scrollView = [[MyScrollview alloc]initWithFrame:self.view.bounds target:self];
    [self.view addSubview:_scrollView];

    
    // 创建辅助imageView
    _auxiliaryImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [_auxiliaryImageView setImage:[UIImage imageNamed:self.urlArray[0]]];

    
    [_scrollView loadImagesWithUrl:_urlArray];
    
    
    _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [_scrollView addGestureRecognizer:_tap];


    
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, sHEIGHT - 40, sWIDTH, 30)];
    [self.view addSubview:_pageControl];
    _pageControl.numberOfPages = _urlArray.count;
    _pageControl.currentPage = 0;
    
    
    double delayInSeconds = 0.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self blur];
        _behideImageView.alpha = 0.5;
        _behideImageView.image = _imageView.image;
    });
}

// scrollView代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self blurImageView:scrollView];
}


// scrollView 的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
     [_scrollView scroll];
}


//
- (void)blurImageView:(UIScrollView *)scrollView{
    // 获取当前偏移量
    _x = (scrollView.contentOffset.x + sWIDTH / 2 ) / (sWIDTH * 2 / 3);
    if(_pageControl.currentPage == _x) return;
    
//    NSLog(@"currentPage==%d",_x);
    _pageControl.currentPage = _x;
    
    
    _behideImageView.alpha = 1.0;
    _imageView.alpha = 0.0;
    
    [_imageView setImage:[UIImage imageNamed:_urlArray[_x]]];
    
    [self blur];
    
    [UIView animateWithDuration:0.35 animations:^{
        _imageView.alpha = 1.0;
         _behideImageView.alpha = 0.5;
        
    }completion:^(BOOL finished) {
        _behideImageView.image = _imageView.image;
    }];
    

   
}

// 模糊图片
- (void)blur{
    
    _imageView.image = [UIImage boxblurImage:[UIImage imageNamed:_urlArray[_x]] withBlurNumber:0.5];
}


// 点击事件
- (void)tap:(UITapGestureRecognizer *)tap{
    SecondViewController *SEVC = [[SecondViewController alloc]init];
    SEVC.x = _x;
    SEVC.picArray = _urlArray;
    [self.navigationController pushViewController:SEVC animated:YES];
}


@end
