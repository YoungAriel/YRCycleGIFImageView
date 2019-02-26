//
//  TTPhotoLoadingView.h
//  Tian_IOS
//
//  Created by Ariel on 2018/11/29.
//  Copyright © 2018 RichyLeo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kMinProgress 0.0001

@interface YRPhotoLoadingView : UIView
@property (nonatomic) float progress;

- (void)showLoading;
- (void)showFailure:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
