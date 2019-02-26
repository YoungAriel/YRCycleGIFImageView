//
//  TTPhotoProgressView.m
//  Tian_IOS
//
//  Created by Ariel on 2018/11/29.
//  Copyright © 2018 RichyLeo. All rights reserved.
//

#import "YRPhotoProgressView.h"
@interface YRPhotoProgressView ()

@property (nonatomic, strong) CAShapeLayer *backgroundLayer;
@property (nonatomic, strong) CAShapeLayer *circleLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;

@end

@implementation YRPhotoProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupLayer];
        [self setupDefaultConfig];
    }
    return self;
}

- (void)setupLayer {
    self.circleLayer = [CAShapeLayer layer];
    [self.layer addSublayer:self.circleLayer];
    
    self.backgroundLayer = [CAShapeLayer layer];
    [self.layer addSublayer:self.backgroundLayer];
    
    self.progressLayer = [CAShapeLayer layer];
    self.progressLayer.fillRule = kCAFillModeBoth;
    [self.layer addSublayer:self.progressLayer];
}

- (void)setProgress:(float)progress {
    _progress = progress;
    [self setNeedsLayout];
}

- (void)setSectorRadius:(CGFloat)sectorRadius {
    _sectorRadius = sectorRadius;
    [self setNeedsLayout];
}

- (void)setCircleSideWidth:(CGFloat)circleSideWidth {
    _circleSideWidth = circleSideWidth;
    [self setNeedsLayout];
}


- (void)setupDefaultConfig {
    self.progressColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    self.circleSideWidth = 1;
    self.sectorRadius = 0;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    self.backgroundLayer.backgroundColor = backgroundColor.CGColor;
}

- (void)setProgressColor:(UIColor *)progressColor {
    _progressColor = progressColor;
    self.circleLayer.borderColor = progressColor.CGColor;
    self.progressLayer.fillColor = progressColor.CGColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateLayer];
}

#pragma mark - *********  Update Layer  *********

- (void)updateLayer {
    CGFloat W = self.bounds.size.width;
    CGFloat H = self.bounds.size.height;
    CGPoint C = CGPointMake(W/2.0, H/2.0);
    
    CGFloat S = MIN(W,H); // 直径
    CGFloat R = S/2.0;    // 半径
    // Setup circle layer
    if (self.circleSideWidth == 0) {
        self.circleLayer.hidden = YES;
    } else {
        self.circleLayer.hidden = NO;
        self.circleLayer.frame = CGRectMake(C.x-R,
                                            C.y-R,
                                            S,
                                            S);
        self.circleLayer.cornerRadius = R;
        self.circleLayer.borderWidth = self.circleSideWidth;
    }
    
    // Setup background layer
    self.backgroundLayer.frame = CGRectMake(C.x-(R-self.circleSideWidth),
                                            C.y-(R-self.circleSideWidth),
                                            S-self.circleSideWidth*2,
                                            S-self.circleSideWidth*2);
    self.backgroundLayer.cornerRadius = (S-self.circleSideWidth*2)/2.0;
    
    // Setup progrtess Layer
    CGFloat progressLayerRadius = self.sectorRadius != 0 ? self.sectorRadius : (R-self.circleSideWidth-2);
    self.progressLayer.frame = CGRectMake(C.x-progressLayerRadius,
                                          C.y-progressLayerRadius,
                                          progressLayerRadius*2,
                                          progressLayerRadius*2);
    UIBezierPath *sectorPath = [UIBezierPath
                                bezierPathWithArcCenter:CGPointMake(progressLayerRadius, progressLayerRadius)
                                radius:progressLayerRadius
                                startAngle:-M_PI_2 endAngle:-M_PI_2+M_PI*2*self.progress clockwise:YES];
    [sectorPath addLineToPoint:CGPointMake(progressLayerRadius, progressLayerRadius)];
    [sectorPath closePath];
    self.progressLayer.path = sectorPath.CGPath;
}

@end

