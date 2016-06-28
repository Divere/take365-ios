//
//  ApiManager.h
//  take365
//
//  Created by Evgeniy Eliseev on 01.12.15.
//  Copyright © 2015 take365. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseResponse.h"
#import "RegisterRequest.h"
#import "RegisterResponse.h"
#import "UploadImageResponse.h"
#import "LoginResponse.h"
#import "LoginRequest.h"
#import "StoryListResponse.h"
#import "StoryResponse.h"
#import "WriteStoryRequest.h"

typedef enum : NSUInteger {
    StoryPrivateLevelPrivate = 0,
    StoryPrivateLevelPublic = 1
} StoryPrivateLevel;

@interface ApiManager : NSObject

@property (nonatomic) NSString *AccessToken;

@property (nonatomic) NSArray<StoryModel> *Stories;

@property (strong, nonatomic) void (^EventInvalidAuthToken)();

-(void)registerWithUsername:(NSString *)username Email:(NSString *)email Password:(NSString *)password AndResultBlock:(void (^)(RegisterResult *result, NSString *error))resultBlock;
-(void)loginWithUsername:(NSString *)username AndPassword:(NSString *)password AndResultBlock:(void (^)(LoginResult *result, NSString *error))resultBlock;
-(void)getStoryWithId:(int)storyId WithResultBlock:(void (^)(StoryResult *result, NSString *error))resultBlock;
-(void)getStoryListWithResultBlock:(void (^)(NSArray<StoryModel> *result, NSString *error))resultBlock;
-(void)createStoryWithTitle:(NSString*)title PrivateLevel:(StoryPrivateLevel)privateLevel Description:(NSString*)description AndResultBlock:(void (^)(StoryModel *story, NSString *error))resultBlock;
-(void)uploadImage:(NSData*)image ForStory:(int)storyId ForDate:(NSString*)date WithProgressBlock:(void (^)(float progress))progressBlock WithResultBlock:(void (^)(UploadImageResult *result))resultBlock;

@end
