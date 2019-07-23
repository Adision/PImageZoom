//
//  ViewController.m
//  PImageZoom
//
//  Created by Apple on 2017/4/11.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ViewController.h"

#import "PZoomImage.h"

@interface ViewController ()

@property(strong,nonatomic)PZoomImage*imageScrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _imageScrollView=[[PZoomImage alloc] initWithFrame:self.view.bounds imageCount:4];
    [self.view addSubview:_imageScrollView];
}

@end
