//
//  HJPhotoBrowserController.m
//  PhotoBrowserDemo
//
//  Created by apple on 2017/3/10.
//  Copyright © 2017年 张洪健. All rights reserved.
//

#import "HJPhotoBrowserController.h"

@interface HJPhotoBrowserController ()<MWPhotoBrowserDelegate>

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, assign) NSInteger index;

@end

@implementation HJPhotoBrowserController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"驳回" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemAction)];
}

- (id)initWithPhotos:(NSArray *)photosArray
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < photosArray.count; i++) {
        if ([photosArray[i] isKindOfClass:[UIImage class]]) {
            [array addObject:[MWPhoto photoWithImage:photosArray[i]]];
        } else {
            [array addObject:[MWPhoto photoWithURL:[NSURL URLWithString:photosArray[i]]]];
        }
    }
    photosArray = [array copy];
    if (self = [super initWithPhotos:photosArray]) {
        [self.photos addObjectsFromArray: photosArray];
    }
    return self;
}

#pragma mark - 懒加载
- (NSMutableArray *)photos
{
    if (!_photos) {
        _photos = [NSMutableArray array];
    }
    return _photos;
}

#pragma mark - buttonAction
- (void)rightBarButtonItemAction
{
    id <MWPhoto> photo = [self photoBrowser:self photoAtIndex:self.index];
    UIImage *image = [self imageForPhoto:photo];
    if (self.block) {
        self.block(image);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * 将MWPhoto模型转成UIImage
 */
- (UIImage *)imageForPhoto:(id<MWPhoto>)photo {
    if (photo) {
        // Get image or obtain in background
        if ([photo underlyingImage]) {
            return [photo underlyingImage];
        } else {
            [photo loadUnderlyingImageAndNotify];
        }
    }
    return nil;
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    self.index = index;
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    
    if (index < self.photos.count) {
        return [self.photos objectAtIndex:index];
    }
    return nil;
}

@end
