//
//  SCoredata.h
//  SCoreData
//
//  Created by Superman on 2018/10/11.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef void(^OperationResult)(NSError* error);

@interface SCoredata : NSObject

/*
 *  主线程context
 */
@property (readonly, strong, nonatomic) NSManagedObjectContext *mainManagedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

/*
 *  单例方法
 */
+ (instancetype)shareInstance;

/*
 *  初始化coredata，在AppDelegate中
 *  - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions调用
 */
- (void)setUpCoreDataWithModelName:(NSString *)modelName DBFile:(NSString *)fileName;

/*
 *  创建子线程下context
 */
- (NSManagedObjectContext *)createPrivateManagedObjectContext;

/*
 *  主线程下context保存方法
 */
- (NSError *)save:(OperationResult)handler;


@end
