//
//  ChangeView.m
//  ChangeViewDemo
//
//  Created by zhaoP on 16/8/8.
//  Copyright © 2016年 langya. All rights reserved.
//

#import "ChangeView.h"
#import <Masonry.h>

@interface ChangeView ()
@property (nonatomic,strong) NSMutableArray *itemViews;
@end

@implementation ChangeView

-(instancetype)initWithFrame:(CGRect)frame{
	if (self = [super initWithFrame:frame]) {
		UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
		[self addGestureRecognizer:pan];
	}
	return self;
}


-(NSMutableArray *)itemViews{
	if (!_itemViews) {
		_itemViews = [NSMutableArray array];
	}
	return _itemViews;
}

-(void)setModels:(NSArray *)models{
	for (UIView *subView in self.subviews) {
		[subView removeFromSuperview];
	}
	[self.itemViews removeAllObjects];
	
	_models = models;
	//本例中用titles做为例子，根据实际情况对models赋值
	for (id title in models) {
		if ([title isKindOfClass:[NSNull class]]) {
			[self.itemViews addObject:[NSNull null]];
			continue;
		}
		NSInteger index = [models indexOfObject:title];
		
		CGFloat leftOffset =  index == 0 ? self.frame.size.width * -1 : 0;
		SubChangeView *subView = [[SubChangeView alloc] initWithFrame:CGRectMake(leftOffset, 0, self.frame.size.width, self.frame.size.height)];
		subView.model = title;
		[self addSubview:subView];
		if (index ==0) {
			subView.backgroundColor = [UIColor yellowColor];
		}else if (index == 1){
			subView.backgroundColor = [UIColor greenColor];
		}else{
			subView.backgroundColor = [UIColor blueColor];
		}
		[self.itemViews addObject:subView];
	}
	
	SubChangeView *view1 = self.itemViews[1];
	if (view1) {
		[self bringSubviewToFront:view1];
	}
	SubChangeView *view0 = self.itemViews[0];
	if (![view0 isKindOfClass:[NSNull class]]) {
		[self bringSubviewToFront:view0];
	}
	
}

-(void)panAction:(UIPanGestureRecognizer *)pan{
	CGFloat x = [pan translationInView:self].x;
	if (pan.state == UIGestureRecognizerStateChanged) {
		if (x > 0) {
			if (![_models.firstObject isKindOfClass:[NSNull class]]) {
				SubChangeView *subView = self.itemViews[0];
				subView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, x, 0);
			}else{
				return;
			}
		}
		
		if (x < 0) {
			if (![_models.lastObject isKindOfClass:[NSNull class]]) {
				SubChangeView *subView = self.itemViews[1];
				subView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, x, 0);
			}else{
				return;
			}
		}
	}
	if (pan.state == UIGestureRecognizerStateEnded) {
		SubChangeView *subView;
		if (x > 0) {
			subView = self.itemViews[0];
			if ([subView isKindOfClass:[NSNull class]]) {
				return;
			}
			if (x > self.frame.size.width * 0.33) {
				subView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, self.frame.size.width, 0);
				if (self.rightSlideAction) {
					self.rightSlideAction();
				}
				
			}else{
				subView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
			}
		}
		
		if (x < 0) {
			subView = self.itemViews[1];
			if ([self.itemViews[2] isKindOfClass:[NSNull class]]) {
				return;
			}
			if (x < self.frame.size.width * -0.33 ){
				subView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -self.frame.size.width, 0);
				
				if (self.leftSlideAction) {
					self.leftSlideAction();
				}
			}else{
				subView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
			}
		}
	}
}
@end
