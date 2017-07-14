//
//  GLD_CarouselModel.m
//  YHImageCarousel
//
//  Created by yiyangkeji on 2017/7/14.
//  Copyright © 2017年 zyh. All rights reserved.
//

#import "GLD_CarouselModel.h"

@implementation GLD_CarouselModel


+ (instancetype)instanceCarouselModelWith:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"%@", key);
}
@end
