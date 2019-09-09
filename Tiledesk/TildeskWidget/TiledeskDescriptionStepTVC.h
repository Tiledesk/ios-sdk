//
//  TiledeskDescriptionStepTVC.h
//  bppmobile
//
//  Created by Andrea Sponziello on 05/10/2017.
//  Copyright © 2017 Frontiere21. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TiledeskAction;

@interface TiledeskDescriptionStepTVC : UITableViewController<UITextViewDelegate> {
    NSString *kPlaceholderDescription;
}

@property (strong, nonatomic) TiledeskAction *helpAction;
//@property (strong, nonatomic) NSMutableDictionary *context;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;

@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
//- (IBAction)nextAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@end
