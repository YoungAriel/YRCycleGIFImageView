//
//  YRGIFImageView.h
//  YRCycleGIFImageView
//
//  Created by Ariel on 2019/2/21.
//  Copyright © 2019 com.none.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Frame.h"
#import <FLAnimatedImageView.h>
#import "YRPhotoLoadingView.h"
#import <FLAnimatedImage.h>
NS_ASSUME_NONNULL_BEGIN

@interface YRGIFImageView : FLAnimatedImageView

@property(copy,nonatomic) NSString *imageUrlstr;

@property(strong,nonatomic) YRPhotoLoadingView *loadingView;

@end

NS_ASSUME_NONNULL_END
