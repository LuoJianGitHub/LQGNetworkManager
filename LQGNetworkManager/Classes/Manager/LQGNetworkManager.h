//
//  LQGNetworkManager.h
//  LQGNetworkManager
//
//  Created by 罗建
//  Copyright (c) 2021 罗建. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

#import <LQGNetworkManager/LQGBaseRequestModel.h>
#import <LQGNetworkManager/LQGBaseResponseModel.h>

#define LQGNetworkNotificationName @"LQGNetworkNotificationName"

/**
 LQGHTTPMethod请求方式
 
 - LQGHTTPMethodGET: GET请求
 - LQGHTTPMethodPOST: POST请求
 - LQGHTTPMethodPUT: PUT请求
 - LQGHTTPMethodDELETE: DELETE请求
 - LQGHTTPMethodHEAD: HEAD请求
 - LQGHTTPMethodPATCH: PATCH请求
 */
typedef NS_ENUM(NSUInteger, LQGHTTPMethod) {
    LQGHTTPMethodGET,
    LQGHTTPMethodPOST,
    LQGHTTPMethodPUT,
    LQGHTTPMethodDELETE,
    LQGHTTPMethodHEAD,
    LQGHTTPMethodPATCH,
};

/// 数据层回调
typedef void(^MCompletion)(LQGBaseResponseModel *responseModel);

/// 网络管理类
@interface LQGNetworkManager : AFHTTPSessionManager

//MARK: - 模型请求

/// GET请求
/// @param URLString 请求路径
/// @param requestModel 请求参数模型
/// @param headers 请求头
/// @param completion 回调
- (NSURLSessionDataTask *)GET:(NSString *)URLString
                 requestModel:(LQGBaseRequestModel *)requestModel
                      headers:(NSDictionary *)headers
                   completion:(MCompletion)completion;

/// POST请求
/// @param URLString 请求路径
/// @param requestModel 请求参数模型
/// @param headers 请求头
/// @param completion 回调
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                  requestModel:(LQGBaseRequestModel *)requestModel
                       headers:(NSDictionary *)headers
                    completion:(MCompletion)completion;

/// 通用请求
/// @param HTTPMethod 请求方式
/// @param URLString 请求路径
/// @param requestModel 请求参数模型
/// @param headers 请求头
/// @param completion 回调
- (NSURLSessionDataTask *)HTTPMethod:(LQGHTTPMethod)HTTPMethod
                           URLString:(NSString *)URLString
                        requestModel:(LQGBaseRequestModel *)requestModel
                             headers:(NSDictionary *)headers
                          completion:(MCompletion)completion;

//MARK: - 字典请求

/// GET请求
/// @param URLString 请求路径
/// @param parameters 请求参数字典
/// @param headers 请求头
/// @param completion 回调
- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                      headers:(NSDictionary *)headers
                   completion:(MCompletion)completion;

/// POST请求
/// @param URLString 请求路径
/// @param parameters 请求参数字典
/// @param headers 请求头
/// @param completion 回调
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                       headers:(NSDictionary *)headers
                    completion:(MCompletion)completion;

/// 通用请求
/// @param HTTPMethod 请求方式
/// @param URLString 请求路径
/// @param parameters 请求参数字典
/// @param headers 请求头
/// @param completion 回调
- (NSURLSessionDataTask *)HTTPMethod:(LQGHTTPMethod)HTTPMethod
                           URLString:(NSString *)URLString
                          parameters:(NSDictionary *)parameters
                             headers:(NSDictionary *)headers
                          completion:(MCompletion)completion;

@end
