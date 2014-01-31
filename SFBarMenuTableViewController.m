//
//  SFBarMenuTableViewController.m
//  GithubToGo
//
//  Created by Spencer Fornaciari on 1/28/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import "SFBarMenuTableViewController.h"
#import "SFReposTableViewController.h"
#import "SFUserCollectionController.h"

@interface SFBarMenuTableViewController ()

@property (nonatomic) SFReposTableViewController *repoViewController;
@property (nonatomic) SFUserCollectionController *userViewController;
@property (nonatomic) UIViewController *topViewController;

@property (nonatomic) BOOL isOpen;

- (IBAction)sideBarButton:(id)sender;

@end

@implementation SFBarMenuTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isOpen = NO;
        
    //Repo Search controller declaration
    self.repoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"githubReposWebViewController"];
    [self addChildViewController:self.repoViewController];
    self.repoViewController.view.frame = self.view.frame;
    [self.view addSubview:self.repoViewController.view];
    [self.repoViewController didMoveToParentViewController:self];
    
    self.topViewController = self.repoViewController;
    [self setupPanGesture];
    
    //User Search controller declaration
    self.userViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"githubUserCollectionView"];
    [self addChildViewController:self.userViewController];
    self.userViewController.view.frame = self.view.frame;
    [self.userViewController didMoveToParentViewController:self];

    //self.userViewController.view.frame = self.
    
   
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)setupPanGesture
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slidePanel:)];
    
    pan.minimumNumberOfTouches = 1;
    pan.maximumNumberOfTouches = 1;
    
    pan.delegate = self;
    
    [self.topViewController.view addGestureRecognizer:pan];
    //[self.repoViewController.view addGestureRecognizer:pan];
    //[self.userViewController.view addGestureRecognizer:pan];
    
}

-(void)slidePanel:(id)sender
{
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)sender;
    
    CGPoint translation = [pan translationInView:self.view];
    
    if (pan.state == UIGestureRecognizerStateChanged)
    {
        if (self.topViewController.view.frame.origin.x+ translation.x > 0) {
            
            self.topViewController.view.center = CGPointMake(self.topViewController.view.center.x +translation.x, self.topViewController.view.center.y);
            
            [(UIPanGestureRecognizer *)sender setTranslation:CGPointMake(0,0) inView:self.view];
        }
        
    }
    
    if (pan.state == UIGestureRecognizerStateEnded)
    {
        if (self.topViewController.view.frame.origin.x > self.view.frame.size.width / 2)
        {
            [self openMenu];
        }
        if (self.topViewController.view.frame.origin.x < self.view.frame.size.width / 2 )
        {
            [self closeMenu];
        }
    }
    
}

- (void)openMenu
{
    [self.topViewController.view setUserInteractionEnabled:NO];
    [UIView animateWithDuration:.4 animations:^{
        self.topViewController.view.frame = CGRectMake(self.view.frame.size.width * .5, self.topViewController.view.frame.origin.y, self.topViewController.view.frame.size.width, self.topViewController.view.frame.size.height);
    } completion:^(BOOL finished) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(slideBack:)];
        [self.topViewController.view addGestureRecognizer:tap];
    }];
}

- (void)closeMenu
{
    [self.topViewController.view setUserInteractionEnabled:YES];
    [UIView animateWithDuration:.4 animations:
     ^{
         //self.repoViewController.view.frame = CGRectMake(self.repoViewController.view.frame.origin.x, self.self.repoViewController.view.frame.origin.y, self.repoViewController.view.frame.size.width, self.repoViewController.view.frame.size.height);
         
         self.topViewController.view.frame = self.view.frame;
     } completion:^(BOOL finished) {
     }];
}

-(void)slideBack:(id)sender
{
    [UIView animateWithDuration:.4 animations:^{
        self.topViewController.view.frame = self.view.frame;
        [self.topViewController.view removeGestureRecognizer:(UITapGestureRecognizer *)sender];
        [self closeMenu];
    } completion:^(BOOL finished) {
        
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    self.userViewController.view.frame = self.topViewController.view.frame;
    [self.userViewController.userCollectionView setNeedsDisplay];

}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        self.repoViewController.view.frame = self.topViewController.view.frame;
        [self.topViewController.view removeFromSuperview];
        self.topViewController = self.repoViewController;
        [self.view addSubview:self.repoViewController.view];
        [self setupPanGesture];
        self.isOpen = NO;
        [self closeMenu];
    }
    if (indexPath.row == 1) {
        self.userViewController.view.frame = self.topViewController.view.frame;
        [self.topViewController.view removeFromSuperview];
        self.topViewController = self.userViewController;
        [self.view addSubview:self.userViewController.view];
        [self setupPanGesture];
        self.isOpen = NO;
        [self closeMenu];
    }
    
    [self.tableView resignFirstResponder];
}
- (IBAction)sideBarButton:(id)sender {
    
    if (!self.isOpen) {
        [self openMenu];
        self.isOpen = YES;
        [self.tableView becomeFirstResponder];
    } else {
        [self closeMenu];
        self.isOpen = NO;
    }
}
@end
