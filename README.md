# PhotoBrowserDemo
#简介

今天看到[MWPhotoBrowser](https://github.com/mwaterfall/MWPhotoBrowser)框架，发现他在VC里面需要写的代码太多，如果我好多地方都使用的话，会出现代码冗余问题，今天我就简单的将[MWPhotoBrowser](https://github.com/mwaterfall/MWPhotoBrowser)封装一下。
这里我就简单的介绍下[MWPhotoBrowser](https://github.com/mwaterfall/MWPhotoBrowser)，它是目前在github上星级比较高的一款图片浏览软件，可以很方便的浏览图片。
#MWPhotoBrowser详解

对于MWPhotoBrowser我就不详解了，里面的一些设置元素请看下面我搜到的比较全的文章
[MWPhotoBrowser详解](http://blog.csdn.net/hsf_study/article/details/51783989?locationNum=5&fps=1)

#封装 继承MWPhotoBrowser

我所封装的MWPhotoBrowser只需简单的一句跳转，将图片的数组传过去就可以
```
HJPhotoBrowserController *photoVC = [[HJPhotoBrowserController alloc] initWithPhotos:self.photos];
    [photoVC setBlock:^(UIImage *image) {
        self.imageView.image = image;
    }];
    [self.navigationController pushViewController:photoVC animated:YES];
```

对于initWithPhotos:方法里面我做了以下处理
```
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
```
然后将MWPhotoBrowser的几个方法重写
```
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
```

这里我简单的介绍下怎么讲MWPhotoBrowser里面的MWPhoto模型转变为UIImage
```
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
```

然后直接使用 可以将此图片block回
```
id <MWPhoto> photo = [self photoBrowser:self photoAtIndex:self.index];
    UIImage *image = [self imageForPhoto:photo];
    if (self.block) {
        self.block(image);
    }
    [self.navigationController popViewControllerAnimated:YES];
```

[PhotoBrowserDemo下载](https://github.com/948769029/PhotoBrowserDemo)

----
若还有不懂的地方可以加下下方的QQ群 谢谢 可以动动你们的小手点下喜欢或者关注我哟
###群号1：[552048526](http://www.jianshu.com/p/07b136963fd7)
###群号2：[580284575](http://www.jianshu.com/p/07b136963fd7)
