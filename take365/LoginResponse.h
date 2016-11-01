//
//  LoginResponse.h
//  take365
//
//  Created by Evgeniy Eliseev on 01.12.15.
//  Copyright © 2015 take365. All rights reserved.
//

#import "Model.h"
#import "LoginResult.h"
#import "LoginErrors.h"

@interface LoginResponse : Model

@property (nonatomic) LoginResult *result;
@property (nonatomic) NSMutableArray *errors;

@end
