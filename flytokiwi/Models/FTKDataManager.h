//
//  FTKDataManager.h
//  flytokiwi
//
//  Created by Q on 14-10-5.
//  Copyright (c) 2014年 zwq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTKDataManager : NSObject

+ (instancetype)sharedData;
- (NSArray *)fetchData;

@end
