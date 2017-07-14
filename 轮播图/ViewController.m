//
//  ViewController.m
//  轮播图
//
//  Created by yiyangkeji on 2017/7/14.
//  Copyright © 2017年 com.guolide. All rights reserved.
//

#import "ViewController.h"
#import "GLD_ImageCarouselView.h"
#import "GLD_CarouselCell.h"
#import "GLD_CarouselModel.h"

@interface ViewController ()<GLD_ImageCarouselViewDelegate,GLD_ImageCarouselViewDataDelegate>

@property (nonatomic, strong) NSArray *cellInfoArray;
@property (nonatomic, strong) GLD_ImageCarouselView *imageCarouselView;
@property (nonatomic, assign) NSUInteger pageWidth;
@property (nonatomic, assign) NSUInteger pageHeight;
@property (nonatomic, strong) UILabel *labelTwo;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        _imageCarouselView = [[GLD_ImageCarouselView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, self.pageHeight) andDataDelegate:self andDelegate:self];
    
    
        [self.view addSubview:_imageCarouselView];
    
 
    _labelTwo = [[UILabel alloc] initWithFrame:CGRectMake(100, 360, 200, 40)];
    _labelTwo.text = @"点击了第 X 页";
    _labelTwo.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:_labelTwo];
}

- (CGSize)sizeForPageInCarouselView:(GLD_ImageCarouselView *)carouselView {
    return CGSizeMake(self.pageWidth, self.pageHeight);
}
//
- (NSInteger)numberOfPagesInCarouselView:(GLD_ImageCarouselView *)carouselView {
    return self.cellInfoArray.count;
}
//
- (GLD_CarouselModel *)carouselView:(GLD_ImageCarouselView *)carouselView cellForPageAtIndex:(NSUInteger)index {
   
    return self.cellInfoArray[index];
}

- (void)carouselView:(GLD_ImageCarouselView *)carouselView didSelectPageAtIndex:(NSInteger)index {
    _labelTwo.text = [NSString stringWithFormat:@"点击了第 %zd 页", index];
}

- (NSUInteger)pageWidth {
    return self.view.bounds.size.width * 0.84;
}

- (NSUInteger)pageHeight {
    return self.pageWidth * 0.6;
}

- (NSArray *)cellInfoArray {
    if (_cellInfoArray == nil) {
        
        NSArray *dictArr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"imageInfos.plist" ofType:nil]];
        // 2.创建一个可变数据
        NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:dictArr.count];
        // 3.遍历字典数组,来做字典转模型
        for (NSDictionary *dict in dictArr) {
            // 把字典转换成模型同时添加到可变数组中
            [arrM addObject:[GLD_CarouselModel instanceCarouselModelWith:dict]];
        }
        _cellInfoArray = arrM;
    }
    return _cellInfoArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
