//
//  TFY_QuickregistrationHerderView.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/25.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_QuickregistrationHerderView.h"
#import "TFY_FiledtextView.h"
#import "TFY_ImagePicker.h"
@interface TFY_QuickregistrationHerderView ()
@property(nonatomic , strong)UIImageView *pic_imageView;

@property(nonatomic , strong)TFY_FiledtextView *textfiled;
@end

@implementation TFY_QuickregistrationHerderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.pic_imageView];
        self.pic_imageView.tfy_Center(0, 0).tfy_size(70, 70);
        
        [self addSubview:self.textfiled];
        self.textfiled.tfy_CenterX(0).tfy_TopSpaceToView(20, self.pic_imageView).tfy_RightSpace(50).tfy_RightSpace(50).tfy_Height(50);
        
        [self registLoginEvent];
    }
    return self;
}

-(UIImageView *)pic_imageView{
    if (!_pic_imageView) {
        _pic_imageView = tfy_imageView();
        _pic_imageView.tfy_action(self, @selector(pic_imageViewClick)).tfy_cornerRadius(35).tfy_borders(2, LCColor_A1);
        NSData *data = [TFY_CommonUtils getdataValueInUDWithKey:@"image"];
        if (data!=nil) {
            UIImage *images = [UIImage imageWithData:data];
            _pic_imageView.image = images;
        }
        else{
            _pic_imageView.tfy_imge(@"my_head_portrait");
        }
    }
    return _pic_imageView;
}

-(TFY_FiledtextView *)textfiled{
    if (!_textfiled) {
        _textfiled = [TFY_FiledtextView new];
        _textfiled.tfy_placeholder(@"请输入你的称呼", 14, [UIColor tfy_colorWithHex:LCColor_B2]).tfy_font(15).tfy_borderStyle(UITextBorderStyleRoundedRect).tfy_borders(1, [UIColor tfy_colorWithHex:LCColor_A1]).tfy_cornerRadius(8).tfy_alAlignment(1);
    }
    return _textfiled;
}

-(void)registLoginEvent{
    [self.textfiled.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        
        if (x.length >= 30) {
            self.textfiled.tfy_text([x substringToIndex:30]);
        }
        if (![TFY_CommonUtils stringContainsEmoji:x]) {
            
            [TFY_CommonUtils saveStrValueInUD:x forKey:@"username"];
        }
        else{
            [TFY_ProgressHUD showErrorWithStatus:@"不支持表情符号!"];
        }
    }];

}

-(void)pic_imageViewClick{
    [TFY_ImagePicker showImagePickerFromViewController:self.vc allowsEditing:YES finishAction:^(UIImage *image,NSString *imageName) {
        
        if (image!=nil) {
            
            self.pic_imageView.image=image;
            
            NSData *data = UIImagePNGRepresentation(image);
            
            [TFY_CommonUtils saveDataValueInUD:data forKey:@"image"];
        }
        
    }];
}

@end
