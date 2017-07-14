//
//  GLD_ImageCarouselView.m
//  YHImageCarousel
//
//  Created by yiyangkeji on 2017/7/14.
//  Copyright © 2017年 zyh. All rights reserved.
//

#import "GLD_ImageCarouselView.h"
#import "GLD_CarouselCell.h"


@interface GLD_ImageCarouselView ()<UIScrollViewDelegate>

@property (nonatomic, weak)id<GLD_ImageCarouselViewDataDelegate> dataDelegate;
@property (nonatomic, weak)id<GLD_ImageCarouselViewDelegate> delegate;

@property (nonatomic, strong)UIScrollView *scrollView;
//cell视图容器
@property (nonatomic, strong)NSMutableArray *containerViews;

//contentsize
@property (nonatomic, assign)CGSize pageSize;

//当前页
@property (nonatomic, assign) NSInteger currentPageIndex;
//总页数
@property (nonatomic, assign) NSInteger pageCount;

@property (nonatomic, strong)NSTimer *carouselTimer;
@end

#define contentW self.pageSize.width
#define contentH self.pageSize.height

@implementation GLD_ImageCarouselView

- (instancetype)initWithFrame:(CGRect)frame
              andDataDelegate:(id<GLD_ImageCarouselViewDataDelegate>)dataDelegate
                  andDelegate:(id<GLD_ImageCarouselViewDelegate>)delegate{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.dataDelegate = dataDelegate;
        self.delegate = delegate;
        [self configuration];
        [self setupUI];
        [self startScroll];
    }
    return self;
    
}


- (void)configuration{
    self.clipsToBounds = YES;
    self.currentPageIndex = 0;
    self.containerViews = [NSMutableArray arrayWithCapacity:5];
    [self addSubview:self.scrollView];
}


- (void)setupUI{
    //获取页数
    if([_dataDelegate respondsToSelector:@selector(numberOfPagesInCarouselView:)]){
        
        self.pageCount = [self.dataDelegate numberOfPagesInCarouselView:self];
    }
    
//    重置size
    if ([self.delegate respondsToSelector:@selector(sizeForPageInCarouselView:)]) {
        self.pageSize = [self.delegate sizeForPageInCarouselView:self];
    }
    
    self.scrollView.frame = CGRectMake((self.frame.size.width - contentW)/2, 0, contentW, contentH);
    self.scrollView.contentSize = CGSizeMake(contentW * 5, contentH);
    //创建5个容器
//    先清除
    for (GLD_CarouselCellContain *contain in self.containerViews) {
        [contain removeFromSuperview];
        
    }
    [self.containerViews removeAllObjects];
    
    
    for (int i = 0; i < 5; i++) {
        
        GLD_CarouselCellContain *contain = [[GLD_CarouselCellContain alloc]initWithFrame:CGRectMake(i * contentW, 0, contentW, contentH)];
        [contain addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(containTapGestureAction:)]];
    
        
        
        [self.containerViews addObject:contain];
        [self.scrollView addSubview:contain];
        
        if ([self.dataDelegate respondsToSelector:@selector(carouselView:cellForPageAtIndex:)]) {
            
//            - 2 的目的是把当前页放在中间位置
            NSInteger index = (_pageCount + (_currentPageIndex + i - 2)) % _pageCount;
            
            contain.model = [self.dataDelegate carouselView:self cellForPageAtIndex:index];
                    
        }
        
    }
    //滚动到中间位置
    self.scrollView.contentOffset = CGPointMake(contentW * 2, 0);
    
    
}

- (void)containTapGestureAction:(UITapGestureRecognizer *)tap{
    NSLog(@"-----");
    
    [self.delegate carouselView:self didSelectPageAtIndex:_currentPageIndex];

}


- (void)startScroll{
    if (self.pageCount > 1 && self.carouselTimer == nil) {
        
        GLD_CarouselCellContain *contain = self.containerViews[2];
        
        self.carouselTimer = [NSTimer scheduledTimerWithTimeInterval:contain.model.showTime target:self selector:@selector(autoNextPage) userInfo:nil repeats:YES];
    }
    
}

- (void)stopScroll{
    [self.carouselTimer invalidate];
    self.carouselTimer = nil;
}

#pragma mark - 自动轮播

- (void)autoNextPage {
    [self.scrollView setContentOffset:CGPointMake(3 * contentW, 0) animated:YES];
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if ([scrollView isEqual:self.scrollView]) {
        if (self.pageCount == 0) {
            return;
        }
        //向右滑动
        if(scrollView.contentOffset.x <= contentW){
            //停止计时器
            [self stopScroll];
            //取出最后一个容器
            GLD_CarouselCellContain *lastContain = self.containerViews.lastObject;
            //将最后一个调整到第一个
            
            //移除最后一个元素
            [self.containerViews removeLastObject];
            
            //重新布局
            for (int i = 0; i < self.containerViews.count; i++) {
                GLD_CarouselCellContain *contain = self.containerViews[i];
                NSInteger index = (_pageCount + (_currentPageIndex + i - 2)) % _pageCount;
                contain.model = [self.dataDelegate carouselView:self cellForPageAtIndex:index];
                contain.frame = CGRectMake((i + 1) * contentW, 0, contentW, contentH);
                
            }
            //重新加上最后一个元素
            lastContain.frame = CGRectMake(0 * contentW, 0, contentW, contentH);
            
            [self.containerViews insertObject:lastContain atIndex:0];
            lastContain.model = [self.dataDelegate carouselView:self cellForPageAtIndex:(_pageCount + (_currentPageIndex - 1 - 2)) % _pageCount];
            
            // 重新至中
            _scrollView.contentOffset = CGPointMake(contentW * 2, 0);
            
            //记录
            _currentPageIndex = ((_currentPageIndex - 1) + _pageCount) % _pageCount;
            //重新开始
            [self startScroll];
        }
        
        //向左滑动
        if (scrollView.contentOffset.x >= contentW * 3) {
            [self stopScroll];
            
            //取出第一个元素
            GLD_CarouselCellContain *firstContain = self.containerViews.firstObject;
            [self.containerViews removeObjectAtIndex:0];
            
            //重新布局
            for (int i = 0; i < self.containerViews.count; i++) {
                
                GLD_CarouselCellContain *contain = self.containerViews[i];
                NSInteger index = (_currentPageIndex + i + _pageCount - 1) % _pageCount;
                contain.model = [self.dataDelegate carouselView:self cellForPageAtIndex:index];
                contain.frame = CGRectMake(i * contentW, 0, contentW, contentH);
                
            }
            
            firstContain.frame = CGRectMake(4 * contentW, 0, contentW, contentH);
            
            [_containerViews addObject:firstContain];
            firstContain.model = [self.dataDelegate carouselView:self cellForPageAtIndex:(_currentPageIndex + 1 + 2) % _pageCount];
            
            // 重新至中
            _scrollView.contentOffset = CGPointMake(contentW * 2, 0);
            _currentPageIndex = (_currentPageIndex + 1) % _pageCount;
            [self startScroll];
        }
        
        
        
    }
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"%zd", _currentPageIndex);
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        [self stopScroll];
    }
}


- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.scrollsToTop = NO;
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.clipsToBounds = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}
@end
