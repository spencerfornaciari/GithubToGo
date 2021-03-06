//
//  SFUserCollectionController.m
//  GithubToGo
//
//  Created by Spencer Fornaciari on 1/28/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import "SFUserCollectionController.h"
#import "SFDetailViewController.h"
#import "SFUserCollectionCell.h"
#import "SFNetworkController.h"
#import "GitUser.h"

@interface SFUserCollectionController ()

@property (nonatomic) NSMutableArray *gitUsers;
@property (nonatomic) NSMutableArray *searchResults;
@property (nonatomic) NSOperationQueue *downloadQueue;
@property (nonatomic) SFDetailViewController *detailViewController;

@property (weak, nonatomic) IBOutlet UISearchBar *githubUserSearchBar;


@end

@implementation SFUserCollectionController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.userCollectionView.delegate = self;
    self.userCollectionView.dataSource = self;
    self.githubUserSearchBar.delegate = self;
    
    self.detailViewController = (SFDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    _downloadQueue = [NSOperationQueue new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(downloadFinished:)
                                                 name:@"DownloadedImage"
                                               object:nil];
    
	// Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.gitUsers.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SFUserCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
        
    GitUser *user = self.gitUsers[indexPath.row];
    
    cell.userName.text = [self.gitUsers[indexPath.row] name];
    
    if (user.photo) {
        cell.userProfileImage.image = user.photo;
    } else {
        if (!user.isDownloading) {
            [user downloadAvatar:^(UIImage *pic) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    cell.userProfileImage.image = pic;
                }];
            }];
            user.isDownloading = YES;
        }
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
   
    return [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"searchHeader" forIndexPath:indexPath];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.githubUserSearchBar;
}

#pragma mark - UICollectionView Search Functionality

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    searchBar.keyboardType = UIKeyboardTypeWebSearch;
    self.gitUsers = [NSMutableArray new];
    
    [searchBar resignFirstResponder];
    [self githubSearch:searchBar.text];
}

- (void)githubSearch:(NSString *)string
{
    string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    
    @try {
        self.searchResults = (NSMutableArray *)[[SFNetworkController sharedController] usersForSearchString:string];
    }
    @catch (NSException *exception) {
        NSLog(@"API Limit Reached? %@", exception.debugDescription);
        if (error) {
            NSLog(@"Error: %@", error.debugDescription);
        }
    }
    
    if (self.searchResults == nil) {
        
    } else {
        [self createGitUsersArray];
    }
    
}

#pragma mark - Git User Model Methods

//Create Git Users Array
- (void)createGitUsersArray
{
    for (NSDictionary *dictionary in self.searchResults) {
        GitUser *user = [GitUser new];
        user.name = dictionary[@"login"];
        user.html_url = dictionary[@"html_url"];
        user.photoLocation = dictionary[@"avatar_url"];
        user.downloadQueue = self.downloadQueue;
        [self.gitUsers addObject:user];
    }
        [self.userCollectionView reloadData];
}

#pragma mark - NSNotificationCenter Methods

- (void)downloadFinished:(NSNotification *)note
{
    id sender = [[note userInfo] objectForKey:@"user"];
    
    if ([sender isKindOfClass:[GitUser class]]) {
        NSIndexPath *userPath = [NSIndexPath indexPathForItem:[_gitUsers indexOfObject:sender] inSection:0];
        [self.userCollectionView reloadItemsAtIndexPaths:@[userPath]];
    } else {
        NSLog(@"Sender was not a GitUser");
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.userCollectionView indexPathForCell:(SFUserCollectionCell *)sender];
        NSDictionary *repoDict = _searchResults[indexPath.row];
       [[segue destinationViewController] setDetailItem:repoDict];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSDictionary *userDict = _searchResults[indexPath.row];
        self.detailViewController.detailItem = userDict;
    }
}

@end