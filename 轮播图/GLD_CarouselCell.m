//
//  GLD_CarouselCell.m
//  轮播图
//
//  Created by yiyangkeji on 2017/7/14.
//  Copyright © 2017年 com.guolide. All rights reserved.
//

#import "GLD_CarouselCell.h"


@implementation GLD_CarouselCellContain

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.containerView];
    }
    return self;
}


- (UIImageView *)containerView{
    if (_containerView == nil) {
        _containerView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 0, self.bounds.size.width - 4, self.bounds.size.height)];
        _containerView.layer.cornerRadius = 5;
        _containerView.userInteractionEnabled = YES;
        _containerView.layer.masksToBounds = YES;
    }
    return _containerView;
}
- (void)setModel:(GLD_CarouselModel *)model{
    _model = nil;
    _model = model;
    _containerView.image = [UIImage imageNamed:model.imageName];
}

@end


