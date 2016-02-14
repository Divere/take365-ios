//
//  RegisterRequest.h
//  take365
//
//  Created by Evgeniy Eliseev on 11.02.16.
//  Copyright © 2016 take365. All rights reserved.
//

#import "JSONModel.h"

@interface RegisterRequest : JSONModel

@property (nonatomic) NSString *username;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *password;

@end
