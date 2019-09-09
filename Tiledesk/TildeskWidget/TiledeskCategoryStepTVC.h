//
//  TiledeskCategoryStepTVC.h
//  
//
//  Created by Andrea Sponziello on 05/10/2017.
//
//

#import <UIKit/UIKit.h>

@class TiledeskCategory;
@class TiledeskDepartment;
@class TiledeskAction;

@interface TiledeskCategoryStepTVC : UITableViewController

//@property (strong, nonatomic) NSMutableDictionary *context;
@property (strong, nonatomic) TiledeskAction *helpAction;

@property (strong, nonatomic) NSArray<TiledeskDepartment *> *departments;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

- (IBAction)cancelAction:(id)sender;

@end
