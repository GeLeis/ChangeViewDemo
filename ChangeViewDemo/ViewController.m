//
//  ViewController.m
//  ChangeViewDemo
//
//  Created by zhaoP on 16/8/8.
//  Copyright © 2016年 langya. All rights reserved.
//

#import "ViewController.h"
#import "ChangeView.h"
#import <Masonry.h>
#import <ReactiveCocoa/RACEXTScope.h>
#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#define kScreen_Width [UIScreen mainScreen].bounds.size.width
@interface ViewController ()
@property (nonatomic,strong) NSArray *dataSource;
@property (nonatomic,assign) int currentIndex;
@property (nonatomic,strong) ChangeView *changeView;
@property (nonatomic,strong) NSMutableArray *currentModels;
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	_changeView = [[ChangeView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width - 15 * 2, kScreen_Height - 50 * 2)];
	[self.view addSubview:_changeView];
	{
		[_changeView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.center.equalTo(self.view);
			make.size.mas_equalTo(CGSizeMake(kScreen_Width - 15 * 2, kScreen_Height - 50 * 2));
		}];
	}
	//向左
	@weakify(self);
	_changeView.leftSlideAction = ^(){
		@strongify(self);
		self.currentIndex++;
		
	};
	//向右
	_changeView.rightSlideAction = ^(){
		@strongify(self);
		self.currentIndex--;
	};
}

-(void)setCurrentIndex:(int)currentIndex{
	_currentIndex = currentIndex;
	
	[self.currentModels removeAllObjects];
	if (_currentIndex == 0) {
		[self.currentModels addObject:[NSNull null]];
	}else{
		[self.currentModels addObject:self.dataSource[_currentIndex - 1]];
	}
	
	[self.currentModels addObject:self.dataSource[_currentIndex]];
	if (_currentIndex == self.dataSource.count - 1) {
		[self.currentModels addObject:[NSNull null]];
	}else{
		[self.currentModels addObject:self.dataSource[_currentIndex + 1]];
	}
	_changeView.models = self.currentModels;
}

-(NSMutableArray *)currentModels{
	if (!_currentModels) {
		_currentModels = [NSMutableArray array];
	}
	return _currentModels;
}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	self.currentIndex = 1;
}

-(NSArray *)dataSource{
	if (!_dataSource) {
		NSMutableArray *mut = [NSMutableArray array];
		for (int i = 0; i < 10; i++) {
			[mut addObject:[NSString stringWithFormat:@"%d",i]];
		}
		_dataSource = mut;
	}
	return  _dataSource;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
