//
//  Logger.m
//  EchoTest
//
//  Created by Ernest Cho on 6/4/19.
//  Copyright © 2019 Branch Metrics, Inc. All rights reserved.
//

#import "Logger.h"

@interface Logger()
// buffers messages until log handler is ready
@property (nonatomic, strong, readwrite) NSMutableArray<NSString *> *messageBuffer;

// override where log messages are sent
@property (copy, nonatomic, nullable) void(^logBlock)(NSString *);

@end

@implementation Logger

+ (instancetype)shared {
    static Logger *logger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        logger = [[Logger alloc] init];
    });
    return logger;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.messageBuffer = [NSMutableArray<NSString *> new];
    }
    return self;
}

- (void)log:(NSString *)message {
    if (message) {
        [self.messageBuffer addObject:message];
    }
    
    if (self.logBlock) {
        self.logBlock(message);
    }
}

- (void)registerLogBlock:(void (^)(NSString *))logBlock {
    if (logBlock) {
        self.logBlock = logBlock;
        for (NSString *message in self.messageBuffer) {
            self.logBlock(message);
        }
        
        // stop buffering once a handler is set
        self.messageBuffer = nil;
    }
}

@end
