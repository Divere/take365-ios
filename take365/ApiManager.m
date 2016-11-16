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

const NSString *URL = @"https://take365.org";

@implementation ApiManager

-(void)registerWithUsername:(NSString *)username Email:(NSString *)email Password:(NSString *)password AndResultBlock:(void (^)(RegisterResult *, NSString *))resultBlock{
    RegisterRequest *r = [RegisterRequest new];
    r.username = username;
    r.email = email;
    r.password = password;
    
    [JSONHTTPClient postJSONFromURLWithString:METHOD(@"api/user/register") bodyString:[r toJSONString] completion:^(id json, JSONModelError *err) {
        
        if(![self handleBaseResponse:json]){
            return;
        }
        
        RegisterResponse *response = [[RegisterResponse alloc] initWithDictionary:json error:&err];
        
        if(response.result != NULL && resultBlock != NULL){
            resultBlock(response.result, NULL);
        }
    }];
}

- (void)handleAuthResponse:(id)json err_p:(JSONModelError **)err_p resultBlock:(void (^)(LoginResult *, NSString *))resultBlock {
  if(![self handleBaseResponse:json]){
            return;
        }
        
        LoginResponse *response = [[LoginResponse alloc] initWithDictionary:json error:&(*err_p)];
        
        if(response.result != NULL){
            if(response.result.token != NULL){
                _AccessToken = response.result.token;
            }
            _CurrentUser = response.result;
            if(resultBlock != NULL){
                resultBlock(response.result, NULL);
            }
        }else if(response.errors != NULL){
            resultBlock(NULL, [response.errors objectAtIndex:0][@"value"]);
        }
}

-(void)loginWithUsername:(NSString *)username AndPassword:(NSString *)password AndResultBlock:(void (^)(LoginResult* result, NSString *error))resultBlock{
    LoginRequest *request = [LoginRequest new];
    request.username = username;
    request.password = password;
    
    [JSONHTTPClient postJSONFromURLWithString:METHOD(@"api/auth/login") bodyString:[request toJSONString] completion:^(id json, JSONModelError *err) {
        
        [self handleAuthResponse:json err_p:&err resultBlock:resultBlock];
    }];
}

-(void)loginWithAccessTokenAndResultBlock:(void (^)(LoginResult *result, NSString *error))resultBlock {
    [JSONHTTPClient getJSONFromURLWithString:METHOD([NSString stringWithFormat:@"api/auth/reuse-token?accessToken=%@", _AccessToken]) completion:^(id json, JSONModelError *err) {
        
        [self handleAuthResponse:json err_p:&err resultBlock:resultBlock];
    }];
}

-(void)getStoryWithId:(int)storyId WithResultBlock:(void (^)(StoryResult *result, NSString *error))resultBlock{
    [JSONHTTPClient getJSONFromURLWithString:METHOD([NSString stringWithFormat:@"api/story/%d?accessToken=%@", storyId, _AccessToken]) completion:^(id json, JSONModelError *err) {
        
        if(![self handleBaseResponse:json]){
            return;
        }
        
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
        
        if(![self handleBaseResponse:json]){
            return;
        }
        
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

-(void)createStoryWithTitle:(NSString*)title PrivateLevel:(StoryPrivateLevel)privateLevel Description:(NSString*)description AndResultBlock:(void (^)(StoryResult *story, NSString *error))resultBlock{
    
    WriteStoryRequest *r = [WriteStoryRequest new];
    r.title = title;
    r.status = privateLevel;
    r.descr = description;
    r.accessToken = _AccessToken;
    
    [JSONHTTPClient postJSONFromURLWithString:METHOD(@"api/story/write") bodyString:[r toJSONString] completion:^(id json, JSONModelError *err)
     {
         if(![self handleBaseResponse:json]){
             return;
         }
         
         NSError *error;
         StoryResponse *response = [[StoryResponse alloc] initWithDictionary:json error:&error];
         
         if(error){
             NSLog(@"%@", error);
         }
         
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

-(void)uploadImage:(NSData *)image ForStory:(int)storyId ForDate:(NSString *)date WithProgressBlock:(void (^)(float))progressBlock WithResultBlock:(void (^)(UploadImageResult *))resultBlock{
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
                          NSLog(@"%@", responseObject);
                          if(resultBlock){
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  resultBlock(false);
                              });
                          }
                      } else {
                          NSLog(@"%@ %@", response, responseObject);
                          
                          NSError *err;
                          UploadImageResponse *response = [[UploadImageResponse alloc] initWithDictionary:responseObject error:&err];
                          
                          if(resultBlock){
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  resultBlock(response.result);
                              });
                          }
                      }
                  }];
    
    [uploadTask resume];
}

-(BOOL)handleBaseResponse:(id)json{
    NSError *deserializeError;
    
    BaseResponse *baseResponse = [[BaseResponse alloc] initWithDictionary:json error:&deserializeError];

    if(baseResponse.errors != NULL && [baseResponse.errors count] > 0){
        if(((ErrorModel*)[baseResponse.errors objectAtIndex:0]).code != NULL){
            NSString *error = ((ErrorModel*)[baseResponse.errors objectAtIndex:0]).code;
            if([error isEqualToString:@"AUTH_BAD_TOKEN"]){
                if(_EventInvalidAuthToken){
                    _EventInvalidAuthToken();
                }
                return false;
            }
        }
        
        if(_EventApiErrorOccured){
            ErrorModel *err = [baseResponse.errors objectAtIndex:0];
            _EventApiErrorOccured(err.value);
        }
        
        return false;
    }
    
    return true;
}

NSString* METHOD(NSString* method)
{
    NSString *uri = [NSString stringWithFormat:@"%@/%@", URL, method];
    NSLog(@"Method URI: %@", uri);
    return uri;
}

@end
