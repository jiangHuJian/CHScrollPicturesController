//
//  CHScrollPicturesViewCell.m
//  HtmlTest
//
//  Created by baoju_mac_2 on 16/9/27.
//  Copyright © 2016年 baoju_chenHanWei. All rights reserved.
//

#import "CHScrollPicturesViewCell.h"
#import "UIImage+GIF.h"
#import "UIImageView+WebCache.h"
@interface CHScrollPicturesViewCell()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,strong) UIImageView *imageV;
@property (nonatomic,assign)BOOL isScale;
@end
@implementation CHScrollPicturesViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.scrollView.delegate = self;
    self.scrollView.maximumZoomScale = 2.0;
    self.scrollView.minimumZoomScale = 0.5;
    UIImageView *imageV = [[UIImageView alloc]init];
    self.imageV = imageV;
    [self.scrollView addSubview:imageV];
    
    UITapGestureRecognizer *doubleTapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTapGesture setNumberOfTapsRequired:2];
    [self.scrollView addGestureRecognizer:doubleTapGesture];
}
- (void)handleDoubleTap:(UIGestureRecognizer *)gesture

{
    CGFloat zoomScale = self.scrollView.zoomScale;
    zoomScale = (zoomScale == 1.0 || zoomScale < 1.0) ? 2.0 : 1.0;
    CGRect zoomRect = [self zoomRectForScale:zoomScale withCenter:[gesture locationInView:gesture.view]];
    [self.scrollView zoomToRect:zoomRect animated:YES];
    
    
}


- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center

{
    
    CGRect zoomRect;
    zoomRect.size.height =self.scrollView.frame.size.height / scale;
    zoomRect.size.width  =self.scrollView.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  /2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height /2.0);
    return zoomRect;
}




-(void)imageWith:(NSString *)imageUrl imageSize:(NSString *)imageSize
{
    
    [self.scrollView setZoomScale:1.0 animated:YES];
    
    [self layoutIfNeeded];
    self.scrollView.contentSize = CGSizeMake(0,  self.frame.size.width * [imageSize floatValue]);
    self.imageV.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width * [imageSize floatValue]);
    if (self.frame.size.width *[imageSize floatValue]<self.scrollView.frame.size.height) {
        self.imageV.center = self.scrollView.center;
    }
    
    if ([imageUrl rangeOfString:@"gif" ].location != NSNotFound) {
        
        NSData *gif = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        self.imageV.image = [UIImage sd_animatedGIFWithData:gif];
        
    }else{
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    }
    
}
-(UIImage *)getImage
{
    return  self.imageV.image;
}


#pragma mark 当UIScrollView尝试进行缩放的时候就会调用
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return scrollView.subviews[0];
}
#pragma mark 当缩放完毕的时候调用
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{

    
    [UIView animateWithDuration:0.25 animations:^{
        
        CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
        (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
        CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
        (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
        view.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                  scrollView.contentSize.height * 0.5 + offsetY);
        
        
    }];
    
}





@end
