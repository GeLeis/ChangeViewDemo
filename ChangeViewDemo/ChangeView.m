//
//  ChangeView.m
//  ChangeViewDemo
//
//  Created by zhaoP on 16/8/8.
//  Copyright © 2016年 langya. All rights reserved.
//

#import "ChangeView.h"
#import <Masonry.h>

typedef NS_ENUM(NSInteger,LYBSlideDirection) {
	LYBSlideDirectionNone,
	LYBSlideDirectionLeft,
	LYBSlideDirectionRight,
};

@interface ChangeView ()
@property (nonatomic,strong) NSMutableArray *itemViews;
@property (nonatomic,assign) LYBSlideDirection slideDirection;
@property (nonatomic,strong) NSMutableDictionary *originFrames;

@end

@implementation ChangeView

-(instancetype)initWithFrame:(CGRect)frame{
	if (self = [super initWithFrame:frame]) {
		self.slideDirection = LYBSlideDirectionNone;
		UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
		[self addGestureRecognizer:pan];
	}
	return self;
}

-(NSMutableDictionary *)originFrames{
	if (!_originFrames) {
		_originFrames = [NSMutableDictionary dictionary];
	}
	return _originFrames;
}

-(NSMutableArray *)itemViews{
	if (!_itemViews) {
		_itemViews = [NSMutableArray array];
	}
	return _itemViews;
}

-(void)setModels:(NSArray *)models{
	_models = models;
	[self.originFrames removeAllObjects];
	NSLog(@"%@",models);
	if (self.slideDirection == LYBSlideDirectionLeft) {
		//    <-----
		
		SubChangeView *firsttView = self.itemViews.firstObject;
		if (![firsttView isKindOfClass:[NSNull class]]) {
			[firsttView removeFromSuperview];
		}
		[self.itemViews removeObjectAtIndex:0];
	}else if (self.slideDirection == LYBSlideDirectionRight){
		//   ----->
		
		SubChangeView *lastView = self.itemViews.lastObject;
		if (![lastView isKindOfClass:[NSNull class]]) {
			[lastView removeFromSuperview];
		}
		
		[self.itemViews removeLastObject];
	}
	//本例中用titles做为例子，根据实际情况对models赋值
	for (id title in models) {
		NSInteger index = [models indexOfObject:title];
		SubChangeView *subView;
		if (self.slideDirection == LYBSlideDirectionNone) {
			if ([title isKindOfClass:[NSNull class]]) {
				[self.itemViews addObject:[NSNull null]];
				continue;
			}
			
			subView = [[SubChangeView alloc] init];
			subView.model = title;
			
			[self.itemViews addObject:subView];
		}else if (self.slideDirection == LYBSlideDirectionLeft){
			if (index == 2) {
				if ([title isKindOfClass:[NSNull class]]) {
					[self.itemViews addObject:[NSNull null]];
					continue;
				}
				subView = [[SubChangeView alloc] init];
				subView.model = title;
				[self.itemViews addObject:subView];
			}

		}else if (self.slideDirection == LYBSlideDirectionRight){
			if (index == 0) {
				if ([title isKindOfClass:[NSNull class]]) {
					[self.itemViews insertObject:[NSNull null] atIndex:0];
					continue;
				}
				subView = [[SubChangeView alloc] init];
				subView.model = title;
				[self.itemViews insertObject:subView atIndex:0];
			}
		}
		if (subView) {
			[self addSubview:subView];
		}
		
		
	}
	
	
	//测试为了区分时使用的背景色.
	SubChangeView *view2 = self.itemViews[2];
	if (![view2 isKindOfClass:[NSNull class]]) {
		view2.backgroundColor = [UIColor blueColor];
		view2.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
		[self.originFrames setValue:[NSValue valueWithCGRect:view2.frame] forKey:@"2"];
	}
	
	SubChangeView *view1 = self.itemViews[1];
	if (view1) {
		view1.backgroundColor = [UIColor greenColor];
		view1.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
		[self bringSubviewToFront:view1];
		
		[self.originFrames setValue:[NSValue valueWithCGRect:view1.frame] forKey:@"1"];
	}
	SubChangeView *view0 = self.itemViews[0];
	if (![view0 isKindOfClass:[NSNull class]]) {
		view0.backgroundColor = [UIColor yellowColor];
		view0.frame = CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
		[self bringSubviewToFront:view0];
		[self.originFrames setValue:[NSValue valueWithCGRect:view0.frame] forKey:@"0"];
	}
	
	
	
	
}

-(void)panAction:(UIPanGestureRecognizer *)pan{
	CGFloat x = [pan translationInView:self].x;
	SubChangeView *subView;
	NSValue *value;
	CGRect frame;
	if (pan.state == UIGestureRecognizerStateChanged) {
		if (x > 0) {
			if (![_models.firstObject isKindOfClass:[NSNull class]]) {
				subView = self.itemViews[0];
				value = self.originFrames[@"0"];
				frame = [value CGRectValue];
				subView.frame = CGRectMake(frame.origin.x + x, frame.origin.y, frame.size.width, frame.size.height);
			}else{
				return;
			}
		}
		
		if (x < 0) {
			if (![_models.lastObject isKindOfClass:[NSNull class]]) {
				subView = self.itemViews[1];
				value = self.originFrames[@"1"];
				frame = [value CGRectValue];
				subView.frame = CGRectMake(frame.origin.x + x, frame.origin.y, frame.size.width, frame.size.height);
			}else{
				return;
			}
		}
	}
	if (pan.state == UIGestureRecognizerStateEnded) {
		if (x > 0) {
			subView = self.itemViews[0];
			if ([subView isKindOfClass:[NSNull class]]) {
				return;
			}
			if (x > self.frame.size.width * 0.33) {
				value = self.originFrames[@"0"];
				frame = [value CGRectValue];
				subView.frame = CGRectMake(frame.origin.x + frame.size.width, frame.origin.y, frame.size.width, frame.size.height);
				
				self.slideDirection = LYBSlideDirectionRight;
				if (self.rightSlideAction) {
					self.rightSlideAction();
				}

				
			}else{
				value = self.originFrames[@"0"];
				frame = [value CGRectValue];
				subView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);

			}
		}
		
		if (x < 0) {
			subView = self.itemViews[1];
			if ([self.itemViews[2] isKindOfClass:[NSNull class]]) {
				return;
			}
			if (x < self.frame.size.width * -0.33 ){
				value = self.originFrames[@"1"];
				frame = [value CGRectValue];
				subView.frame = CGRectMake(frame.origin.x -frame.size.width , frame.origin.y, frame.size.width, frame.size.height);
				self.slideDirection = LYBSlideDirectionLeft;
				if (self.leftSlideAction) {
					self.leftSlideAction();
				}
				
			}else{
				value = self.originFrames[@"1"];
				frame = [value CGRectValue];
				subView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
			}
		}
	}
}
@end
