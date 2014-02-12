//
//  SFBarMenuTableViewController.h
//  GithubToGo
//
//  Created by Spencer Fornaciari on 1/28/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFDetailViewController.h"

@interface SFMasterViewController : UITableViewController <UIGestureRecognizerDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) SFDetailViewController *detailViewController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *addButton;

@property (nonatomic) BOOL loggedIn;

@end