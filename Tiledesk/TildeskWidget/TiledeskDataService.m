//
//  TiledeskDataService.m
//  chat21
//
//  Created by Andrea Sponziello on 29/05/2018.
//  Copyright © 2018 Frontiere21. All rights reserved.
//

#import "TiledeskDataService.h"
#import "TiledeskDepartment.h"

@implementation TiledeskDataService

-(id)init {
    self = [super init];
    if (self) {
        // Init code
    }
    return self;
}

+ (NSString *)widgetsService {
    NSDictionary *tiledeskservice_dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TiledeskService-Info" ofType:@"plist"]];
    NSString *baseURL = [tiledeskservice_dictionary objectForKey:@"base-url"];
    NSString *widgetsService = [tiledeskservice_dictionary objectForKey:@"widgets-service"];
    NSString *projectId = [TiledeskDataService getProjectId];
    if (projectId == nil) {
        NSLog(@"Error. Can't init widget. 'projectId' is not defined in Tiledesk-Info.plist. Please set 'projectId' to properly configure Tiledesk widget.");
    }
    NSString *widgetsServiceURI = [NSString stringWithFormat:widgetsService, projectId];
    NSString *service = [NSString stringWithFormat:@"%@/%@", baseURL, widgetsServiceURI];
    NSLog(@"widgets service url: %@", service);
    return service;
}

+ (NSString *)getProjectId {
    NSDictionary *tiledesk_dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Tiledesk-Info" ofType:@"plist"]];
    if (tiledesk_dictionary == nil) {
        return nil;
    }
    NSString *projectId = [tiledesk_dictionary objectForKey:@"projectId"];
    return projectId;
}

- (void)downloadWidgetDataWithCompletionHandler:(void(^)(NSData *data, NSError *error))callback {
//    NSURLSessionDataTask *currentTask = [self.tasks objectForKey:message.messageId];
//    if (currentTask) {
//        NSLog(@"Image %@ already downloading (messageId: %@).", message.imageURL, message.messageId);
//        return;
//    }
    NSURLSessionConfiguration *_config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *_session = [NSURLSession sessionWithConfiguration:_config];
    NSString *departmentsServiceURL = [TiledeskDataService widgetsService];
    NSURL *url = [NSURL URLWithString:departmentsServiceURL];
    NSLog(@"Downloading widgets JSON. URL: %@", url);
    if (!url) {
        NSLog(@"ERROR - Can't download widgets data, service URL is null");
        return;
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"JSON downloaded: %@", [[NSString alloc] initWithData:data encoding:kCFStringEncodingUTF8]);
        if (error) {
            NSLog(@"%@", error);
            callback(nil, error);
            return;
        }
        if (data) {
//            NSArray<TiledeskDepartment *> *departments = [self JSON2Departments: data];
            if (data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback(data, nil);
                });
            }
        }
    }];
    [task resume];
}

+ (NSArray<TiledeskDepartment *> *)JSON2Departments:(NSData *)jsonData {
    NSMutableArray<TiledeskDepartment *> *departments = [[NSMutableArray alloc] init ];
    NSError* error;
    NSDictionary *widget_json = [NSJSONSerialization
                             JSONObjectWithData:jsonData
                             options:kNilOptions
                             error:&error];
    for(NSDictionary *dep_json in widget_json[@"departments"]) {
        NSString *depId = [dep_json valueForKey:@"_id"];
        NSString *name = [dep_json valueForKey:@"name"];
        BOOL isDefault = [[dep_json valueForKey:@"default"] boolValue];
        
//        NSLog(@"default (%d)boolValue - (%@) prop type: %@",isDefault, [dep_json valueForKey:@"default"], NSStringFromClass([[dep_json valueForKey:@"default"] class]));
        
        TiledeskDepartment *dep = [[TiledeskDepartment alloc] init];
        dep.departmentId = depId;
        dep.name = name;
        dep.isDefault = isDefault;
        [departments addObject:dep];
    }
    return departments;
}

@end
