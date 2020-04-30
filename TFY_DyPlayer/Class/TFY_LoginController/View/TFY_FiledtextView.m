//
//  TFY_FiledtextView.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/24.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_FiledtextView.h"

@interface TFY_FiledtextView ()<UITextFieldDelegate>
@property(nonatomic , strong)UITextField *phone_textfied;
@end

@implementation TFY_FiledtextView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tfy_backgroundColor([UIColor tfy_colorWithHexString:LCColor_B6 alpha:0.6]).tfy_font([UIFont systemFontOfSize:14]).tfy_clearButtonMode(UITextFieldViewModeAlways);
    }
    return self;
}

@end
