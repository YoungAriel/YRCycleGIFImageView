//
//  YRCycleGIFImageView.m
//  YRCycleGIFImageView
//
//  Created by Ariel on 2019/2/21.
//  Copyright © 2019 com.none.ios. All rights reserved.
//

#import "YRCycleGIFImageView.h"
#import "YRGIFImageView.h"
#import <UIImageView+WebCache.h>
#import "NSString+Other.h"
@interface YRCycleGIFImageView ()

@property (strong,nonatomic) NSMutableArray *gifImageViewArr;//筛选出gif图View
@property (strong,nonatomic) NSMutableArray *imageViewArr;//所有的图片占位View
@property (strong,nonatomic) NSMutableArray *gifImageUrlArr;//筛选出 gif 的 url
@property (assign,nonatomic) NSInteger loadIndex;//加载下一张
@property (assign,nonatomic) NSInteger playIndex;//播放下一张
@property (strong,nonatomic) NSData *downloadData;//监控正在加载的图片是否结束,结束就要播放

@property (strong,nonatomic) NSMutableDictionary *downloadStatusDict;

@end

@implementation YRCycleGIFImageView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [[SDImageCache sharedImageCache]clearMemory];
        [[SDImageCache sharedImageCache]clearDiskOnCompletion:^{
        }];
        _imageViewArr = [NSMutableArray array];
        _gifImageViewArr = [NSMutableArray array];
        _gifImageUrlArr = [NSMutableArray array];
        _downloadStatusDict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)setThumnailImgUrlArr:(NSArray *)thumnailImgUrlArr{
    _thumnailImgUrlArr = thumnailImgUrlArr;
    CGFloat margin = _edge.margin;
    NSInteger count = _edge.count;
    CGFloat width = (self.width-margin*(count-1)-_edge.marginLR*2)/count;
    CGFloat maxHeight = 0;
    for (int i = 0; i<_thumnailImgUrlArr.count; i++) {
        //第几行
        int tol = i/count;
        //第几列
        int col = i%count;
        YRGIFImageView *imageView = [[YRGIFImageView alloc]initWithFrame:CGRectMake(_edge.marginLR +(margin+width)*col, _edge.marginTB +(width+margin)*tol, width, width)];
        [self addSubview:imageView];
        imageView.backgroundColor = [UIColor redColor];
        [self.imageViewArr addObject:imageView];
        [imageView sd_setImageWithURL:[NSURL URLWithString:thumnailImgUrlArr[i]]];
        if (i == _thumnailImgUrlArr.count - 1) {
            maxHeight  = _edge.marginTB +(width+margin)*tol + width +_edge.marginTB;
        }
    }
    self.contentSize = CGSizeMake(self.width, maxHeight);
}

- (void)setImgUrlArr:(NSArray *)imgUrlArr{
    _imgUrlArr = imgUrlArr;
    int i = 0;
    for (YRGIFImageView *imageView in self.imageViewArr) {
        imageView.imageUrlstr = imgUrlArr[i];
        if(imageView.imageUrlstr.isGifImage){
            [_gifImageUrlArr addObject:imageView.imageUrlstr];
            [_gifImageViewArr addObject:imageView];
        }
        i++;
    }
}

- (void)startAllAnimating{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //开启所有下载
        [self startAllDownload];
    });
    self.loadIndex = 0;
    self.playIndex = 0;
    [self stopAllAnimating];
    //开始循环播放图片
    [self loadNextImage:nil];
}

- (void)stopAllAnimating{
    for (FLAnimatedImageView *animateView in self.gifImageViewArr) {
        [animateView stopAnimating];
    }
}

//播放下一个GIF图
- (void)playNextImage {
    if (self.playIndex>=_gifImageViewArr.count) {
        self.playIndex = 0;
        [self playNextImage];
        return;
    }
    FLAnimatedImageView *imgView = self.gifImageViewArr[self.playIndex];
    [imgView startAnimating];
    __weak typeof(self) weakSelf = self;
    __weak typeof(imgView) weakImgView = imgView;
    imgView.loopCompletionBlock = ^(NSUInteger loopCountRemaining) {
        [weakImgView stopAnimating];
        weakSelf.playIndex ++;
        [weakSelf playNextImage];
    };
}

