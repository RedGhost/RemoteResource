//
//  RRDataConverter.h
//  RemoteResource
//
//  Created by Mateusz Stankiewicz on 3/20/13.
//  Copyright (c) 2013 Mateusz Stankiewicz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRDataConverter : NSObject

- (NSString*) contentType;
- (NSObject*) objectFromData:(NSData*)data withError:(NSError**)error;
- (NSData*) dataFromObject:(NSObject*)object withError:(NSError**)error;

@end
