//
//  NSURLSession+TFY_CorrectedResumeData.h
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/25.
//  Copyright © 2019 田风有. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURLSession (TFY_CorrectedResumeData)

- (NSURLSessionDownloadTask *)downloadTaskWithCorrectResumeData:(NSData *)resumeData;

@end

NS_ASSUME_NONNULL_END
