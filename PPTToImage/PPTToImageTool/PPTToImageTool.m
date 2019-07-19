//
//  PPTToImageTool.m
//  PPTToImage
//
//  Created by alex on 2019/7/18.
//  Copyright © 2019 alex. All rights reserved.
//

#import "PPTToImageTool.h"
#import <WebKit/WebKit.h>

@interface PPTToImageTool ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSMutableArray *pageInfoArr;          // 存储 ppt 每一页尺寸信息
@property (nonatomic, assign) NSInteger pageCount;                  // ppt页数
@property (nonatomic, strong) NSMutableArray *pptImageArr;          // 存储PPT生成的图片
@property (nonatomic, copy) void (^callback)(NSArray * images);     // 图片回调
@property (nonatomic, copy) void (^progress)(CGFloat value);        // 转换进度条

@end

@implementation PPTToImageTool


- (void)pptToImageWithPPTFileUrl: (NSString *) pptFileUrl
                        progress: (void (^)(CGFloat value)) progress
                      completion: (void (^)(NSArray * images)) completion{
    [self.pageInfoArr removeAllObjects];
    [self.pptImageArr removeAllObjects];
    self.webView = nil;
    self.callback = completion;
    self.progress = progress;
    [self p_initWebView];
    [self p_loadPPT:pptFileUrl];
}

#pragma -mark UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //     [self p_printHtml];  // 用于获取页面html 代码
    [self p_getTTPInfo];
}

// 初始化,并注册JS调用方法
- (void)p_initWebView{
    UIWebView *webView = [[UIWebView alloc] init];
    webView.backgroundColor = [UIColor whiteColor];
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    self.webView = webView;
}

// 加载PPT
- (void)p_loadPPT:(NSString *) pptFileUrl {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:pptFileUrl]];
    [self.webView loadRequest:request];
}

// 查看 html结构
- (void)p_printHtml{
    NSString *html = [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
    NSLog(@"%@",html);
}

// 获取 ppt 信息,PPT页数,以及尺寸信息
- (void)p_getTTPInfo{
    
    // 获取PPT页数
    NSInteger pageCount = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('slide').length"] integerValue];
    self.pageCount = pageCount;
    
    // 清除一些间距信息
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.body.style.margin = '0';"];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.body.style.padding = '0';"];
    
    // 获取没一页信息
    for (NSInteger i = 0; i< pageCount; i++ ){
        NSInteger pageWidth = [[self.webView stringByEvaluatingJavaScriptFromString:@"parseInt(window.getComputedStyle(document.getElementsByClassName('slide')[0]).width)"] integerValue];
        NSInteger pageHeight = [[self.webView stringByEvaluatingJavaScriptFromString:@"parseInt(window.getComputedStyle(document.getElementsByClassName('slide')[0]).height)"] integerValue];
        CGSize size = CGSizeMake(pageWidth, pageHeight);
        [self.pageInfoArr addObject:@(size)];
    }
    [self p_cropImage];
    
}

// 通过绘制进行截图
- (void)p_cropImage{
    CGFloat offsetheight = 0;
    for (int i = 0; i< self.pageInfoArr.count; i++) {
        CGSize size = [self.pageInfoArr[0] CGSizeValue];
        self.webView.bounds = CGRectMake(0, 0, size.width, size.height);
        self.webView.scrollView.contentOffset = CGPointMake(0, offsetheight+5);
        offsetheight += (size.height + 5);
        UIImage * pptImage =  [self imageWithView:self.webView frame:CGRectMake(0, 0, size.width, size.height)];
        [self.pptImageArr addObject:pptImage];
        if (self.progress) {
            self.progress((CGFloat)self.pptImageArr.count / (CGFloat)self.pageInfoArr.count);
        }
    }
    // 回调
    if (self.callback) {
        self.webView = nil;
        self.callback(self.pptImageArr);
    }
}

// 截取响应视图
- (UIImage* )imageWithView:(UIView *)view frame:(CGRect)frame{
    @autoreleasepool {
        UIGraphicsBeginImageContextWithOptions(frame.size, YES, 0.0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        if (!context) {
            return nil;
        }
        [view.layer renderInContext:context];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        NSData *imageData = UIImageJPEGRepresentation(image,0.6);
        UIImage *resultImage = [UIImage imageWithData:imageData];
        return resultImage;
    }
}

- (NSMutableArray *)pageInfoArr{
    if (!_pageInfoArr) {
        _pageInfoArr = [NSMutableArray array];
    }
    return _pageInfoArr;
}

- (NSMutableArray *)pptImageArr {
    if (!_pptImageArr) {
        _pptImageArr = [NSMutableArray array];
    }
    return _pptImageArr;
}

- (void)dealloc{
    NSLog(@"%@",self);
}

@end
