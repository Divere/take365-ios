//
//  WriteStoryRequest.h
//  take365
//
//  Created by Evgeniy Eliseev on 01.12.15.
//  Copyright © 2015 take365. All rights reserved.
//

#import "BaseAuthiticatedRequest.h"

@interface WriteStoryRequest : BaseAuthiticatedRequest

@property (nonatomic) NSNumber<Optional> *id;
@property (nonatomic) int status;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *descr;


@end
