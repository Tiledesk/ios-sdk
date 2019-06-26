//
//  HelpDescriptionStepTVC.m
//  bppmobile
//
//  Created by Andrea Sponziello on 05/10/2017.
//  Copyright © 2017 Frontiere21. All rights reserved.
//

#import "HelpDescriptionStepTVC.h"
#import "HelpCategoryStepTVC.h"
#import "HelpDepartment.h"
#import "HelpLocal.h"
#import "HelpAction.h"

@interface HelpDescriptionStepTVC ()

@end

@implementation HelpDescriptionStepTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // init description text field
    self.descriptionTextView.delegate = self;
    //    kPlaceholderDescription = NSLocalizedString(@"jobWizardDescriptionPlaceholder", nil);
    NSString *message = self.helpAction.message;
    if (message) {
        self.descriptionTextView.text = message;
    }
    [self validateDescription];
    
    self.nextButton.title = [HelpLocal translate:@"Help wizard send button"];
    self.titleLabel.text = [HelpLocal translate:@"help wizard title"];
    self.subtitleLabel.text = [HelpLocal translate:@"help wizard description"];//@"Descrivi sinteticamente il tuo problema, ti metteremo in contatto con un operatore specializzato";//NSLocalizedString(@"description subtitle", nil);
    self.navigationItem.title = [HelpLocal translate:@"help wizard navigation title"];
    
    // test
//    NSLog(@"helpAction: %@", self.helpAction);
}

//- (void)resetDescription
//{
//    self.descriptionTextView.text = kPlaceholderDescription;
//    self.descriptionTextView.textColor = [UIColor lightGrayColor];
//}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.descriptionTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Navigation

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"next"]) {
//        NSObject *vc = (NSObject *)[segue destinationViewController];
//        NSString *description = self.descriptionTextView.text;
//        [self saveDescription:description];
//        [self.context setObject:description forKey:@"description"];
//        [vc setValue:self.context forKey:@"context"];
//    }
//}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSString *description = self.descriptionTextView.text;
    [self saveDescription:description];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString *lastDescription = [self loadDescription];
    if (lastDescription) {
        self.descriptionTextView.text = lastDescription;
        [self validateDescription];
    }
}

#pragma mark - Validate text

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"textViewDidBeginEditing...");
    // Clear the message text when the user starts editing
    //    if ([self.descriptionTextView.text isEqualToString:kPlaceholderDescription]) {//|| [textView.text isEqualToString:kPlaceholderDescription]
    //        self.descriptionTextView.text = @"";
    //        self.descriptionTextView.textColor = [UIColor blackColor];
    //    }
}

static NSInteger MAX_CHARACTERS_DESCRIPTION = 600;
static NSInteger MIN_CHARACTERS_DESCRIPTION = 4;

- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"textViewDidEndEditing...");
    [self validateDescription];
    // Reset to placeholder text if the user has finished
    // editing and no message has been entered.
    //    if ([self.descriptionTextView.text isEqualToString:@""]) {
    //        [self resetDescription];
    //    }
}

-(void)textViewDidChange:(UITextView *)textView {
    //    NSLog(@"TEXT CHANGED %@", textView.text);
    [self validateDescription];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string {
    //    NSLog(@"shouldChangeCharactersInRange");
    NSUInteger newLength = [textView.text length] + [string length] - range.length;
    return (newLength > MAX_CHARACTERS_DESCRIPTION) ? NO : YES;
}

-(void)validateDescription {
    NSLog(@"validateDescription");
    NSString *trimmed = [self.descriptionTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSUInteger characterCount = [trimmed length];
    BOOL valid = true;
    if([trimmed isEqualToString:@""]){
        NSLog(@"INVALID");
        valid = false;
    } else if (characterCount < MIN_CHARACTERS_DESCRIPTION) {
        NSLog(@"INVALID");
        valid = false;
    } else {
        NSLog(@"VALID!");
        valid = true;
    }
    
    if (valid == false) {
        self.nextButton.enabled = NO;
    } else {
        self.nextButton.enabled = YES;
    }
    
}

//- (IBAction)nextAction:(id)sender {
//    NSLog(@"next to?");
//    [self performSegueWithIdentifier:@"next" sender:self];
//}

-(void)saveDescription:(NSString *)description {
    NSUserDefaults *userPreferences = [NSUserDefaults standardUserDefaults];
    [userPreferences setObject:self.descriptionTextView.text forKey:@"helpUserDescription"];
    [userPreferences synchronize];
}

-(NSString *)loadDescription {
    NSUserDefaults *userPreferences = [NSUserDefaults standardUserDefaults];
    return [userPreferences stringForKey:@"helpUserDescription"];
}

- (IBAction)sendAction:(id)sender {
    UIAlertController * menu =   [UIAlertController
                                  alertControllerWithTitle:nil
                                  message:@"Invio richiesta?"
                                  preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* sendStepAskPush = [UIAlertAction
                                      actionWithTitle:@"Invia"
                                      style:UIAlertActionStyleDefault
                                      handler:^(UIAlertAction * action)
                                      {
                                          NSLog(@"Sending help request");
//                                          [self sendStepAskPush];
                                          [self send];
                                      }];
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:[HelpLocal translate:@"Help wizard not now button"]
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action)
                             {
                                 NSLog(@"action canceled");
                             }];
    [menu addAction:sendStepAskPush];
    [menu addAction:cancel];
    // for ipad
    menu.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;
    
    [self presentViewController:menu animated:YES completion:nil];
}

-(void)send {
//    NSLog(@"sending: %@", self.context);
    
    [self.helpAction dismissWizardAndOpenMessageViewWithSupport];
//    [self dismissViewControllerAnimated:YES completion:^{
//        NSLog(@"Wizard dismissed");
//        // finestra conversazione si apre come pop-up dopo chiusura help-wizard
//        // inviare metadati impostati in fase di apertura chat (inserire in context? studio)
//        // TODO: get attributes from context
//        // TODO: remove System's messages
//
//            ChatUser *recipient = [[ChatUser alloc] init:support_group_id fullname:@"Support"];
//            [[ChatUIManager getInstance] openConversationMessagesViewAsModalWith:(ChatUser *)recipient  viewController:self attributes:nil withCompletionBlock:^{
//                NSLog(@"Messages view dismissed.");
//            }];
//    }];
    
    
    
//    self.descriptionTextView.delegate = nil;
//    [self.context setObject:self forKey:@"source-view-controller"];
//    id vc = [self.context objectForKey:@"view-controller"];
//    NSLog(@"vc: %@", vc);
//    if ([vc respondsToSelector:@selector(helpWizardEnd:)]) {
//        NSLog(@"performing selector...");
//        [vc performSelector:@selector(helpWizardEnd:) withObject:self.context];
//    }
}

-(void)dealloc {
    NSLog(@"Deallocating HelpDescriptionTVC");
}

@end
