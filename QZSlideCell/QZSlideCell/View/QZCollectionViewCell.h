//
//  ALCollectionViewCell.h
//  获取cell在tableview中的位置
//
//  Created by 陈彦雨 on 15/12/1.
//  Copyright © 2015年 AL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QZChannelModel.h"

@interface QZCollectionViewCell : UICollectionViewCell
@property (nonatomic ,weak) UIImageView *imageView;
@property (nonatomic ,strong) QZChannelModel *channelModel;

@end
