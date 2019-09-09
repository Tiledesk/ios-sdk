//
//  TiledeskDataService.h
//  chat21
//
//  Created by Andrea Sponziello on 29/05/2018.
//  Copyright © 2018 Frontiere21. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TiledeskDepartment;

@interface TiledeskDataService : NSObject

+ (NSString *)departmentsService;
- (void)downloadDepartmentsWithCompletionHandler:(void(^)(NSArray<TiledeskDepartment *> *departments, NSError *error))callback;

@end
