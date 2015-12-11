//
//  ZSRStatusPhotosView.h
//  weibo
//
//  Created by hp on 15/12/11.
//  Copyright © 2015年 hp. All rights reserved.
//  cell上面的配图相册（里面会显示1~9张图片, 里面都是ZSRStatusPhotoView

#import <UIKit/UIKit.h>

@interface ZSRStatusPhotosView : UIView
@property (nonatomic, strong) NSArray *photos;

/**
 *  根据图片个数计算相册的尺寸
 */
+ (CGSize)sizeWithCount:(int)count;
@end
