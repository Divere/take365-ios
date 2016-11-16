//
//  ErrorResponse.h
//  take365
//
//  Created by Evgeniy Eliseev on 17/11/2016.
//  Copyright © 2016 take365. All rights reserved.
//

#import "Model.h"

@interface ErrorResponse : Model

@property (nonatomic) NSArray<NSString*> *errors;

@end
