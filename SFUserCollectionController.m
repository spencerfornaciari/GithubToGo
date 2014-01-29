//
//  SFUserCollectionController.m
//  GithubToGo
//
//  Created by Spencer Fornaciari on 1/28/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import "SFUserCollectionController.h"
#import "SFUserCollectionCell.h"
#import "SFNetworkController.h"
#import "GitUser.h"

@interface SFUserCollectionController ()

@property (nonatomic) NSMutableArray *gitUsers;
@property (nonatomic) NSMutableArray *searchResults;
@property (nonatomic) NSOperationQueue *downloadQueue;

@property (weak, nonatomic) IBOutlet UISearchBar *userSearchBar;
@property (weak, nonatomic) IBOutlet UICollectionView *userCollectionView;

@end

@implementation SFUserCollectionController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.userSearchBar.delegate = self;
    self.userCollectionView.delegate = self;
    self.userCollectionView.dataSource = self;
    
    _downloadQueue = [NSOperationQueue new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(downloadFinished:)
                                                 name:@"DownloadedImage"
                                               object:nil];
    
    self.searchResults = (NSMutableArray *)[[SFNetworkController sharedController] reposForSearchString:@"Joe"];

    
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
    
    if (user.photo) {
        cell.userProfileImage.image = user.photo;
    } else {
        if (!user.isDownloading) {
            [user downloadAvatar];
            user.isDownloading = YES;
        }
    }
    
    return cell;
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
    NSLog(@"%@", string);
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

@end