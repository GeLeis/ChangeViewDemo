//
//  ChangeView.h
//  ChangeViewDemo
//
//  Created by zhaoP on 16/8/8.
//  Copyright © 2016年 langya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubChangeView.h"
@interface ChangeView : UIView
@property (nonatomic,strong) NSArray *models;
//向左滑
@property (nonatomic,copy) void (^leftSlideAction)();
//向右滑
@property (nonatomic,copy) void (^rightSlideAction)();

@end
