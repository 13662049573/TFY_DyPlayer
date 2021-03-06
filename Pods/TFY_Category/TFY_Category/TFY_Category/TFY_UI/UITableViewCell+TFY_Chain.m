//
//  UITableViewCell+TFY_Chain.m
//  TFY_Category
//
//  Created by tiandengyou on 2019/12/11.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import "UITableViewCell+TFY_Chain.h"

@implementation UITableViewCell (TFY_Chain)

+ (instancetype)cellHeaderFromXib
{
    NSString *className = NSStringFromClass(self);
    return [[[NSBundle mainBundle] loadNibNamed:className owner:nil options:nil] lastObject];
}
+ (instancetype)cellFromXibWithTableView:(UITableView *)tableView
{
    NSString *className = NSStringFromClass(self);
    return [self cellFromXibTableView:tableView xibName:className identifer:className];
}

+ (instancetype)cellFromXibWithTableView:(UITableView *)tableView identifer:(NSString *)identifier
{
    NSString *className = NSStringFromClass(self);
    return [self cellFromXibTableView:tableView xibName:className identifer:identifier];
}

+ (instancetype)cellFromXibTableView:(UITableView *)tableView xibName:(NSString *)xibName identifer:(NSString *)identifier
{
    id cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        NSString *xibPath =  [[NSBundle mainBundle] pathForResource:xibName ofType:@"nib"];
        if(xibPath == nil){
            cell = [self cellFromCodeWithTableView:tableView identifier:identifier];
        }else{
            cell = [[[NSBundle mainBundle] loadNibNamed:xibName owner:nil options:nil] lastObject];
        }
        return cell;

    }
    return cell;
}

+ (instancetype)cellFromCodeWithTableView:(UITableView *)tableView
{
    NSString *className = NSStringFromClass(self);
    id cell = [tableView dequeueReusableCellWithIdentifier:className];
    if(cell == nil){
        cell = [[NSClassFromString(className) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:className];
    }
    return cell;
}
+ (instancetype)cellFromCodeWithTableView:(UITableView *)tableView identifier:(NSString *)identifier
{
    NSString *className = NSStringFromClass(self);
    id cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[NSClassFromString(className) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
#pragma mark - 代码实例化一个cell

- (UITableView *)parentTableView
{
    UIView * view = self.superview;
    while(view != nil) {
        if([view isKindOfClass:[UITableView class]]) {
            return (UITableView*) view;
        }
        view = view.superview;
    }
    return nil;
}
@end


@implementation UICollectionViewCell (TFY_Chain)

- (UICollectionView *)parentCollectionView
{
    UIView * view = self.superview;
    while(view != nil) {
        if([view isKindOfClass:[UICollectionView class]]) {
            return (UICollectionView*) view;
        }
        view = view.superview;
    }
    return nil;
}
@end
