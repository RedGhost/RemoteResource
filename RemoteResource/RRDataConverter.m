//
//  RRDataCoder.m
//  RemoteResource
//
//  Created by Mateusz Stankiewicz on 3/20/13.
//  Copyright (c) 2013 Mateusz Stankiewicz. All rights reserved.
//

#import "RRDataConverter.h"

@implementation RRDataConverter

- (NSString*) contentType {
    NSString * reason = [NSString stringWithFormat:@"%@::contentType not implemented.", [self class]];
    @throw [NSException exceptionWithName:@"NotImplementedException" reason:reason userInfo:nil];
}

- (NSObject*) objectFromData:(NSData*)data {
    NSString * reason = [NSString stringWithFormat:@"%@::objectFromData: not implemented.", [self class]];
    @throw [NSException exceptionWithName:@"NotImplementedException" reason:reason userInfo:nil];
}

- (NSData*) dataFromObject:(NSObject*)object {
    NSString * reason = [NSString stringWithFormat:@"%@::dataFromObject: not implemented.", [self class]];
    @throw [NSException exceptionWithName:@"NotImplementedException" reason:reason userInfo:nil];
}

@end
