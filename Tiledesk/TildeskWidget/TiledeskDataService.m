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

+ (NSString *)departmentsService {
    NSDictionary *tiledeskservice_dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TiledeskService-Info" ofType:@"plist"]];
    NSString *baseURL = [tiledeskservice_dictionary objectForKey:@"base-url"];
    NSString *departmentsService = [tiledeskservice_dictionary objectForKey:@"departments-service"];
    NSString *projectId = [TiledeskDataService getProjectId];
    if (projectId == nil) {
        NSLog(@"Error. Can't init departmentsService. 'projectId' not defined in Tiledesk-Info.plist. Please set 'projectId' to properly configure Tiledesk widget.");
    }
    NSString *departmentServiceURI = [NSString stringWithFormat:departmentsService, projectId];
    NSString *service = [NSString stringWithFormat:@"%@%@", baseURL, departmentServiceURI];
    NSLog(@"departments service url: %@", service);
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

- (void)downloadDepartmentsWithCompletionHandler:(void(^)(NSArray<TiledeskDepartment *> *departments, NSError *error))callback; {
//    NSURLSessionDataTask *currentTask = [self.tasks objectForKey:message.messageId];
//    if (currentTask) {
//        NSLog(@"Image %@ already downloading (messageId: %@).", message.imageURL, message.messageId);
//        return;
//    }
    NSURLSessionConfiguration *_config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *_session = [NSURLSession sessionWithConfiguration:_config];
    NSString *departmentsServiceURL = [TiledeskDataService departmentsService];
    NSURL *url = [NSURL URLWithString:departmentsServiceURL];
    NSLog(@"Downloading departments JSON. URL: %@", url);
    if (!url) {
        NSLog(@"ERROR - Can't download departments, service URL is null");
        return;
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSString *authStr = @"andrea.leo@frontiere21.it:123456";
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat: @"Basic %@",[authData base64EncodedStringWithOptions:0]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"JSON downloaded: %@", [[NSString alloc] initWithData:data encoding:kCFStringEncodingUTF8]);
        if (error) {
            NSLog(@"%@", error);
            callback(nil, error);
            return;
        }
        if (data) {
            NSArray<TiledeskDepartment *> *departments = [self JSON2Departments: data];
            if (departments) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback(departments, nil);
                });
            }
        }
    }];
    [task resume];
}

- (NSArray<TiledeskDepartment *> *)JSON2Departments:(NSData *)jsonData {
    NSMutableArray<TiledeskDepartment *> *departments = [[NSMutableArray alloc] init ];
    NSError* error;
    NSArray *departments_json = [NSJSONSerialization
                             JSONObjectWithData:jsonData
                             options:kNilOptions
                             error:&error];
    for(NSDictionary *dep_json in departments_json) {
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
