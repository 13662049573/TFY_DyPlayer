//
//  TFY_BarragekeyboardManager.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/26.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_BarragekeyboardManager.h"
#import "TFY_EmotionModel.h"
#import "NSString+TFY_Extension.h"
#import "TFY_ChatBoxFaceView.h"

#define TFY_totalH 245

@interface TFY_BarragekeyboardManager ()<UITextViewDelegate>

@property(nonatomic,strong)UITextView *textView;
//上侧容器 //下侧容器
@property(nonatomic,strong)UIView *topContainer,*bottomCotainer;

@property(nonatomic,strong)UIButton *sendButton,*expressionbtn;
//表情
@property(nonatomic, strong)TFY_ChatBoxFaceView *chatboxfaceView;
@end

@implementation TFY_BarragekeyboardManager{
    CGFloat keyboardY;
    CGFloat duration;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, TFY_PLAYER_ScreenH, TFY_PLAYER_ScreenH, 50);
        self.backgroundColor = [UIColor colorWithRed:0.15 green:0.11 blue:0.11 alpha:1.00];
        
        self.status =  ChatBoxStatusNothing;
        
        [self addNotification];
        
        [self addSubview:self.topContainer];
        [self.topContainer tfy_AutoSize:0 top:0 right:0 bottom:0];
        
        [self.topContainer addSubview:self.sendButton];
        self.sendButton.tfy_RightSpace(20).tfy_CenterY(0).tfy_size(70, 40);
        
        [self.topContainer addSubview:self.expressionbtn];
        self.expressionbtn.tfy_LeftSpace(iPhoneX?40:20).tfy_CenterY(0).tfy_size(35, 35);
        
        [self.topContainer addSubview:self.textView];
        self.textView.tfy_RightSpaceToView(10, self.sendButton).tfy_CenterY(0).tfy_LeftSpaceToView(10, self.expressionbtn).tfy_Height(40);
        
        
        [self addSubview:self.bottomCotainer];
        self.bottomCotainer.tfy_LeftSpace(0).tfy_BottomSpace(-TFY_totalH).tfy_RightSpace(0).tfy_Height(TFY_totalH);
        
        [self.bottomCotainer addSubview:self.chatboxfaceView];
        [self.chatboxfaceView tfy_AutoSize:0 top:0 right:0 bottom:0];
    }
    return self;
}


-(void)setStatus:(ChatBoxStatus)status{
    if (_status == status) {
        return;
    }
    _status = status;
    switch (_status) {
        case ChatBoxStatusNothing:
        {
            [self.textView resignFirstResponder];
            [UIView animateWithDuration:0.3 animations:^{
                
            }];
        }
            break;
        case ChatBoxStatusShowKeyboard:
        {
            self.expressionbtn.selected = NO;
            [UIView animateWithDuration:duration animations:^{
                self.tfy_y = self->keyboardY - self.bottomCotainer.tfy_height+self.textView.tfy_height*2;

            }];
            [self.textView becomeFirstResponder];
        }
            break;
        case ChatBoxStatusShowVoLXe:
        {
            [self.textView resignFirstResponder];
            
            self.textView.hidden = YES;
            [UIView animateWithDuration:duration animations:^{
                
            }];
            
        }
            
            break;
        case ChatBoxStatusShowFace:
        {
            if (self.textView.isFirstResponder) {
                [self.textView resignFirstResponder];
            }
            self.expressionbtn.selected = YES;
            [UIView animateWithDuration:duration animations:^{
                self.tfy_y = self->keyboardY - self.textView.tfy_height*2;
                self.bottomCotainer.tfy_y = self.tfy_y;
            }];
            
        }
            
            break;
        case ChatBoxStatusShowMore:
        {
            
            
            if (self.textView.isFirstResponder) {
                [self.textView resignFirstResponder];
            }
        }
        default:
            break;
    }
    if ([self.delegate respondsToSelector:@selector(changeStatusChat:)]) {
        [self.delegate changeStatusChat:self.tfy_y];
    }
}

- (void)popToolbar{
    
    [self.textView becomeFirstResponder];
}

// 添加通知
-(void)addNotification {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelected:) name:EmotionDidSelectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteBtnClicked) name:EmotionDidDeleteNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendMessage) name:EmotionDidSendNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}




#pragma mark 通知 --- 删除--回退--
- (void)deleteBtnClicked
{
    [self.textView deleteBackward];
}

#pragma mark keyboardnotification
- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardY = keyboardFrame.size.height;
    duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    if (self.status == ChatBoxStatusShowMore ||self.status == ChatBoxStatusShowFace) {
        return;
    }
    [UIView animateWithDuration:duration animations:^{
        self.tfy_y = keyboardFrame.origin.y- self.tfy_height;
    }];
    if ([self.delegate respondsToSelector:@selector(changeStatusChat:)]) {
        [self.delegate changeStatusChat:self.tfy_y];
    }
}
- (void)keyboardWillHidden:(NSNotification *)notification {
    duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.tfy_y = TFY_PLAYER_ScreenH;
    }];
    if ([self.delegate respondsToSelector:@selector(changeStatusChat:)]) {
        [self.delegate changeStatusChat:self.tfy_y];
    }
}

#pragma mark 通知 --选择表情
- (void)emotionDidSelected:(NSNotification *)notifi
{
    TFY_EmotionModel *emotion = notifi.userInfo[SelectEmotionKey];
    if (emotion.code) {
        [self.textView insertText:emotion.code.emoji];
    } else if (emotion.face_name) {
        [self.textView insertText:emotion.face_name];
    }
}

