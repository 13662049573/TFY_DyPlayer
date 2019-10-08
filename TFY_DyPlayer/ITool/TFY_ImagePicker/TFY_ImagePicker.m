//
//  TFY_ImagePicker.m
//  TFY_DyPlayer
//
//  Created by 田风有 on 2019/7/18.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "TFY_ImagePicker.h"
#import "TFY_ClipViewController.h"
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
@interface TFY_ImagePicker ()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,ClipViewControllerDelegate>
@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, copy) ImagePickerFinishAction finishAction;
@property (nonatomic, assign) BOOL allowsEditing;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, strong) NSURL *imageUrl;
@property (nonatomic, copy) NSString *title;
@end

static TFY_ImagePicker *bdImagePickerInstance = nil;

@implementation TFY_ImagePicker

+ (void)showImagePickerFromViewController:(UIViewController *)viewController allowsEditing:(BOOL)allowsEditing finishAction:(ImagePickerFinishAction)finishAction {
    if (bdImagePickerInstance == nil) {
        bdImagePickerInstance = [[TFY_ImagePicker alloc] init];
    }
    
    [bdImagePickerInstance showImagePickerFromViewController:viewController
                                               allowsEditing:allowsEditing
                                                finishAction:finishAction];
}

- (void)showImagePickerFromViewController:(UIViewController *)viewController
                            allowsEditing:(BOOL)allowsEditing
                             finishAction:(ImagePickerFinishAction)finishAction {
    _viewController = viewController;
    _viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    _finishAction = finishAction;
    _allowsEditing = allowsEditing;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择相册" message:@"有裁剪和未裁剪功能" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self PickerControllerSourceTypePhotoLibrary];
            
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            [self PickerControllerSourceTypeCamera];
            
        }]];
    }else {
        [alertController addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self PickerControllerSourceTypePhotoLibrary];
            
        }]];
    }
   [_viewController presentViewController:alertController animated:YES completion:nil];
}

-(void)PickerControllerSourceTypeCamera{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.allowsEditing = _allowsEditing;
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    [_viewController presentViewController:picker animated:NO completion:^{}];
}
-(void)PickerControllerSourceTypePhotoLibrary{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = _allowsEditing;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    [_viewController presentViewController:picker animated:NO completion:^{}];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //获取图片的名字信息
    self.imageUrl = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        ALAssetRepresentation *representation = [myasset defaultRepresentation];
        
        UIImage *image = info[UIImagePickerControllerEditedImage];
        NSString * imgName=[representation filename];
        if (image == nil) {
            image = info[UIImagePickerControllerOriginalImage];
        }
        if (imgName==nil || [imgName isEqualToString:@"(null)"]) {
            //保存图片至本地，上传图片到服务器
            [self saveImage:image WithName:@"avatar.png"];
            NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"avatar.png"];
            image = [[UIImage alloc] initWithContentsOfFile:fullPath];
            imgName=@"avatar.png";
        }
        TFY_ClipViewController * clipView =[[TFY_ClipViewController alloc] initWithImage:image WithName:imgName];
        clipView.delegate = self;
        clipView.clipType = CIRCULARCLIP;
        clipView.radius = 120;
        [picker pushViewController:clipView animated:YES];
    };
    
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init] ;
    [assetslibrary assetForURL:self.imageUrl resultBlock:resultblock failureBlock:nil];
    
}
#pragma mark - ClipViewControllerDelegate
-(void)ClipViewController:(TFY_ClipViewController *)clipViewController FinishClipImage:(UIImage *)editImage WithName:(NSString *)imageName
{
    [clipViewController dismissViewControllerAnimated:YES completion:^{
        if (self->_finishAction) {
            self->_finishAction(editImage,imageName);
            bdImagePickerInstance = nil;
        }
    }];
}

-(void)RetirementController:(TFY_ClipViewController *)clipViewController{
    [clipViewController dismissViewControllerAnimated:YES completion:^{
        
        bdImagePickerInstance = nil;
        
    }];
}
#pragma mark -UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if (_finishAction) {
        UIImage *image = nil;
        _finishAction(image,@"");
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    bdImagePickerInstance = nil;
}

#pragma mark--保存图片至沙盒
-(void)saveImage:(UIImage *)currentImage WithName:(NSString *)imageName{
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 1);
    //获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    //将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
    
}


@end
