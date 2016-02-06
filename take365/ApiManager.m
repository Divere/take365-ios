//
//  ApiManager.m
//  take365
//
//  Created by Evgeniy Eliseev on 01.12.15.
//  Copyright © 2015 take365. All rights reserved.
//

#import "ApiManager.h"
#import "JSONModelLib.h"
#import "AFNetworking.h"

const NSString *URL = @"http://dev.take365.org";

@implementation ApiManager

-(void)loginWithUsername:(NSString *)username AndPassword:(NSString *)password AndResultBlock:(void (^)(LoginResult* result, NSString *error))resultBlock{
    LoginRequest *request = [LoginRequest new];
    request.username = username;
    request.password = password;
    
    [JSONHTTPClient postJSONFromURLWithString:METHOD(@"api/auth/login") bodyString:[request toJSONString] andHeaders:nil completion:^(id json, JSONModelError *err) {
        
        LoginResponse *response = [[LoginResponse alloc] initWithDictionary:json error:&err];
        
        if(response.result != NULL){
            _AccessToken = response.result.token;
            if(resultBlock != NULL){
                resultBlock(response.result, NULL);
            }
        }else if(response.errors != NULL){
            resultBlock(NULL, [response.errors objectAtIndex:0][@"value"]);
        }
    }];
}

-(void)getStoryWithId:(int)storyId WithResultBlock:(void (^)(StoryResult *result, NSString *error))resultBlock{
    [JSONHTTPClient getJSONFromURLWithString:METHOD([NSString stringWithFormat:@"api/story/%d?accessToken=%@", storyId, _AccessToken]) completion:^(id json, JSONModelError *err) {
        NSError *deserializeError;
        StoryResponse *response = [[StoryResponse alloc] initWithDictionary:json error:&deserializeError];
        
        if(response.errors == NULL){
            if(resultBlock != NULL){
                resultBlock(response.result, NULL);
            }
        }else{
            if(resultBlock != NULL){
                resultBlock(NULL, [response.errors objectAtIndex:0][@"value"]);
            }
        }
    }];
}

-(void)getStoryListWithResultBlock:(void (^)(NSArray<StoryModel> *, NSString *))resultBlock{
    [JSONHTTPClient getJSONFromURLWithString:METHOD([NSString stringWithFormat:@"api/story/list?accessToken=%@&username=me&maxItems=100", _AccessToken]) completion:^(id json, JSONModelError *err) {
        NSError *deserializeError;
        StoryListResponse *response = [[StoryListResponse alloc] initWithDictionary:json error:&deserializeError];
        
        if(response.result != NULL){
            _Stories = response.result;
            if(resultBlock != NULL){
                resultBlock(response.result, NULL);
            }
        }else{
            if(resultBlock){
                resultBlock(NULL, [response.errors objectAtIndex:0][@"value"]);
            }
        }
    }];
}

-(void)createStoryWithTitle:(NSString*)title PrivateLevel:(StoryPrivateLevel)privateLevel Description:(NSString*)description AndResultBlock:(void (^)(StoryModel *story, NSString *error))resultBlock{
    
    WriteStoryRequest *r = [WriteStoryRequest new];
    r.title = title;
    r.status = privateLevel;
    r.descr = description;
    r.accessToken = _AccessToken;
    
    [JSONHTTPClient postJSONFromURLWithString:METHOD(@"api/story/write") bodyString:[r toJSONString] andHeaders:NULL completion:^(id json, JSONModelError *err)
    {
        NSError *error;
        StoryResponse *response = [[StoryResponse alloc] initWithDictionary:json error:&error];
        
        if(response.result != nil){
            if(resultBlock != NULL){
                resultBlock(response.result, NULL);
            }
        }else{
            if(resultBlock){
                resultBlock(NULL, [response.errors objectAtIndex:0][@"value"]);
            }
        }
    }];
}

-(void)uploadImage:(NSData *)image ForStory:(int)storyId ForDate:(NSString *)date WithProgressBlock:(void (^)(float))progressBlock WithResultBlock:(void (^)(BOOL))resultBlock{
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:METHOD(@"api/media/upload") parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFormData:[@"image.jpg" dataUsingEncoding:NSUTF8StringEncoding] name:@"name"];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%d", storyId] dataUsingEncoding:NSUTF8StringEncoding] name:@"targetId"];
        [formData appendPartWithFormData:[@"2" dataUsingEncoding:NSUTF8StringEncoding] name:@"targetType"];
        [formData appendPartWithFormData:[@"storyImage" dataUsingEncoding:NSUTF8StringEncoding] name:@"mediaType"];
        [formData appendPartWithFormData:[date dataUsingEncoding:NSUTF8StringEncoding] name:@"date"];
        [formData appendPartWithFileData:image name:@"file" fileName:@"image.jpg" mimeType:@"image/jpeg"];
        [formData appendPartWithFormData:[_AccessToken dataUsingEncoding:NSUTF8StringEncoding] name:@"accessToken"];
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          if(progressBlock){
                              progressBlock(uploadProgress.fractionCompleted);
                          }
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          NSLog(@"Error: %@", error);
                          if(resultBlock){
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  resultBlock(false);
                              });
                          }
                      } else {
                          NSLog(@"%@ %@", response, responseObject);
                          if(resultBlock){
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  resultBlock(true);
                              });
                          }
                      }
                  }];
    
    [uploadTask resume];
}

NSString* METHOD(NSString* method)
{
    NSString *uri = [NSString stringWithFormat:@"%@/%@", URL, method];
    NSLog(@"Method URI: %@", uri);
    return uri;
}

@end
