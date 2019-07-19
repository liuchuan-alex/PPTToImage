//
//  ViewController.m
//  PPTToImage
//
//  Created by 刘川 on 2019/7/18.
//  Copyright © 2019 alex. All rights reserved.
//

#import "ViewController.h"
#import "PPTToImageTool.h"
#import "ImageListView.h"

@interface ViewController ()

@property (nonatomic, strong) PPTToImageTool *toImagetool;
@property (nonatomic, strong) ImageListView *imageListView;

@end

@implementation ViewController

- (IBAction)PPTToImageBtnClick:(id)sender {
    
    // 获取本地 ppt url 地址
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"IOS.pptx" ofType:nil];
    
    // block 内部使用__weakself
    __weak __typeof(self)weakSelf = self;
    
    // 进行 ppt 转换
    [self.toImagetool pptToImageWithPPTFileUrl:filePath
                                      progress:^(CGFloat value) {
                                          
                                          NSLog(@"进度-------%f", value);
                                          
                                      } completion:^(NSArray * _Nonnull images) {
                                          
                                          NSLog(@"转换后图片信息-------%@",images);
                                          weakSelf.imageListView.images = images;
                                          [weakSelf.imageListView reloadData];
                                      }];
}

- (ImageListView *)imageListView {
    if (!_imageListView) {
        _imageListView = [[ImageListView alloc]initWithFrame:CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width)];
        [self.view addSubview:_imageListView];
    }
    return _imageListView;
}

@end
