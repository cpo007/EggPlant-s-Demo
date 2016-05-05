//
//  ViewController.m
//  获取cell在tableview中的位置
//
//  Created by 陈彦雨 on 15/12/1.
//  Copyright © 2015年 AL. All rights reserved.
//

#import "ViewController.h"
#import "QZCollectionViewCell.h"
#import "QZChannelModel.h"
#define kScreenBounds [UIScreen mainScreen].bounds
#define kScreenWidth kScreenBounds.size.width
#define kScreenHeight kScreenBounds.size.height
#define kHeaderVeiwHeight 50
#define kSeperator 5
#define kCellHeight 200

//偏移量
#define kOutOfRange 120
#define kCellCount 8


@interface ViewController ()<UICollectionViewDataSource ,UICollectionViewDelegate>

@property (weak, nonatomic) UICollectionView *collectionView;

@property (strong ,nonatomic) NSArray *channels;


@end

@implementation ViewController

#pragma mark - lazy
-(NSArray *)channels{
	if (!_channels) {
		_channels = [NSArray array];
	}
	return _channels;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
	
	UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:layout];
	self.collectionView = collectionView;
	layout.itemSize = CGSizeMake(kScreenWidth, kCellHeight);
	layout.minimumLineSpacing = 5;
	layout.minimumInteritemSpacing = 0;
	collectionView.dataSource = self;
	collectionView.delegate = self;
	
	[self.collectionView registerClass:[QZCollectionViewCell class] forCellWithReuseIdentifier:@"QZCollectionViewCell"];
	
	[self.view addSubview:collectionView];
	self.automaticallyAdjustsScrollViewInsets = NO;
	
	[self loadData];
}

-(void)loadData{
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Channel" ofType:@"plist"];
	NSArray *dictArray = [NSArray arrayWithContentsOfFile:filePath];
	
	NSMutableArray *tempArray = [NSMutableArray array];
	[dictArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		QZChannelModel *model = [QZChannelModel channelModelWithDict:obj];
		[tempArray addObject:model];
	}];
	
	self.channels = tempArray;
	[self.collectionView reloadData];
}

#pragma mark - data source
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
	return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
	return kCellCount;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
	QZCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QZCollectionViewCell" forIndexPath:indexPath];
	
	if (nil == cell){
		cell = [[QZCollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kCellHeight)];
	}
	CGFloat offset = [self getRelativeDistanceWithCell:cell];
	
	cell.imageView.frame = CGRectMake(0, -kOutOfRange + offset, [UIScreen mainScreen].bounds.size.width, cell.frame.size.height + 2*kOutOfRange);
	
	NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"logo_%ld.jpg",indexPath.row] ofType:nil];
	
	cell.imageView.image = [UIImage imageNamed:path];
	cell.channelModel = self.channels[indexPath.row];
	return cell;
}

#pragma mark - delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
	[self.collectionView.visibleCells enumerateObjectsUsingBlock:^(__kindof QZCollectionViewCell * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
		CGFloat offset = [self getRelativeDistanceWithCell:cell];
		
		CGRect frame = cell.imageView.frame;
		cell.imageView.frame = CGRectMake(0, -kOutOfRange + offset, frame.size.width, frame.size.height);
	}];
}

-(CGFloat)getRelativeDistanceWithCell:(UICollectionViewCell *)cell{
	CGPoint point = [cell convertPoint:cell.frame.origin fromView:self.view];
	CGFloat sY = cell.frame.origin.y - point.y + kCellHeight + kSeperator;
	CGFloat length_2 = 0.5 * (kScreenHeight + kCellHeight + kSeperator);
	CGFloat offset = kOutOfRange/length_2 * (sY - length_2);
	
	return offset;
}

#pragma mark - memory warning
- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
