//
//  BaseAuthiticatedRequest.h
//  take365
//
//  Created by Evgeniy Eliseev on 01.12.15.
//  Copyright © 2015 take365. All rights reserved.
//

#import "JSONModel.h"

@interface BaseAuthiticatedRequest : JSONModel

@property (nonatomic) NSString *accessToken;

@end
