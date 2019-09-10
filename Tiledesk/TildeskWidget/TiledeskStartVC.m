//
//  TiledeskStartVC.m
//  chat21
//
//  Created by Andrea Sponziello on 05/06/2018.
//  Copyright © 2018 Frontiere21. All rights reserved.
//

#import "TiledeskStartVC.h"
#import "TiledeskDataService.h"
#import "TiledeskDepartment.h"
#import "TiledeskCategoryStepTVC.h"
#import "TiledeskDescriptionStepTVC.h"
#import "TiledeskLocal.h"
#import "TiledeskAction.h"

@interface TiledeskStartVC ()

@end

@implementation TiledeskStartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.context = [[NSMutableDictionary alloc] init];
    
    self.cancelButton.title = [TiledeskLocal translate:@"cancel"];
//    [self.context setObject:@"test value" forKey:@"test key"];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.activityIndicator startAnimating];
    TiledeskDataService *service =[[TiledeskDataService alloc] init];
    [service downloadWidgetDataWithCompletionHandler:^(NSData *data, NSError *error) {
        // TODO
        NSArray<TiledeskDepartment *> *departments = [TiledeskDataService JSON2Departments: data];
        if (departments) {
            NSLog(@"count deps: %lu", (unsigned long)departments.count);
            for (TiledeskDepartment *dep in departments) {
                NSLog(@"dep id: %@, name: %@ isDefault: %d", dep.departmentId, dep.name, dep.isDefault);
            }
            if (departments.count == 1) {
                // set context.department = default
                self.helpAction.department = departments[0];
                // perform message-segue
                [self performSegueWithIdentifier:@"message-segue" sender:self];
            }
            else if (departments.count > 1) {
                NSMutableArray<TiledeskDepartment *> *mutableDeps = [departments mutableCopy];
                for (int i = 0; i < mutableDeps.count; i++) {
                    TiledeskDepartment *dep = mutableDeps[i];
                    if (dep.isDefault) {
                        [mutableDeps removeObjectAtIndex:i];
                    }
                }
                self.departments = mutableDeps;
                [self performSegueWithIdentifier:@"departments-segue" sender:self];
            }
            else {
                // error, deps.couont can't be 0
            }
        }
        else {
            NSLog(@"departmennts error.");
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"departments-segue"]) {
        NSObject *vc = [segue destinationViewController];
        [vc setValue:self.helpAction forKey:@"helpAction"];
        [vc setValue:self.departments forKey:@"departments"];
    }
    else if ([segue.identifier isEqualToString:@"message-segue"]) {
        NSObject *vc = [segue destinationViewController];
        [vc setValue:self.helpAction forKey:@"helpAction"];
    }
}

- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
