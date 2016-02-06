//
//  LoginResponse.h
//  take365
//
//  Created by Evgeniy Eliseev on 01.12.15.
//  Copyright © 2015 take365. All rights reserved.
//

#import "JSONModel.h"
#import "LoginResult.h"
#import "LoginErrors.h"

@interface LoginResponse : JSONModel

@property (nonatomic) LoginResult<Optional> *result;
@property (nonatomic) NSMutableArray<Optional> *errors;

@end
