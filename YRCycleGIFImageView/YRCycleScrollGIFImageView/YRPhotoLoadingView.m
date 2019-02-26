//
//  TTPhotoLoadingView.m
//  Tian_IOS
//
//  Created by Ariel on 2018/11/29.
//  Copyright © 2018 RichyLeo. All rights reserved.
//

#import "YRPhotoLoadingView.h"
#import <QuartzCore/QuartzCore.h>
#import "YRPhotoProgressView.h"
#import "UIView+Frame.h"
@interface YRPhotoLoadingView ()
{
    UILabel *_failureLabel;
    YRPhotoProgressView *_progressView;
}

@end

@implementation YRPhotoLoadingView

- (void)setFrame:(CGRect)frame
{
    if (frame.size.width == 0) {
        [super setFrame:[UIScreen mainScreen].bounds];
    }else{
        [super setFrame:frame];
    }
}

- (void)showFailure:(NSString *)str
{
    [_progressView removeFromSuperview];
    
    if (_failureLabel == nil) {
        _failureLabel = [[UILabel alloc] init];
        _failureLabel.frame = CGRectMake(0, 0, self.width, self.height);
        _failureLabel.textAlignment = NSTextAlignmentCenter;
        _failureLabel.text = str;
        _failureLabel.font = [UIFont systemFontOfSize:15];
        _failureLabel.textColor = [UIColor blackColor];
        _failureLabel.backgroundColor = [UIColor clearColor];
        _failureLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    }
    [self addSubview:_failureLabel];
}

- (void)showLoading
{
    [_failureLabel removeFromSuperview];
    
    if (_progressView == nil) {
        _progressView = [[YRPhotoProgressView alloc] init];
        _progressView.frame = CGRectMake( self.width/2-20, self.height/2-20, 40, 40);
    }
    _progressView.frame = CGRectMake( self.width/2-20, self.height/2-20, 40, 40);
    _progressView.progress = kMinProgress;
    [self addSubview:_progressView];
}

#pragma mark - customlize method
- (void)setProgress:(float)progress
{
    _progress = progress;
    _progressView.progress = progress;
    if (progress >= 1.0) {
        [_progressView removeFromSuperview];
    }
}
@end
