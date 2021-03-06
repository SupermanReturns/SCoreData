//
//  SManagedObject.m
//  SCoreData
//
//  Created by Superman on 2018/10/11.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import "SManagedObject.h"

@implementation SManagedObject

+(instancetype)createNewObject{
    SManagedObject *obj=[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:[SCoredata shareInstance].mainManagedObjectContext];
    return obj;
}
+(instancetype)createNewObjectInContext:(NSManagedObjectContext *)context{
    SManagedObject *obj = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    return obj;
}
+(NSError *)save:(OperationResult)handler{
    return [[SCoredata shareInstance] save:handler];
}
+(NSArray *)filterWithPredicate:(NSString *)predicate orderby:(NSArray *)orders offset:(int)offset limit:(int)limit{
    NSManagedObjectContext *context = [SCoredata shareInstance].mainManagedObjectContext;
    NSFetchRequest *fetchRequest = [self makeRequest:context predicate:predicate orderby:orders offset:offset limit:limit];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"error: %@", error);
        return @[];
    }
    return results;
}
+(void)filter:(NSString *)predicate orderby:(NSArray *)orders offset:(int)offset limit:(int)limit on:(ListResult)handler{
    
    NSManagedObjectContext *context = [[SCoredata shareInstance] createPrivateManagedObjectContext];
    [context performBlock:^{
        NSFetchRequest *fetchRequest =[self makeRequest:context predicate:predicate orderby:orders offset:offset limit:limit];
        NSError *error = nil;
        NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
        if (error) {
            NSLog(@"error: %@", error);
            [[SCoredata shareInstance].mainManagedObjectContext performBlock:^{
                handler(@[],nil);
            }];
        }
        if ([results count]<1) {
            [[SCoredata shareInstance].mainManagedObjectContext performBlock:^{
                handler(@[],nil);
            }];
        }
        NSMutableArray *result_ids = [[NSMutableArray alloc]init];
        for (NSManagedObject *item in results) {
            [result_ids addObject:item.objectID];
        }
        [[SCoredata shareInstance].mainManagedObjectContext performBlock:^{
            NSMutableArray *final_results = [[NSMutableArray alloc]init];
            for (NSManagedObjectID *oid in result_ids) {
                [final_results addObject:[[SCoredata shareInstance].mainManagedObjectContext objectWithID:oid]];
            }
            handler(final_results,nil);
        }];
    }];
}
+(id)oneObject:(NSString *)predicate{
    NSManagedObjectContext *context = [SCoredata shareInstance].mainManagedObjectContext;
    NSFetchRequest *fetchRequest = [self makeRequest:context predicate:predicate orderby:nil offset:0 limit:1];
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
    if ([results count] !=1) {
        return nil;
    }
    return results[0];
}
+(void)oneObject:(NSString *)predicate on:(ObjectResult)handler{
    NSManagedObjectContext *ctx = [[SCoredata shareInstance]createPrivateManagedObjectContext];
    [ctx performBlock:^{
        NSFetchRequest *fetchRequest = [self makeRequest:ctx predicate:predicate orderby:nil offset:0 limit:1];
        NSError *error = nil;
        NSArray *results = [ctx executeFetchRequest:fetchRequest error:&error];
        if (error) {
            NSLog(@"error: %@", error);
            [[SCoredata shareInstance].mainManagedObjectContext performBlock:^{
                handler(@[],nil);
            }];
        }
        if ([results count]<1) {
            [[SCoredata shareInstance].mainManagedObjectContext performBlock:^{
                handler(@[],nil);
            }];
        }
        NSManagedObjectID *objId =(( NSManagedObject*)results[0]).objectID;
        [[SCoredata shareInstance].mainManagedObjectContext performBlock:^{
            handler([[SCoredata shareInstance].mainManagedObjectContext objectWithID:objId],nil);
        }];
    }];
}
-(void)removeFromContext{
    [[SCoredata shareInstance].mainManagedObjectContext deleteObject:self];
}
+(NSFetchRequest *)makeRequest:(NSManagedObjectContext *)context predicate:(NSString *)predicate orderby:(NSArray *)orders offset:(int)offset limit:(int)limit{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:NSStringFromClass(self) inManagedObjectContext:context]];
    if (predicate) {
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:predicate]];
    }
    NSMutableArray *orderArray=[[NSMutableArray alloc]init];
    if (orders !=nil) {
        for (NSString *order in orders) {
            NSSortDescriptor *orderDesc  =nil;
            if ([[order substringToIndex:1] isEqualToString:@"-"]) {
                orderDesc = [[NSSortDescriptor alloc]initWithKey:[order substringFromIndex:1] ascending:NO];
            }else{
                orderDesc = [[NSSortDescriptor alloc]initWithKey:order ascending:YES];
            }
            [orderArray addObject:orderDesc];
        }
        [fetchRequest setSortDescriptors:orderArray];
    }
    if (offset>0) {
        [fetchRequest setFetchOffset:offset];
    }
    if (limit>0) {
        [fetchRequest setFetchOffset:limit];
    }
    return fetchRequest;
}
@end



























