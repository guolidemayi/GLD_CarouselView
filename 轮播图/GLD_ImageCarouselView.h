//
//  GLD_ImageCarouselView.h
//  YHImageCarousel
//
//  Created by yiyangkeji on 2017/7/14.
//  Copyright © 2017年 zyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GLD_CarouselModel,GLD_ImageCarouselView;

@protocol GLD_ImageCarouselViewDelegate <NSObject>

- (CGSize)sizeForPageInCarouselView:(GLD_ImageCarouselView *)carouselView;
@optional
- (void)carouselView:(GLD_ImageCarouselView *)carouselView didSelectPageAtIndex:(NSInteger)index;
@end

@protocol GLD_ImageCarouselViewDataDelegate <NSObject>



- (NSInteger)numberOfPagesInCarouselView:(GLD_ImageCarouselView *)carouselView;
- (GLD_CarouselModel *)carouselView:(GLD_ImageCarouselView *)carouselView cellForPageAtIndex:(NSUInteger)index;
@end



@interface GLD_ImageCarouselView : UIView



- (instancetype)initWithFrame:(CGRect)frame
              andDataDelegate:(id<GLD_ImageCarouselViewDataDelegate>)dataDelegate
                  andDelegate:(id<GLD_ImageCarouselViewDelegate>)delegate;
@end
