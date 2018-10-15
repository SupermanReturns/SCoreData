//
//  People.h
//  SCoreData
//
//  Created by Superman on 2018/10/15.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SManagedObject.h"
#import <CoreData/CoreData.h>

@interface People : SManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * sex;
@property (nonatomic, retain) NSNumber * height;

@end
