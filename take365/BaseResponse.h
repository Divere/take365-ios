//
//  BaseResponse.h
//  take365
//
//  Created by Evgeniy Eliseev on 27/06/16.
//  Copyright © 2016 take365. All rights reserved.
//

#import "JSONModel.h"

@interface BaseResponse : JSONModel

@property (nonatomic) NSMutableArray<Optional> *errors;

@end
