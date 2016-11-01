//
//  RegisterRespinse.h
//  take365
//
//  Created by Evgeniy Eliseev on 12.02.16.
//  Copyright © 2016 take365. All rights reserved.
//

#import "Model.h"
#import "RegisterResult.h"


@interface RegisterResponse : Model

@property (nonatomic) RegisterResult *result;
@property (nonatomic) NSMutableArray *errors;

@end
