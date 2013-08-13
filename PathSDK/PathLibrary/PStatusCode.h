//
//  PStatusCode.h
//  PathSDK
//
//  Created by jeremy Templier on 12/08/2013.
//  Copyright (c) 2013 jeremy Templier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PStatusCode : NSObject

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, readonly) NSString *message;

+ (PStatusCode *)instanceWithCode:(NSInteger)code;
@end
