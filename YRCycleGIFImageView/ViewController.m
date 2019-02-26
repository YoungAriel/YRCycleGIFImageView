//
//  ViewController.m
//  YRCycleGIFImageView
//
//  Created by Ariel on 2019/2/21.
//  Copyright © 2019 com.none.ios. All rights reserved.
//

#import "ViewController.h"
#import "YRCycleGIFImageView.h"
#import "UIView+Frame.h"
@interface ViewController ()

@end

@implementation ViewController
{
    YRCycleGIFImageView *cycleView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    cycleView = [[YRCycleGIFImageView alloc]initWithFrame:CGRectMake(0, 100, self.view.width, self.view.height-100)];
    cycleView.edge = CycleEdgeMCyclee(20, 20, 10, 3);
    NSArray *thumArr = @[@"https://www.asqql.com/upfile/simg/2019-1/201912110174498880.jpg",
                         @"https://www.asqql.com/upfile/simg/2019-1/20191219302038436.jpg",
                         @"https://www.asqql.com/upfile/simg/2019-1/20191219222425813.jpg",
                         @"https://www.asqql.com/upfile/simg/2019-1/201911611481659711.jpg",
                         @"https://www.asqql.com/upfile/simg/2018-11/2018111817344338825.jpg",
                         @"https://www.asqql.com/upfile/simg/2018-11/201811161558612338.jpg",
                         @"https://www.asqql.com/upfile/simg/2018-11/20181121402125379.jpg",
                         @"https://www.asqql.com/upfile/simg/2019-1/201912110162917073.jpg",
                         @"https://www.asqql.com/upfile/simg/2019-1/201911312263890230.jpg",
                         @"https://www.asqql.com/upfile/simg/2019-1/201912110192228854.jpg",
                         @"https://www.asqql.com/upfile/simg/2019-1/201912111285941802.jpg",
                         @"https://www.asqql.com/upfile/simg/2018-10/2018102813215835919.jpg"
                         ];
    NSArray *arr = @[@"https://upfile.asqql.com/2009pasdfasdfic2009s305985-ts/2019-1/201912110174498880.gif",
                    @"https://upfile.asqql.com/2009pasdfasdfic2009s305985-ts/2019-1/20191219302038436.gif",
                    @"https://upfile.asqql.com/2009pasdfasdfic2009s305985-ts/2019-1/20191219222425813.gif",
                    @"https://upfile.asqql.com/2009pasdfasdfic2009s305985-ts/2019-1/201911611481659711.gif",
                    @"https://upfile.asqql.com/2009pasdfasdfic2009s305985-ts/2018-11/2018111817344338825.gif",
                    @"https://upfile.asqql.com/2009pasdfasdfic2009s305985-ts/2018-11/201811161558612338.gif",
                    @"https://upfile.asqql.com/2009pasdfasdfic2009s305985-ts/2018-11/20181121402125379.gif",
                    @"https://upfile.asqql.com/2009pasdfasdfic2009s305985-ts/2019-1/201912110162917073.gif",
                    @"https://upfile.asqql.com/2009pasdfasdfic2009s305985-ts/2019-1/201911312263890230.gif",
                    @"https://upfile.asqql.com/2009pasdfasdfic2009s305985-ts/2019-1/201912110192228854.gif",
                    @"https://upfile.asqql.com/2009pasdfasdfic2009s305985-ts/2019-1/201912111285941802.gif",
                    @"https://upfile.asqql.com/2009pasdfasdfic2009s305985-ts/2018-10/2018102813215835919.gif"
                    ];
    cycleView.thumnailImgUrlArr = thumArr;
    cycleView.imgUrlArr = arr;
    [self.view addSubview:cycleView];
    
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 44, 100, 40)];
    [btn setTitle:@"start" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor blackColor];
    [btn addTarget:self action:@selector(startAllAnimating) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width-100, 44, 100, 40)];
    [btn1 setTitle:@"stop" forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    btn1.backgroundColor = [UIColor blackColor];
    [btn1 addTarget:self action:@selector(stopAllAnimating) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)startAllAnimating{
    [cycleView startAllAnimating];
}

- (void)stopAllAnimating{
    [cycleView stopAllAnimating];
}

@end
