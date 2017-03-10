//
//  ViewController.m
//  PhotoBrowserDemo
//
//  Created by apple on 2017/3/3.
//  Copyright © 2017年 张洪健. All rights reserved.
//

#import "ViewController.h"
#import <MWPhotoBrowser/MWPhotoBrowser.h>
#import "HJPhotoBrowserController.h"

@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>


@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) MWPhoto *photo;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ViewController

- (NSMutableArray *)photos
{
    if (!_photos) {
        _photos = [NSMutableArray array];
    }
    return _photos;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    for (NSInteger i = 1; i < 8; i++) {
        [self.photos addObject:[UIImage imageNamed:[NSString stringWithFormat:@"photo%zd.jpg",i]]];
    }
    [self.photos addObject:@"http://dc.dazhangfang.com:80/Chat/chatimage/appuse00000000e7pROU0005/a24cc169-3575-47e6-abea-4b6719fc5ba8.jpg"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 100, 50);
    button.center = CGPointMake(self.view.center.x, 100);
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"浏览图片" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *openXC = [UIButton buttonWithType:UIButtonTypeCustom];
    openXC.frame = CGRectMake(0, 0, 100, 50);
    openXC.center = CGPointMake(self.view.center.x, 200);
    openXC.backgroundColor = [UIColor redColor];
    [openXC setTitle:@"打开相册" forState:UIControlStateNormal];
    [openXC addTarget:self action:@selector(openXC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:openXC];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, 400, 400);
    imageView.center = CGPointMake(self.view.center.x, 500);
    imageView.backgroundColor = [UIColor redColor];
    self.imageView = imageView;
    [self.view addSubview:imageView];
}

- (void)btnAction
{
    HJPhotoBrowserController *photoVC = [[HJPhotoBrowserController alloc] initWithPhotos:self.photos];
    [photoVC setBlock:^(UIImage *image) {
        self.imageView.image = image;
    }];
    [self.navigationController pushViewController:photoVC animated:YES];
}

- (void)openXC
{
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.photos addObject:image];
}

@end
