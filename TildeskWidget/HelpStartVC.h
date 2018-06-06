//
//  HelpStartVC.h
//  chat21
//
//  Created by Andrea Sponziello on 05/06/2018.
//  Copyright © 2018 Frontiere21. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HelpDepartment;

@interface HelpStartVC : UIViewController

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;

@property (strong, nonatomic) NSMutableDictionary *context;
@property (strong, nonatomic) NSArray<HelpDepartment *> *departments;

@end
