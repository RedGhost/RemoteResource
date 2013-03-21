//
//  RRJSONDataConverter.m
//  RemoteResource
//
//  Created by Mateusz Stankiewicz on 3/20/13.
//  Copyright (c) 2013 Mateusz Stankiewicz. All rights reserved.
//

#import "RRJSONDataConverter.h"

@implementation RRJSONDataConverter

- (NSString*) contentType {
    return @"application/json";
}

- (NSObject*) objectFromData:(NSData*)data withError:(NSError**)error {
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
}

- (NSData*) dataFromObject:(NSObject*)object withError:(NSError**)error {
    return [NSJSONSerialization dataWithJSONObject:object options:0 error:error];
}

@end
