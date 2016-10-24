//
//  LoginResult.h
//  take365
//
//  Created by Evgeniy Eliseev on 01.12.15.
//  Copyright © 2015 take365. All rights reserved.
//

#import "JSONModel.h"

@interface LoginResult : JSONModel

@property (nonatomic) int id;
@property (nonatomic) NSString<Optional> *token;
@property (nonatomic) NSNumber<Optional> *tokenExpires;
@property (nonatomic) NSString *username;

@end
