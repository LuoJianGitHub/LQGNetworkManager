//
//  LQGNetworkManager.m
//  LQGNetworkManager
//
//  Created by 罗建
//  Copyright (c) 2021 罗建. All rights reserved.
//

#import "LQGNetworkManager.h"

@implementation LQGNetworkManager


#pragma mark - 请求方法

//MARK:模型请求

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                 requestModel:(LQGBaseRequestModel *)requestModel
                      headers:(NSDictionary *)headers
                   completion:(MCompletion)completion {
    return [self HTTPMethod:LQGHTTPMethodGET
                  URLString:URLString
               requestModel:requestModel
                    headers:headers
                 completion:completion];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                  requestModel:(LQGBaseRequestModel *)requestModel
                       headers:(NSDictionary *)headers
                    completion:(MCompletion)completion {
    return [self HTTPMethod:LQGHTTPMethodPOST
                  URLString:URLString
               requestModel:requestModel
                    headers:headers
                 completion:completion];
}

- (NSURLSessionDataTask *)HTTPMethod:(LQGHTTPMethod)HTTPMethod
                           URLString:(NSString *)URLString
                        requestModel:(LQGBaseRequestModel *)requestModel
                             headers:(NSDictionary *)headers
                          completion:(MCompletion)completion {
    return [self HTTPMethod:HTTPMethod
                  URLString:URLString
                 parameters:requestModel.lqg_modelToDictionary
                    headers:headers
                 completion:completion];
}

//MARK:字典请求

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                      headers:(NSDictionary *)headers
                   completion:(MCompletion)completion {
    return [self HTTPMethod:LQGHTTPMethodGET
                  URLString:URLString
                 parameters:parameters
                    headers:headers
                 completion:completion];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                       headers:(NSDictionary *)headers
                    completion:(MCompletion)completion {
    return [self HTTPMethod:LQGHTTPMethodPOST
                  URLString:URLString
                 parameters:parameters
                    headers:headers
                 completion:completion];
}

- (NSURLSessionDataTask *)HTTPMethod:(LQGHTTPMethod)HTTPMethod
                           URLString:(NSString *)URLString
                          parameters:(NSDictionary *)parameters
                             headers:(NSDictionary *)headers
                          completion:(MCompletion)completion {
    // 处理AFNetwork 统一回调的block
    void(^resultBlock)(NSURLSessionDataTask *, LQGBaseResponseModel *) = [^(NSURLSessionDataTask *task, LQGBaseResponseModel *responseModel) {
        // 执行打印
        fprintf(stderr, "网络请求\n%s\n", [[NSString stringWithFormat:@"请求链接:\n%@\n请求头:\n%@\n请求参数:\n%@\n响应数据:\n%@", URLString, task.currentRequest.allHTTPHeaderFields, parameters, responseModel.lqg_modelToDictionary] UTF8String]);
        // 全局通知，方便业务方的全局处理
        [[NSNotificationCenter defaultCenter] postNotificationName:LQGNetworkNotificationName object:responseModel];
        // 执行业务方回调
        if (completion) {
            completion(responseModel);
        }
    } copy];
    
    // 处理AFNetwork success回调的block
    void(^successBlock)(NSURLSessionDataTask *, id) = [^(NSURLSessionDataTask *task, id responseObject) {
        // 将响应数据转为模型
        LQGBaseResponseModel *responseModel = [LQGBaseResponseModel lqg_modelWithDictionary:responseObject];
        // 执行统一回调
        resultBlock(task, responseModel);
    } copy];
    
    // 处理AFNetwork failure回调的block
    void(^failureBlock)(NSURLSessionDataTask *, NSError *) = [^(NSURLSessionDataTask *task, NSError *error) {
        // 将响应数据转为模型
        LQGBaseResponseModel *responseModel = [[LQGBaseResponseModel alloc] init];
        responseModel.code = error.code;
        responseModel.message = error.localizedDescription;
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        if (response) {
            responseModel.code = response.statusCode;
        }
        
        NSData *data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
        if (data) {
            NSString *message = [NSJSONSerialization JSONObjectWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] options:NSJSONReadingMutableLeaves error:nil][@"Message"];
            if (message.length) {
                responseModel.message = message;
            }
        }
        // 执行统一回调
        resultBlock(task, responseModel);
    } copy];
    
    switch (HTTPMethod) {
        case LQGHTTPMethodGET:
            return [self
                    GET:URLString
                    parameters:parameters
                    headers:headers
                    progress:nil
                    success:successBlock
                    failure:failureBlock];
        case LQGHTTPMethodPOST:
            return [self
                    POST:URLString
                    parameters:parameters
                    headers:headers
                    progress:nil
                    success:successBlock
                    failure:failureBlock];
        case LQGHTTPMethodPUT:
            return [self
                    PUT:URLString
                    parameters:parameters
                    headers:headers
                    success:successBlock
                    failure:failureBlock];
        case LQGHTTPMethodDELETE:
            return [self
                    DELETE:URLString
                    parameters:parameters
                    headers:headers
                    success:successBlock
                    failure:failureBlock];
        case LQGHTTPMethodHEAD:
            return [self
                    HEAD:URLString
                    parameters:parameters
                    headers:headers
                    success:^(NSURLSessionDataTask * _Nonnull task) {
                        successBlock(task, nil);
                    } failure:failureBlock];
        case LQGHTTPMethodPATCH:
            return [self
                    PATCH:URLString
                    parameters:parameters
                    headers:headers
                    success:successBlock
                    failure:failureBlock];
        default:
            return nil;
    }
}

@end
