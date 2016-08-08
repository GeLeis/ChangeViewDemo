//
//  SubChangeView.m
//  ChangeViewDemo
//
//  Created by zhaoP on 16/8/8.
//  Copyright © 2016年 langya. All rights reserved.
//

#import "SubChangeView.h"
#import <Masonry.h>
@interface SubChangeView ()
@property (nonatomic,strong) UILabel *label;
@end

@implementation SubChangeView

-(instancetype)initWithFrame:(CGRect)frame{
	if (self = [super initWithFrame:frame]) {
		_label = [[UILabel alloc] init];
		[self addSubview:_label];
		{
			[_label mas_makeConstraints:^(MASConstraintMaker *make) {
				make.center.equalTo(self);
			}];
		}
	}
	return self;
}

-(void)setModel:(NSString *)model{
	_model = model;
	_label.text = model;
}
@end
