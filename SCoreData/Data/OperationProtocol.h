//
//  OperationProtocol.h
//  SCoreData
//
//  Created by Superman on 2018/10/11.
//  Copyright © 2018年 Superman. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "SCoredata.h"

typedef void(^ListResult)(NSArray *result,NSError *error);
typedef void(^ObjectResult)(id result,NSError *error);

@protocol OperationProtocol <NSObject>

/*
 *  主线程下创建对象
 */
+ (instancetype)createNewObject;

/*
 *  在其他context下创建对象
 */
+ (instancetype)createNewObjectInContext:(NSManagedObjectContext *)context;

/*
 *  主线程下保存方法
 */
+ (NSError*)save:(OperationResult)handler;

/*
 *  主线程下查询方法 会阻塞
 */
+ (NSArray*)filterWithPredicate:(NSString *)predicate orderby:(NSArray *)orders offset:(int)offset limit:(int)limit;

/*
 *  主线程下查询方法 不会阻塞，结果以block形式返回
 */
+ (void)filter:(NSString *)predicate orderby:(NSArray *)orders offset:(int)offset limit:(int)limit on:(ListResult)handler;

/*
 *  主线程下查询单个对象方法 会阻塞
 */
+ (id)oneObject:(NSString*)predicate;

/*
 *  主线程下查询单个方法 不会阻塞，结果以block形式返回
 */
+ (void)oneObject:(NSString*)predicate on:(ObjectResult)handler;

/*
 *  主线程下删除自身对象方法
 */
- (void)removeFromContext;




@end
