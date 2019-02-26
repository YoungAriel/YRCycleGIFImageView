//
//  YRGIFImageView.m
//  YRCycleGIFImageView
//
//  Created by Ariel on 2019/2/21.
//  Copyright © 2019 com.none.ios. All rights reserved.
//

#import "YRGIFImageView.h"
#import <FLAnimatedImage.h>
#import <UIImageView+WebCache.h>
#import "NSString+Other.h"
@interface YRGIFImageView ()

@property(strong,nonatomic) UIImageView *gifTagView;

@end
@implementation YRGIFImageView
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        self.opaque = YES;
        //添加一个gif图标
        UIImage *image = [UIImage imageNamed:@"gif"];
        UIImageView *gifTagView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:gifTagView];
        gifTagView.hidden = YES;
        self.gifTagView = gifTagView;
        
        self.loadingView = [[YRPhotoLoadingView alloc]initWithFrame:self.bounds];
        [self addSubview:self.loadingView];
        self.loadingView.hidden = YES;
        [self.loadingView showLoading];
    }
    
    return self;
}

- (void)setImageUrlstr:(NSString *)imageUrlstr{
    _imageUrlstr = imageUrlstr;
    self.gifTagView.hidden = ![imageUrlstr isGifImage];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.gifTagView.x = self.width - self.gifTagView.width;
    self.gifTagView.y = self.height - self.gifTagView.height;
}


@end