- (void)loadNextImage:(NSData *)data{
    if (self.loadIndex>=self.gifImageUrlArr.count){
        self.playIndex = 0;
        [self playNextImage];
        return;
    }
    NSString *imgUrl = _gifImageUrlArr[_loadIndex];
    YRGIFImageView *animView = _gifImageViewArr[_loadIndex];
    if (!data) {
        data = [self getCacheImageDataForModel:[NSURL URLWithString:imgUrl]];
    }
    if (data) {
        animView.loadingView.hidden = YES;
        animView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:data];
        [animView startAnimating];
        __weak typeof(animView) weakImgView = animView;
        __weak typeof(self) weakSelf = self;
        animView.loopCompletionBlock = ^(NSUInteger loopCountRemaining) {
            [weakImgView stopAnimating];
            weakSelf.loadIndex++;
            [weakSelf loadNextImage:nil];
        };
    }else{
        animView.loadingView.hidden = NO;
        [self addObserver:self forKeyPath:@"downloadData" options:NSKeyValueObservingOptionNew context:nil];
        //分两种情况,一种是已经下载失败的,另一种是正在下载中的,正在下载中的显示进度条,已经下载失败的重新开始下载
        if ([_downloadStatusDict objectForKey:[NSString stringWithFormat:@"%ld",(long)_loadIndex]]) {
            //重新开始下载
            NSString *imageUrl = _gifImageUrlArr[_loadIndex];
            __weak typeof(self) weakSelf = self;
            [[SDWebImageManager sharedManager]loadImageWithURL:[NSURL URLWithString:imageUrl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                if (receivedSize > kMinProgress) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        if(animView.loadingView){
                            animView.loadingView.progress = (float)receivedSize/expectedSize;
                        };
                    });
                }
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                NSString *index = [NSString stringWithFormat:@"%ld",(long)weakSelf.loadIndex];
                [weakSelf.downloadStatusDict removeObjectForKey:index];
                if (error) {
                    //加载失败加载下一张
                    [animView.loadingView showFailure:@"加载失败"];
                    weakSelf.downloadData = nil;
                    
                }else{
                    weakSelf.downloadData = data;
                }
            }];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"downloadData"]) {
        if (self.downloadData.length == 0) {
            self.loadIndex ++;
            [self loadNextImage:nil];
        }else{
            [self loadNextImage:self.downloadData];
        }
    }
}

-(void)startAllDownload{
    int i = 0;
    __weak typeof(self) weakSelf = self;
    for (NSString *imageUrl in self.gifImageUrlArr) {
        NSData *data = [self getCacheImageDataForModel:[NSURL URLWithString:imageUrl]];
        if (data) {
            i++;
            continue;
        }
        YRGIFImageView *imageView = self.gifImageViewArr[i];
        [[SDWebImageManager sharedManager]loadImageWithURL:[NSURL URLWithString:imageUrl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            if (receivedSize > kMinProgress) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if(imageView.loadingView){
                        imageView.loadingView.progress = (float)receivedSize/expectedSize;
                    };
                });
            }
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            if (weakSelf.loadIndex == i) {
                if (error) {
                    //加载失败加载下一张
                    [imageView.loadingView showFailure:@"加载失败"];
                    weakSelf.downloadData = nil;

                }else{
                    weakSelf.downloadData = data;
                }
            }else{
                if (error) {
                    NSString *index = [NSString stringWithFormat:@"%d",i];
                    [weakSelf.downloadStatusDict setObject:error forKey:index];
                }
            }
        }];
        i++;
    }
}

//获取下载图片的缓存
- (NSData *)getCacheImageDataForModel:(NSURL *)url {
    SDImageCache * imageCache = [SDImageCache sharedImageCache];
    NSString*cacheImageKey = [[SDWebImageManager sharedManager]cacheKeyForURL:url];
    NSString *defaultPath = [imageCache defaultCachePathForKey:cacheImageKey];
    NSData *data = [NSData dataWithContentsOfFile:defaultPath];
    if (data) {
        return data;
    }else{
        return  nil;
    }
}

-(void)dealloc{
    [self removeObserver:self forKeyPath:@"downloadData"];
}

@end
