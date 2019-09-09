//
//  TiledeskFacade.h
//  bppmobile
//
//  Created by Andrea Sponziello on 05/10/2017.
//  Copyright © 2017 Frontiere21. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class ChatUser;

@interface TiledeskFacade : NSObject

@property(assign, nonatomic) BOOL supportEnabled;

-(void)activateSupportBarButton:(UIViewController *)vc;
+(TiledeskFacade *)sharedInstance;
-(void)openSupportView:(UIViewController *)sourcevc;
-(void)sendMessage:(NSString *)text toRecipient:(ChatUser *)recipient attributes:(NSDictionary *)attributes;
+(NSString*)deviceName;
-(void)chatAction:(NSDictionary *)context fromSection:(NSString *)section;
-(void)handleWizardSupportFromViewController:(UIViewController *)vc helpContext:(NSDictionary *)context;
-(void)dismissWizard:(UIViewController *)sourcevc;

@end
