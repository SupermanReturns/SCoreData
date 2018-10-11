//
//  SCoredata.m
//  SCoreData
//
//  Created by Superman on 2018/10/11.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import "SCoredata.h"

@interface SCoredata()

@property (nonatomic, strong) NSString *modelName;
@property (nonatomic, strong) NSString *storeName;
@property (readonly, strong, nonatomic) NSManagedObjectContext *backgroundManagedObjectContext;

@end

@implementation SCoredata

@synthesize mainManagedObjectContext = _mainManagedObjectContext;
@synthesize backgroundManagedObjectContext = _backgroundManagedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+(instancetype)shareInstance{
    static SCoredata *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[SCoredata alloc]init];
    });
    return instance;
}

-(void)setUpCoreDataWithModelName:(NSString *)modelName DBFile:(NSString *)fileName{
    self.modelName = modelName;
    self.storeName = fileName;
    [self coreDataInitialize];
}
-(void)coreDataInitialize{
    NSPersistentStoreCoordinator *coordinator  =[self persistentStoreCoordinator];
    
}

@end

























