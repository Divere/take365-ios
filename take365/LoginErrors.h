//
//  LoginErrors.h
//  take365
//
//  Created by Evgeniy Eliseev on 01.12.15.
//  Copyright © 2015 take365. All rights reserved.
//

#import "JSONModel.h"

@interface LoginErrors : JSONModel

@property (nonatomic) NSString *field;
@property (nonatomic) NSString *value;

@end
