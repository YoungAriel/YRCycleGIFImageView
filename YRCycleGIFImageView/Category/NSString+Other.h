//
//  NSString+Other.h
//  YRCycleGIFImageView
//
//  Created by Ariel on 2019/2/21.
//  Copyright © 2019 com.none.ios. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Other)
/**
 判断该字符串是不是一个有效的URL
 
 @return YES：是一个有效的URL or NO
 */
- (BOOL)isValidUrl;

/** 根据图片名 判断是否是gif图 */
- (BOOL)isGifImage;

/** 根据图片data 判断是否是gif图 */
+ (BOOL)isGifWithImageData: (NSData *)data;

/**
 根据image的data 判断图片类型
 
 @param data 图片data
 @return 图片类型(png、jpg...)
 */
+ (NSString *)contentTypeWithImageData: (NSData *)data;

@end

NS_ASSUME_NONNULL_END
