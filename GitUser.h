//
//  GitUser.h
//  GithubToGo
//
//  Created by Spencer Fornaciari on 1/28/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GitUser : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *photoLocation;
@property (nonatomic) UIImage *photo;
@property (nonatomic) BOOL isDownloading;

@property (nonatomic, weak) NSOperationQueue *downloadQueue;

-(void)downloadAvatar;

@end