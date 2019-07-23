//
//  PZoomImage.m
//  PImageZoom
//
//  Created by Apple on 2017/4/11.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "PZoomImage.h"

@interface PZoomImage ()<UIScrollViewDelegate>
{
    NSInteger _imageCount;
     CGFloat _offset;
}
//@property(strong,nonatomic)UIScrollView *imageScrollView;;
@end
@implementation PZoomImage

-(instancetype)initWithFrame:(CGRect)frame imageCount:(NSInteger)imageCount
{
    _imageCount=imageCount;
    _offset=0;
    self=[super initWithFrame:frame];
    if (self) {
        self.scrollEnabled = YES;
        self.pagingEnabled = YES;
        self.backgroundColor=[UIColor blackColor];
        self.contentSize = CGSizeMake(self.frame.size.width*_imageCount, self.frame.size.height);
        [self initView];
    }
    return self;
}

-(void)initView
{
    for (int i = 0; i<_imageCount; i++){
        UITapGestureRecognizer *doubleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        [doubleTap setNumberOfTapsRequired:2];
    
        UIScrollView *imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.frame.size.width*i, 0,self.frame.size.width, self.frame.size.height)];
        imageScrollView.backgroundColor = [UIColor clearColor];
        imageScrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        imageScrollView.delegate = self;
        imageScrollView.minimumZoomScale = 1.0;
        imageScrollView.maximumZoomScale = 3.0;
        [imageScrollView setZoomScale:1.0];
        
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        NSString *imageName = [NSString stringWithFormat:@"%d.jpg",i%2];
        imageview.image = [UIImage imageNamed:imageName];
        imageview.userInteractionEnabled = YES;
 //       imageview.tag = i+1;
//        if (i==0) {
//            [UIView animateWithDuration:0.4 animations:^{
//                imageview.frame=CGRectMake(0,0, self.frame.size.width, self.frame.size.height);
//            } completion:^(BOOL finished) {
//                imageview.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//            }];
//        }else{
//            imageview.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//        }
        [imageview addGestureRecognizer:doubleTap];
        [imageScrollView addSubview:imageview];
        [self addSubview:imageScrollView];
    }
}

#pragma mark -gesture
-(void)handleDoubleTap:(UIGestureRecognizer *)gesture{
    
    float newScale = [(UIScrollView*)gesture.view.superview zoomScale] * 1.5;
    CGRect zoomRect = [self zoomRectForScale:newScale  inView:(UIScrollView*)gesture.view.superview withCenter:[gesture locationInView:gesture.view]];
    [(UIScrollView*)gesture.view.superview zoomToRect:zoomRect animated:YES];
}
- (CGRect)zoomRectForScale:(float)scale inView:(UIScrollView*)scrollView withCenter:(CGPoint)center {
    CGRect zoomRect;
    zoomRect.size.height = [scrollView frame].size.height / scale;
    zoomRect.size.width  = [scrollView frame].size.width  / scale;
    
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}

#pragma mark - ScrollView delegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    for (UIImageView *imageView in scrollView.subviews){
        return imageView;
    }
    return nil;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    for (UIImageView *imageView in scrollView.subviews) {
        CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?(scrollView.bounds.size.width - scrollView.contentSize.width)/2 : 0.0;
        CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?(scrollView.bounds.size.height - scrollView.contentSize.height)/2 : 0.0;
        imageView.center = CGPointMake(scrollView.contentSize.width/2 + offsetX,scrollView.contentSize.height/2 + offsetY);
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView != self) return;
    
    CGFloat x = scrollView.contentOffset.x;
    if (x == _offset) return;
    
    _offset = x;
    for (UIScrollView *view in scrollView.subviews){
        if ([view isKindOfClass:[UIScrollView class]]){
            [view setZoomScale:1.0];
        }
    }
}
@end
