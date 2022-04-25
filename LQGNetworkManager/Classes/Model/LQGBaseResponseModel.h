//
//  LQGBaseResponseModel.h
//  LQGNetworkManager
//
//  Created by 罗建
//  Copyright (c) 2021 罗建. All rights reserved.
//

#import <LQGBaseModel/LQGBaseModel.h>

/// 基础响应模型类
@interface LQGBaseResponseModel : LQGBaseModel

/// 状态码
@property (nonatomic, assign) NSInteger code;

/// 状态描述
@property (nonatomic, copy  ) NSString *message;

/// 响应数据
@property (nonatomic, strong) id data;

@end
