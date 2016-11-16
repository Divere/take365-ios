//
//  BaseResponse.h
//  take365
//
//  Created by Evgeniy Eliseev on 27/06/16.
//  Copyright © 2016 take365. All rights reserved.
//

#import "Model.h"
#import "ErrorModel.h"

@protocol ErrorModel
@end

@interface BaseResponse : Model

@property (nonatomic) NSArray<ErrorModel> *errors;

@end
