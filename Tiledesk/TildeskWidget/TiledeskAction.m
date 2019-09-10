//
//  TiledeskAction.m
//  chat21
//
//  Created by Andrea Sponziello on 12/06/2018.
//  Copyright © 2018 Frontiere21. All rights reserved.
//

#import "TiledeskAction.h"
#import "TiledeskStartVC.h"
#import "ChatUser.h"
#import "ChatGroup.h"
#import "ChatAuth.h"
#import "ChatManager.h"
#import "ChatUIManager.h"
#import "TiledeskDepartment.h"
#import "FIRApp.h"

@implementation TiledeskAction

-(void)connectAnonymousWithCompletion:(void (^)(ChatUser *user, NSError *error))callback {
    if ([FIRApp defaultApp] == nil) {
        [FIRApp configure];
    }
    if ([ChatManager getInstance].tenant == nil) {
        [ChatManager configure];
        [ChatAuth authAnonymousWithCompletion:^(ChatUser *user, NSError *error) {
            if (error) {
                NSLog(@"Authentication error. %@", error);
                callback(nil, error);
            }
            else {
                ChatManager *chatm = [ChatManager getInstance];
                NSLog(@"Firebase Anonymous Auth. userid: %@", user.userId);
                user.firstname = @"Andrea Mobile Tester";
                user.lastname = @"";
                [chatm startWithUser:user];
                callback(user, nil);
            }
        }];
    }
}

-(void)openSupportView:(UIViewController *)sourcevc {
//    self.context = [[NSMutableDictionary alloc] init];
    self.sourcevc = sourcevc;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Help_request" bundle:nil];
    UINavigationController *nc = [storyboard instantiateViewControllerWithIdentifier:@"help-wizard"];
    TiledeskStartVC *firstStep = (TiledeskStartVC *)[[nc viewControllers] objectAtIndex:0];
    firstStep.helpAction = self;
//    self.endWizardCallback = ^(NSDictionary *attributes) {
        // TODO send metadata
        // TODO remove System's messages
        
//        ChatUser *recipient = [[ChatUser alloc] init:support_group_id fullname:@"Support"];
//        [[ChatUIManager getInstance] openConversationMessagesViewAsModalWith:(ChatUser *)recipient  viewController:self attributes:nil withCompletionBlock:^{
//            NSLog(@"Messages view dismissed.");
//        }];
//    };
//    firstStep.endWizardCallback = self.endWizardCallback;
    //    firstStep.context = [[NSMutableDictionary alloc] init];
    //    [firstStep.context setObject:sourcevc forKey:@"view-controller"];
    [sourcevc presentViewController:nc animated:YES completion:^{
        // NSLog(@"Presented");
    }];
}

-(void)dismissWizardAndOpenMessageViewWithSupport {
    
//    HelpDepartment *dep = (HelpDepartment *)[self.context objectForKey:@"department"];
    NSLog(@"department: %@[%@]", self.department.name, self.department.departmentId);
    NSString * uuid = [[NSUUID UUID] UUIDString];
    NSString *support_group_id = [[NSString alloc] initWithFormat:@"support-group-%@", uuid];
    NSLog(@"opening conversation with support group id: %@", support_group_id);
    // attributes setObject department
    // attributes setObject iPhone (vedi devices)
    
    [self.sourcevc dismissViewControllerAnimated:YES completion:^{
        ChatGroup *support_group = [[ChatGroup alloc] initWithGroupId:support_group_id name:@"Andrea Mobile Test"];
        
        ChatManager *chatm = [ChatManager getInstance];
        NSMutableDictionary *members = [[NSMutableDictionary alloc] init];
        [members setObject:@(true) forKey:chatm.loggedUser.userId];
        support_group.members = members;
        [[ChatUIManager getInstance] openConversationMessagesViewAsModalWithGroup:support_group  viewController:self.sourcevc attributes:self.attributes withCompletionBlock:^{
            NSLog(@"Messages view dismissed.");
        }];
//        ChatUser *user = [[ChatUser alloc] init:support_group_id fullname:@"Andrea Mobile Test"];
//        [[ChatUIManager getInstance] openConversationMessagesViewAsModalWithUser:user  viewController:self.sourcevc attributes:self.attributes withCompletionBlock:^{
//                NSLog(@"Messages view dismissed.");
//        }];
    }];
    
}

@end
