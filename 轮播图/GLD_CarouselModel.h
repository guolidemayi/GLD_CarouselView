//
//  GLD_CarouselModel.h
//  YHImageCarousel
//
//  Created by yiyangkeji on 2017/7/14.
//  Copyright © 2017年 zyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLD_CarouselModel : NSObject

@property (nonatomic, copy)NSString *imageName;
@property (nonatomic, assign)NSInteger showTime;


+ (instancetype)instanceCarouselModelWith:(NSDictionary *)dict;
@end
