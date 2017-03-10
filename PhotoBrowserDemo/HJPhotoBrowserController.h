//
//  HJPhotoBrowserController.h
//  PhotoBrowserDemo
//
//  Created by apple on 2017/3/10.
//  Copyright © 2017年 张洪健. All rights reserved.
//

#import <MWPhotoBrowser/MWPhotoBrowser.h>

@interface HJPhotoBrowserController : MWPhotoBrowser

@property (nonatomic, copy) void(^block)(UIImage *);

@end
