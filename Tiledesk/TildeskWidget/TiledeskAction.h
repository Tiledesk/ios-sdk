//
//  TiledeskAction.h
//  chat21
//
//  Created by Andrea Sponziello on 12/06/2018.
//  Copyright © 2018 Frontiere21. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class TiledeskDepartment;
@class ChatUser;

@interface TiledeskAction : NSObject

-(void)openSupportView:(UIViewController *)sourcevc;

//@property (nonatomic, copy) void (^endWizardCallback)(NSDictionary *attributes);
@property (nonatomic, strong) UIViewController *sourcevc;
//@property (strong, nonatomic) NSMutableDictionary *context;

@property (strong, nonatomic) TiledeskDepartment *department;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSDictionary *attributes;

-(void)connectAnonymousWithCompletion:(void (^)(ChatUser *user, NSError *error))callback;
-(void)dismissWizardAndOpenMessageViewWithSupport;

@end
