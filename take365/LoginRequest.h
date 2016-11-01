//
//  LoginRequest.h
//  take365
//
//  Created by Evgeniy Eliseev on 01.12.15.
//  Copyright © 2015 take365. All rights reserved.
//

#import "Model.h"

@interface LoginRequest : Model

@property (nonatomic) NSString *username;
@property (nonatomic) NSString *password;

@end
