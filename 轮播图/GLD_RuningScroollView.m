//
//  GLD_RuningScroollView.m
//  YJAutoScrollLabel
//
//  Created by 西游计产品 on 2018/12/28.
//  Copyright © 2018 edward lannister. All rights reserved.
//

#import "GLD_RuningScroollView.h"


/**屏幕宽度*/
#define kScreenW [[UIScreen mainScreen] bounds].size.width
/**屏幕高度*/
#define kScreenH [[UIScreen mainScreen] bounds].size.height

#define spacing  (self.textWidth < kScreenW ? 0 : 80) //间隔
#define speed 20 //速度
@interface GLD_RuningScroollView ()

@property (nonatomic,strong)UILabel *fristLabel;
@property (nonatomic,strong)UILabel *secondLabel;
@property (nonatomic,strong)NSTimer *timer;

@property (nonatomic, assign)CGFloat textWidth;//文本宽度

@property (nonatomic, assign)CGFloat scrollWidth;//滚动的宽度
@end
@implementation GLD_RuningScroollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.fristLabel];
        [self addSubview:self.secondLabel];
    }
    return self;
}

- (void)autoScroll{
    
    if (self.scrollWidth >= self.textWidth + spacing ) {
        self.contentOffset = CGPointMake(self.scrollWidth - self.textWidth - spacing, 0);
        self.scrollWidth = 0;
    }
    [UIView animateWithDuration:.35 * 2 animations:^{
        
        self.contentOffset = CGPointMake(self.scrollWidth += speed, 0);
        
    }];
}

//开始滚动
-(void) startScroll{
    
    if (!_timer)
        _timer = [NSTimer scheduledTimerWithTimeInterval:.35 target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
    
    [_timer fire];
}
- (void)stopScroll{
    [_timer invalidate];
    _timer = nil;
}

- (CGFloat)sizeWithText:(NSString *)text withFont:(UIFont *)font{
    
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:font}];
    
    return size.width < kScreenW ? kScreenW-1 : size.width;
    
}

-(void)setScrollText:(NSString *)scrollText{
    if (scrollText) {
        _scrollText = scrollText;
        self.fristLabel.text = scrollText;
        self.secondLabel.text = scrollText;
        UIFont *font = [UIFont systemFontOfSize:14];
        self.textWidth = [self sizeWithText:scrollText withFont:font];
    }
}

- (void)setTextWidth:(CGFloat)textWidth{
    _textWidth =textWidth;
    NSLog(@"%d",spacing);
    self.fristLabel.frame = CGRectMake(0, 0, textWidth, self.frame.size.height);
    self.secondLabel.frame = CGRectMake((textWidth + spacing), 0, textWidth, self.frame.size.height);
    self.contentSize = CGSizeMake(textWidth * 2 + spacing, 0);
}
- (UILabel *)fristLabel{
    if (_fristLabel == nil) {
        _fristLabel = [UILabel new];
//        _fristLabel.textAlignment = NSTextAlignmentCenter;
        _fristLabel.font = [UIFont systemFontOfSize:14];
        _fristLabel.textColor = [UIColor whiteColor];
    }
    return _fristLabel;
}
- (UILabel *)secondLabel{
    if (_secondLabel == nil) {
        _secondLabel = [UILabel new];
//        _secondLabel.textAlignment = NSTextAlignmentCenter;
        _secondLabel.font = [UIFont systemFontOfSize:14];
        _secondLabel.textColor = [UIColor whiteColor];
    }
    return _secondLabel;
}
@end
