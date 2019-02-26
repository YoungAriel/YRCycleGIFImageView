//
//  UIView+Frame.h
//  YRCycleGIFImageView
//
//  Created by Ariel on 2019/2/21.
//  Copyright © 2019 com.none.ios. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Frame)
/**
 *  对于UIView 直接.语法 能拿到 下面四个属性
 */

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@end

NS_ASSUME_NONNULL_END
