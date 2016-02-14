//
//  AuthorModel.h
//  take365
//
//  Created by Evgeniy Eliseev on 01.12.15.
//  Copyright © 2015 take365. All rights reserved.
//

#import "JSONModel.h"

@interface AuthorModel : JSONModel

@property (nonatomic) NSString *url;
@property (nonatomic) NSString *username;

@end