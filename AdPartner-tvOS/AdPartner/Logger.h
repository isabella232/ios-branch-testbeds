//
//  Logger.h
//  EchoTest
//
//  Created by Ernest Cho on 6/4/19.
//  Copyright © 2019 Branch Metrics, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Logger : NSObject

// singleton logger
+ (instancetype)shared;

// log message to the block, with a nil check
- (void)log:(NSString *)message;

// override where log messages are sent
// default is buffered in memory and sent to NSLog
- (void)registerLogBlock:(void (^)(NSString *))logBlock;

@end

NS_ASSUME_NONNULL_END
