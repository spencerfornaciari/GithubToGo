//
//  SFIphoneTableViewController.m
//  GithubToGo
//
//  Created by Spencer Fornaciari on 1/27/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import "SFIphoneTableViewController.h"
#import "SFDetailViewController.h"
#import "SFNetworkController.h"

@interface SFIphoneTableViewController ()

@property (nonatomic) NSMutableArray *searchResults;
@property (nonatomic) SFDetailViewController *detailViewController;

@end

@implementation SFIphoneTableViewController

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
    
    self.searchResults = [[SFNetworkController sharedController] reposForSearchString:@"iOS"];

    self.detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"githubWebViewController"];
    
    [self addChildViewController:self.detailViewController];
    self.detailViewController.view.frame = CGRectMake(self.view.frame.size.width * .8, self.detailViewController.view.frame.origin.y, self.detailViewController.view.frame.size.width, self.detailViewController.view.frame.size.height);
 //= self.view.frame;
    [self.view addSubview:self.detailViewController.view];
    [self.detailViewController didMoveToParentViewController:self];
    
    [self setupPanGesture];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupPanGesture
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slidePanel:)];
    
    pan.minimumNumberOfTouches = 1;
    pan.maximumNumberOfTouches = 1;
    
    pan.delegate = self;
    
    [self.detailViewController.view addGestureRecognizer:pan];
    
}


-(void)slidePanel:(id)sender
{
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)sender;
    
    CGPoint translation = [pan translationInView:self.view];
    
    if (pan.state == UIGestureRecognizerStateChanged)
    {
        if (self.detailViewController.view.frame.origin.x+ translation.x > 0) {
            
            self.detailViewController.view.center = CGPointMake(self.detailViewController.view.center.x +translation.x, self.detailViewController.view.center.y);
        
            
            [(UIPanGestureRecognizer *)sender setTranslation:CGPointMake(0,0) inView:self.view];
        }
        
    }
    
    if (pan.state == UIGestureRecognizerStateEnded)
    {
        if (self.detailViewController.view.frame.origin.x > self.view.frame.size.width / 2)
        {
            [self openMenu];
            
            
        }
        if (self.detailViewController.view.frame.origin.x < self.view.frame.size.width / 2 )
        {
            [UIView animateWithDuration:.4 animations:^{
                self.detailViewController.view.frame = self.view.frame;
            } completion:^(BOOL finished) {
                [self closeMenu];
            }];
        }
    }
    
}

- (void)openMenu
{
    NSLog(@" open menu");
    
    [UIView animateWithDuration:1 animations:^{
        
        self.detailViewController.view.frame = CGRectMake(self.view.frame.size.width * .8, self.detailViewController.view.frame.origin.y, self.detailViewController.view.frame.size.width, self.detailViewController.view.frame.size.height);
    } completion:^(BOOL finished) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(slideBack:)];
        [self.detailViewController.view addGestureRecognizer:tap];
    }];
}


- (void)closeMenu
{
    [UIView animateWithDuration:0.2 animations:
     ^{
        self.detailViewController.view.frame = CGRectMake(self.detailViewController.view.frame.origin.x + 20.f, self.detailViewController.view.frame.origin.y, self.detailViewController.view.frame.size.width, self.detailViewController.view.frame.size.height);
    } completion:^(BOOL finished) {
            self.detailViewController.view.frame = self.view.frame;
        }];
}

-(void)slideBack:(id)sender
{
    [UIView animateWithDuration:.4 animations:^{
        self.detailViewController.view.frame = self.view.frame;
    } completion:^(BOOL finished) {
        [self.detailViewController.view removeGestureRecognizer:(UITapGestureRecognizer *)sender];
        [self closeMenu];
    }];
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
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [self.searchResults[indexPath.row] objectForKey:@"name"];

    return cell;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *repoDict = _searchResults[indexPath.row];
    self.detailViewController.detailItem = repoDict;
    [self closeMenu];
}

@end
