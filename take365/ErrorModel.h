//
//  ErrorModel.h
//  take365
//
//  Created by Evgeniy Eliseev on 17/11/2016.
//  Copyright © 2016 take365. All rights reserved.
//

#import "Model.h"

@interface ErrorModel : Model

@property (nonatomic) NSString *field;
@property (nonatomic) NSString *value;
@property (nonatomic) NSString *code;

@end
