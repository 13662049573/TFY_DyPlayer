//
//  TFY_DownloadModel.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/25.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_DownloadModel.h"

@implementation TFY_DownloadModel

- (NSString *)localPath
{
    if (!_localPath) {
        NSString *fileName = [_url substringFromIndex:[_url rangeOfString:@"/" options:NSBackwardsSearch].location + 1];
        NSString *str = [NSString stringWithFormat:@"%@_%@", _vid, fileName];
        _localPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:str];
    }
    
    return _localPath;
}


- (instancetype)initWithModelSqliteSet:(NSArray *)resultSet
{
    if (!resultSet) return nil;
    
    [resultSet enumerateObjectsUsingBlock:^(TFY_DownloadModel  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        self.vid = obj.vid;
        self.url = obj.url;
        self.fileName = obj.fileName;
        self.totalFileSize = obj.totalFileSize;
        self.tmpFileSize = obj.tmpFileSize;
        self.progress = obj.progress;
        self.state = obj.state;
        self.lastSpeedTime = obj.lastSpeedTime;
        self.intervalFileSize = obj.intervalFileSize;
        self.lastStateTime = obj.lastStateTime;
        self.resumeData = obj.resumeData;
    }];
    return self;
}

@end
