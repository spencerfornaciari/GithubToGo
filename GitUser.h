//
//  GitUser.h
//  GithubToGo
//
//  Created by Spencer Fornaciari on 1/28/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GitUser : NSObject

@property (nonatomic) NSString *username;
@property (nonatomic) NSString *userPhotoLocation;
@property (nonatomic) UIImage *userPhoto;

@end