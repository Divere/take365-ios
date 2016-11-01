//
//  UploadImageResponse.h
//  take365
//
//  Created by Evgeniy Eliseev on 12.02.16.
//  Copyright © 2016 take365. All rights reserved.
//

#import "Model.h"
#import "UploadImageResult.h"

@interface UploadImageResponse : Model

@property (nonatomic) UploadImageResult *result;
@property (nonatomic) NSMutableArray *errors;

@end
