//
//  GLD_RuningScroollView.h
//  YJAutoScrollLabel
//
//  Created by 西游计产品 on 2018/12/28.
//  Copyright © 2018 edward lannister. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLD_RuningScroollView : UIScrollView

@property (nonatomic, copy)NSString *scrollText;

- (void) startScroll;
- (void) stopScroll;
@end

NS_ASSUME_NONNULL_END
