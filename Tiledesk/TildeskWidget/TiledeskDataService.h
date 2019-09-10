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

+ (NSString *)widgetsService;
- (void)downloadWidgetDataWithCompletionHandler:(void(^)(NSData *data, NSError *error))callback;
+ (NSArray<TiledeskDepartment *> *)JSON2Departments:(NSData *)jsonData;

@end
