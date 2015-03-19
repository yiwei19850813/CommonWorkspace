//
//  BaseEntity.h
//  MiguMV
//  description:网络接口实体的基类
//  Created by xdyang on 14-8-22.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import "JSONModel.h"


/**
 *  请求返回的状态
 */
@interface StatusEntity : JSONModel

@property (nonatomic)int status;
@property (nonatomic,strong)NSString *message;

@end

/**
 *  请求返回的基类
 */
@interface BaseEntity : StatusEntity

@property (nonatomic, strong)NSString *salt;


@end


@interface OptionalJSONModel : JSONModel

@end
