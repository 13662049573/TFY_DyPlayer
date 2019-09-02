//
//  TFY_TabBarItem.m
//  TFY_AutoLayoutModelTools
//
//  Created by 田风有 on 2019/5/14.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import "TFY_TabBarItem.h"

@interface TFY_TabBarItem ()
@property UIImage *unselectedBackgroundImage;
@property UIImage *selectedBackgroundImage;
@property UIImage *unselectedImage;
@property UIImage *selectedImage;
@property NSString *selectetitle;
@property NSString *unselectedtitle;
@end

@implementation TFY_TabBarItem

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitialization];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInitialization];
    }
    return self;
}

- (id)init {
    return [self initWithFrame:CGRectZero];
}

- (void)commonInitialization {
    // Setup defaults
    
    [self setBackgroundColor:[UIColor whiteColor]];
    
    self.titlePositionAdjustment = UIOffsetZero;
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_8_0) {
        
        //设置初始字体颜色
        self.unselectedTitleAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor lightGrayColor]};
        //设置点击后的文字颜色
        self.selectedTitleAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor blackColor]};
        
    }
    self.badgeBackgroundColor = [UIColor redColor];
    self.badgeTextColor = [UIColor whiteColor];
    self.badgeTextFont = [UIFont systemFontOfSize:12];
    self.badgePositionAdjustment = UIOffsetZero;
}


- (void)drawRect:(CGRect)rect {
    CGSize frameSize = self.frame.size;
    CGSize imageSize = CGSizeZero;
    CGSize titleSize = CGSizeZero;
    NSDictionary *titleAttributes = nil;
    UIImage *backgroundImage = nil;
    UIImage *image = nil;
    CGFloat imageStartingY = 0.0f;
    
    if ([self isSelected]) {
        image = [self selectedImage];
        backgroundImage = [self selectedBackgroundImage];
        titleAttributes = [self selectedTitleAttributes];
        
        if (!titleAttributes) {
            titleAttributes = [self unselectedTitleAttributes];
        }
    } else {
        image = [self unselectedImage];
        backgroundImage = [self unselectedBackgroundImage];
        titleAttributes = [self unselectedTitleAttributes];
    }
    
    imageSize = [image size];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    [backgroundImage drawInRect:self.bounds];
    
    // Draw image and title
    
    if (![_title length]) {
        [image drawInRect:CGRectMake(roundf(frameSize.width / 2 - imageSize.width / 2) + _imagePositionAdjustment.horizontal, roundf(frameSize.height / 2 - imageSize.height / 2) + _imagePositionAdjustment.vertical, imageSize.width, imageSize.height)];
    } else {
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_8_0) {
            titleSize = [_title boundingRectWithSize:CGSizeMake(frameSize.width, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: titleAttributes[NSFontAttributeName]} context:nil].size;
            
            imageStartingY = roundf((frameSize.height - imageSize.height - titleSize.height) / 2);
            
            [image drawInRect:CGRectMake(roundf(frameSize.width / 2 - imageSize.width / 2) + _imagePositionAdjustment.horizontal, imageStartingY + _imagePositionAdjustment.vertical, imageSize.width, imageSize.height)];
            
            CGContextSetFillColorWithColor(context, [titleAttributes[NSForegroundColorAttributeName] CGColor]);
            
            [_title drawInRect:CGRectMake(roundf(frameSize.width / 2 - titleSize.width / 2) + _titlePositionAdjustment.horizontal, imageStartingY + imageSize.height + _titlePositionAdjustment.vertical+3, titleSize.width, titleSize.height)
                withAttributes:titleAttributes];
        }
    }
    
    // Draw badges
    
    if ([[self badgeValue] length]) {
        CGSize badgeSize = CGSizeZero;
        
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_8_0) {
            badgeSize = [_badgeValue boundingRectWithSize:CGSizeMake(frameSize.width, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [self badgeTextFont]} context:nil].size;
        }
        CGFloat textOffset = 2.0f;
        
        if (badgeSize.width < badgeSize.height) {
            badgeSize = CGSizeMake(badgeSize.height, badgeSize.height);
        }
        
        CGRect badgeBackgroundFrame = CGRectMake(roundf(frameSize.width / 2 + (image.size.width / 2) * 0.9) + [self badgePositionAdjustment].horizontal, textOffset + [self badgePositionAdjustment].vertical, badgeSize.width + 2 * textOffset, badgeSize.height + 2 * textOffset);
        
        if ([self badgeBackgroundColor]) {
            CGContextSetFillColorWithColor(context, [[self badgeBackgroundColor] CGColor]);
            
            CGContextFillEllipseInRect(context, badgeBackgroundFrame);
        } else if ([self badgeBackgroundImage]) {
            [[self badgeBackgroundImage] drawInRect:badgeBackgroundFrame];
        }
        
        CGContextSetFillColorWithColor(context, [[self badgeTextColor] CGColor]);
        
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_8_0) {
            NSMutableParagraphStyle *badgeTextStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
            [badgeTextStyle setLineBreakMode:NSLineBreakByWordWrapping];
            [badgeTextStyle setAlignment:NSTextAlignmentCenter];
            
            NSDictionary *badgeTextAttributes = @{
                                                  NSFontAttributeName: [self badgeTextFont],
                                                  NSForegroundColorAttributeName: [self badgeTextColor],
                                                  NSParagraphStyleAttributeName: badgeTextStyle,
                                                  };
            
            [[self badgeValue] drawInRect:CGRectMake(CGRectGetMinX(badgeBackgroundFrame) + textOffset,
                                                     CGRectGetMinY(badgeBackgroundFrame) + textOffset,
                                                     badgeSize.width, badgeSize.height) withAttributes:badgeTextAttributes];
        }
    }
    
    CGContextRestoreGState(context);
}

