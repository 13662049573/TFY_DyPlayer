//
//  TFY_Const.m
//  daerOA
//
//  Created by 田风有 on 2017/3/30.
//  Copyright © 2017年 田风有. All rights reserved.
//

#import "TFY_Const.h"

/********** Project Key ***********/

//https://mjappaz.yefu365.com/index.php/app/ios/type/index?vsize=50&id=1 //id=1 电影总结 id =2  综艺总结
NSString *const  GET_TYPE_KEY =@"/index.php/app/ios/type/index";

//https://mjappaz.yefu365.com/index.php/app/ios/vod/index?page=1&size=1000&ztid=10 //ztid=1,2 电视剧 6,7,9,10,11,12,13,14,15,16,17,18,19,20 电影  这个也是更多

//第二种请求数据 https://mjappaz.yefu365.com/index.php/app/ios/vod/index?page=1&cid=17&size=100 cid=17会员 1，2 ，5，6，9，10，11，12，14，15，16，18，19，20，21，22，24
NSString *const  GET_INDEX_KEY = @"/index.php/app/ios/vod/index";

//https://mjappaz.yefu365.com/index.php/app/ios/topic/index?vsize=50 根据评分分类电影
NSString *const  GET_TOPIC_KEY =@"/index.php/app/ios/topic/index";

//https://mjappaz.yefu365.com/index.php/app/ios/vod/show?id=10760 //通过上面的ID进入获取视频播放
NSString *const  GET_SHOW_KEY = @"/index.php/app/ios/vod/show";
/********** 网络请求地址 ***********/

// 服务地址
NSString *const  HTURL = @"https://mjappaz.yefu365.com";

NSString *const  HTURL_Test = @"";


