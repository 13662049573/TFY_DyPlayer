//
//  TFY_FeedbackCell.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/18.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_FeedbackCell.h"
#import "TFY_TextView.h"
@interface TFY_FeedbackCell ()
@property(nonatomic , strong)UITextField *textfiled;
@end

@implementation TFY_FeedbackCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.textfiled];
        
        [self.textfiled tfy_AutoSize:15 top:10 right:15 bottom:10];
    }
    return self;
}

-(void)setModels:(Feedbackitems *)models{
    _models = models;
    
    self.textfiled.placeholder = _models.placeholder;
}

-(UITextField *)textfiled{
    if (!_textfiled) {
        _textfiled = [[UITextField alloc] init];
        _textfiled.font = [UIFont systemFontOfSize:14];
        _textfiled.layer.borderWidth = 1;
        _textfiled.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    return _textfiled;
}


@end
