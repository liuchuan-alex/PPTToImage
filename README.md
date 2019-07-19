# PPTToImage
一个简单的PPT转图片项目

1. 导入 头文件
```
#import "PPTToImageTool.h"
```

2. 传入PPT本地 url, 获取 转换后的 image 图片
```
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
```