#pragma mark - Image configuration

- (UIImage *)finishedSelectedImage {
    return [self selectedImage];
}

- (UIImage *)finishedUnselectedImage {
    return [self unselectedImage];
}

- (void)setFinishedSelectedImage:(NSString *)selectedImage_Str withFinishedUnselectedImage:(NSString *)unselectedImage_Str{
    
    UIImage *selectedImage =[UIImage imageNamed:selectedImage_Str];
    UIImage *unselectedImage =[UIImage imageNamed:unselectedImage_Str];
    
    if (selectedImage && (selectedImage != [self selectedImage])) {
        [self setSelectedImage:selectedImage];
    }
    
    if (unselectedImage && (unselectedImage != [self unselectedImage])) {
        [self setUnselectedImage:unselectedImage];
    }
}

-(void)tabarTitle:(NSString *)selectedtitle FontOfSize:(CGFloat)ofszie ColorTitle:(UIColor *)color Unselectedtitle:(NSString *)unselectedtitle UnTitleFontOfSize:(CGFloat)unofszie UnColorTitle:(UIColor *)untitlecolor{
    if (selectedtitle && (selectedtitle !=[self selectetitle])) {
        [self setTitle:selectedtitle];
        //设置点击后的文字颜色
        self.selectedTitleAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:ofszie],NSForegroundColorAttributeName:color};
    }
    if (unselectedtitle && (unselectedtitle != [self unselectedtitle])) {
        [self setTitle:unselectedtitle];
        //设置初始字体颜色
        self.unselectedTitleAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:unofszie],NSForegroundColorAttributeName:untitlecolor};
    }
}



- (void)setBadgeValue:(NSString *)badgeValue {
    _badgeValue = badgeValue;
    [self setNeedsDisplay];
}
#pragma mark - Background configuration

- (UIImage *)backgroundSelectedImage {
    return [self selectedBackgroundImage];
}

- (UIImage *)backgroundUnselectedImage {
    return [self unselectedBackgroundImage];
}

- (void)setBackgroundSelectedImage:(NSString *)selectedImage_Str withUnselectedImage:(NSString*)unselectedImage_Str{
    UIImage *selectedImage =[UIImage imageNamed:selectedImage_Str];
    UIImage *unselectedImage =[UIImage imageNamed:unselectedImage_Str];
    
    if (selectedImage && (selectedImage != [self selectedBackgroundImage])) {
        [self setSelectedBackgroundImage:selectedImage];
    }
    
    if (unselectedImage && (unselectedImage != [self unselectedBackgroundImage])) {
        [self setUnselectedBackgroundImage:unselectedImage];
    }
}
- (void)setBackgroundImage:(UIImage *)selectedImage withUnImage:(UIImage*)unselectedImage{
    if (selectedImage && (selectedImage != [self selectedBackgroundImage])) {
        [self setSelectedBackgroundImage:selectedImage];
    }
    
    if (unselectedImage && (unselectedImage != [self unselectedBackgroundImage])) {
        [self setUnselectedBackgroundImage:unselectedImage];
    }
}

@end
