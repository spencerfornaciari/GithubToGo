//
//  SFIphoneTableViewController.h
//  GithubToGo
//
//  Created by Spencer Fornaciari on 1/27/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFDetailViewController.h"
#import "SFNetworkController.h"
#import "SFAppDelegate.h"
#import "Repo.h"

@interface SFReposTableViewController : UITableViewController <UIGestureRecognizerDelegate, UISearchBarDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) SFDetailViewController *detailViewController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) SFAppDelegate *appDelegate;
@property (strong, nonatomic) SFNetworkController *networkController;

@end
