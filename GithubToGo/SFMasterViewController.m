//
//  SFMasterViewController.m
//  GithubToGo
//
//  Created by Spencer Fornaciari on 1/27/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import "SFMasterViewController.h"
#import "SFReposTableViewController.h"
#import "SFUserCollectionController.h"
#import "SFDetailViewController.h"
#import "SFNetworkController.h"

@interface SFMasterViewController () {
    NSMutableArray *_objects;
}

@property (nonatomic) NSMutableArray *searchResults;
@property (nonatomic) SFReposTableViewController *repoViewController;
@property (nonatomic) SFUserCollectionController *userViewController;
@property (nonatomic) UIViewController *topViewController;
@property (nonatomic) BOOL isOpen;


@property (strong, nonatomic) IBOutlet UISearchBar *githubSearchBar;

@end

@implementation SFMasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //self.isOpen = NO;
    
    //Repo Search controller declaration
    self.repoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"githubReposWebViewController"];
    [self addChildViewController:self.repoViewController];
    self.repoViewController.view.frame = self.view.frame;
    [self.view addSubview:self.repoViewController.view];
    [self.repoViewController didMoveToParentViewController:self];
    self.topViewController = self.repoViewController;

    
    self.githubSearchBar.delegate = self;

    self.detailViewController = (SFDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    self.searchResults = (NSMutableArray *)[[SFNetworkController sharedController] reposForSearchString:@"iOS"];
    
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
    [self.repoViewController.view setUserInteractionEnabled:NO];
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



#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
//
//    //NSDate *object = _objects[indexPath.row];
//    cell.textLabel.text = [self.searchResults[indexPath.row] objectForKey:@"name"];
//    return cell;
//}


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


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
//        NSDictionary *repoDict = _searchResults[indexPath.row];
//        self.detailViewController.detailItem = repoDict;
//    }
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *repoDict = _searchResults[indexPath.row];
        [[segue destinationViewController] setDetailItem:repoDict];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    searchBar.keyboardType = UIKeyboardTypeWebSearch;
    
    [searchBar resignFirstResponder];
    [self githubSearch:searchBar.text];
}

- (void)githubSearch:(NSString *)string
{
    NSLog(@"%@", string);
    self.searchResults = (NSMutableArray *)[[SFNetworkController sharedController] reposForSearchString:string];
    if (self.searchResults == nil) {
        
    } else {
        [self.tableView reloadData];
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        NSLog(@"Repos");
    }
    if (indexPath.row == 1) {
        NSLog(@"Users");
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
