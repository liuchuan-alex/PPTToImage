//
//  PPTToImageTool.h
//  PPTToImage
//
//  Created by alex on 2019/7/18.
//  Copyright © 2019 alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPTToImageTool : NSObject


/**
 PPT转图片
 
 @param pptFileUrl   ppt 本地路径
 @param progress     转换进度 0-1
 @param completion   转换后的图片数组
 */
- (void)pptToImageWithPPTFileUrl: (NSString *) pptFileUrl
                        progress: (void (^)(CGFloat value)) progress
                      completion: (void (^)(NSArray * images)) completion;

@end

NS_ASSUME_NONNULL_END