#pragma mark---textview--代理方法---
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if (self.status != ChatBoxStatusShowKeyboard) {
        self.status = ChatBoxStatusShowKeyboard;
        
    }
    [self changeFrame:ceilf([textView sizeThatFits:textView.frame.size].height)];
}
-(void)textViewDidChange:(UITextView *)textView{
    [self changeFrame:ceilf([textView sizeThatFits:textView.frame.size].height)];
    
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [self sendMessage];
        return NO;
    }
    return YES;
}


#pragma mark --发送消息---
- (void)sendMessage{
    
    if (self.textView.text.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(chatBoxSendTextMessage:)]) {
            [self.delegate chatBoxSendTextMessage:self.textView.text];
        }
    }
    [self.textView setText:@""];
    self.textView.tfy_height = 40;
    [self textViewDidChange:self.textView];
    [self.textView resignFirstResponder];
}

-(UIView *)topContainer{
    if (!_topContainer) {
        _topContainer = [[UIView alloc] init];
        _topContainer.backgroundColor = [UIColor colorWithRed:0.15 green:0.11 blue:0.11 alpha:1.00];
    }
    return _topContainer;
}


-(UITextView *)textView{
    if (!_textView) {
        _textView = tfy_textView();
        _textView.placeholder = @"弹幕开始哦!";
        _textView.placeholderColor = [UIColor tfy_colorWithHex:LCColor_B3]; _textView.tfy_enablesReturnKeyAutomatically(YES).tfy_allowsNonContiguousLayout(NO).tfy_scrollsToTop(NO).tfy_textContainerInset(UIEdgeInsetsMake(10, 10, 10, 10), 0).tfy_font(16).tfy_textcolor([UIColor tfy_colorWithHex:LCColor_B1]).tfy_keyboardAppearance(UIKeyboardAppearanceDark).tfy_cornerRadius(15).tfy_returnKeyType(UIReturnKeySend).tfy_scrollEnabled(YES);
        _textView.delegate = self;
    }
    return _textView;
}

-(UIButton *)sendButton{
    if (!_sendButton) {
        _sendButton = tfy_button();
        _sendButton.tfy_title(@"发送", LCColor_B5, 14).tfy_alAlignment(1).tfy_backgroundColor(LCColor_A1, 1).tfy_action(self, @selector(sendButtonCliick)).tfy_cornerRadius(20);
    }
    return _sendButton;
}

-(UIButton *)expressionbtn{
    if (!_expressionbtn) {
        _expressionbtn = tfy_button();
        _expressionbtn.tfy_image(@"Expression.bundle/ToolViewEmotion", UIControlStateNormal).tfy_image(@"Expression.bundle/ToolViewEmotionHL", UIControlStateHighlighted).tfy_image(@"Expression.bundle/ToolViewKeyboard", UIControlStateSelected).tfy_action(self, @selector(expressionbtnCliick:));
    }
    return _expressionbtn;
}


-(UIView *)bottomCotainer{
    if (!_bottomCotainer) {
        _bottomCotainer = [UIView new];
        _bottomCotainer.backgroundColor = [UIColor clearColor];
    }
    return _bottomCotainer;
}

-(TFY_ChatBoxFaceView *)chatboxfaceView{
    if (!_chatboxfaceView) {
        _chatboxfaceView = [TFY_ChatBoxFaceView new];
        
    }
    return _chatboxfaceView;
}

- (void)changeFrame:(CGFloat)height{
    
    CGFloat maxH = 0;
    if (self.maxVisibleLine) {
        maxH = ceil(self.textView.font.lineHeight * (self.maxVisibleLine - 1) + self.textView.textContainerInset.top + self.textView.textContainerInset.bottom);
    }
    self.textView.scrollEnabled = height >maxH && maxH >0;
    if (self.textView.scrollEnabled) {
        height = 5+maxH;
    }else{
        height = height;
    }
    CGFloat textviewH = height;
    
    CGFloat totalH = 0;
    if (self.status == ChatBoxStatusShowFace || self.status == ChatBoxStatusShowMore) {
        totalH = height +TFY_totalH;
        if (keyboardY ==0) {
            keyboardY = TFY_PLAYER_ScreenH;
        }
//        self.tfy_y = keyboardY - totalH;
//        self.tfy_height = totalH;
//        self.topContainer.tfy_height = height;
//        self.bottomCotainer.tfy_y =self.topContainer.tfy_height;
//        self.textView.tfy_y = 7;
        self.textView.tfy_height = textviewH;
        
    }else
    {
//        totalH = height;
//        self.tfy_y = keyboardY - totalH;
//        self.tfy_height = totalH;
//        self.topContainer.tfy_height = totalH;
//        self.textView.tfy_y = 7;
        self.textView.tfy_height = textviewH;
//        self.bottomCotainer.tfy_y =self.topContainer.tfy_height;
    }
    
    if ([self.delegate respondsToSelector:@selector(changeStatusChat:)]) {
        [self.delegate changeStatusChat:self.tfy_y];
    }
    
    [self.textView scrollRangeToVisible:NSMakeRange(0, self.textView.text.length)];
}
//发送
-(void)sendButtonCliick{
    [self sendMessage];
}
//表情
-(void)expressionbtnCliick:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.status = ChatBoxStatusShowFace;
    }else{
        self.status = ChatBoxStatusShowKeyboard;
    }
}
@end
