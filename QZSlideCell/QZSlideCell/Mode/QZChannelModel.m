//
//  ALChannelModel.m
//  获取cell在tableview中的位置
//
//  Created by 陈彦雨 on 15/12/3.
//  Copyright © 2015年 AL. All rights reserved.
//

#import "QZChannelModel.h"

@implementation QZChannelModel

-(instancetype)initWithDict:(NSDictionary *)dict{
	if (self = [super init]) {
		[self setValuesForKeysWithDictionary:dict];
	}
	return self;
}

+(instancetype)channelModelWithDict:(NSDictionary *)dict{
	return [[self alloc] initWithDict:dict];
}


@end
