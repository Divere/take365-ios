//
//  LoginResult.h
//  take365
//
//  Created by Evgeniy Eliseev on 01.12.15.
//  Copyright © 2015 take365. All rights reserved.
//

#import "Model.h"

@interface LoginResult : Model

@property (nonatomic) int id;
@property (nonatomic) NSString *token;
@property (nonatomic) NSNumber *tokenExpires;
@property (nonatomic) NSString *username;

@end
