//
//  YRCycleGIFImageView.h
//  YRCycleGIFImageView
//
//  Created by Ariel on 2019/2/21.
//  Copyright © 2019 com.none.ios. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef struct CycleEdgeStruct{
    CGFloat marginLR;
    CGFloat marginTB;
    CGFloat margin;
    NSInteger count;
}CycleEdge;

static inline  CycleEdge CycleEdgeMCyclee(CGFloat marginLR, CGFloat marginTB, CGFloat marginImages,NSInteger count){
    
    CycleEdge edge;
    edge.marginLR = marginLR;
    edge.margin = marginImages;
    edge.marginTB = marginTB;
    edge.count = count;
    return edge;
}

@interface YRCycleGIFImageView : UIScrollView

@property (strong,nonatomic) NSArray *imgUrlArr;
@property (strong,nonatomic) NSArray *thumnailImgUrlArr;
@property (assign,nonatomic) CycleEdge edge;


- (void)startAllAnimating;

- (void)stopAllAnimating;

@end

NS_ASSUME_NONNULL_END
