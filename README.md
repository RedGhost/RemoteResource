RemoteResource
==============

RemoteResource is an iOS library aimed at making restful resources easy to retrieve, modify and save.

NOTE: This Library is very much still a work in progress!!!

The goals of this library is to allow simple definitions of remote resource objects with as little code as possible.
Here is sample code of a resource object:

SampleResource.h:
```objc
#import "RRRemoteResource.h"

@interface SampleResource : RRRemoteResource

@property (strong, nonatomic) NSString * firstName;
@property (strong, nonatomic) NSString * lastName;
@property (strong, nonatomic) NSNumber * age;

+ (NSString*)pathForIdentifier:(id)identifier;

@end
```

SampleResource.m:
```objc
#import "SampleResource.h"

@implementation SampleResource

@dynamic firstName;
@dynamic lastName;
@dynamic age;

+ (NSString*)pathForIdentifier:(id)identifier {
    NSParameterAssert(identifier);
    NSParameterAssert([identifier isKindOfClass:[NSNumber class]]);
    return [NSString stringWithFormat:@"/sample/%d", [(NSNumber*)identifier intValue]];
}
```

Note that the call against your webservice has to return a json object with all of  the properties defined above. So for the SampleResource your JSON response from the webservice would look at the bare minimum like this:
```json
{
    "firstName" : "Red",
    "lastName"  : "Ghost",
    "age"       : 22
}
```

It could have additional properties such as this:
```json
{
    "firstName"     : "Red",
    "middleInitial" : "k",
    "lastName"      : "Ghost",
    "age"           : 22,
    "address"       : "somewhere"
}
```

You could even access and set them like this:
```objc
SampleResource * resource = [SampleResource fetch: ...];
NSString * address = [resource valueForKey:@"address"];
[resource setValue:@"value" forKey:@"address"];
```

Obviously, it's easier and much more readable if you define the property within your resource object.

Here is how you would use the SampleResource:
```objc
#import "SampleResource.h"

...


- (void) aSynchronousExample {
  NSError * error;
  SampleResource resource = [SampleResource fetch:[NSNumber numberWithInt:5] withError:&error];
  if(resource == nil) {
    NSLog(@"Error Occured: %@", error);
    return;
  }
    
  NSLog(@"Fetched SampleResource: %@ %@ of age %@", [resource firstName], [resource lastName], [resource age]);
}

- (void) anAsynchronousExample {
  // Synchronous
  NSError * error;
  [SampleResource fetch:[NSNumber numberWithInt:5] completionHandler:^(SampleResource * resource, NSError *error) {
    if(resource == nil) {
      NSLog(@"Error Occured: %@", error);
      return;
    }
    NSLog(@"Fetched SampleResource: %@ %@ of age %@", [resource firstName], [resource lastName], [resource age]);
  }]
}
```

You will first need to intialize the RRRemoreService object with some values pertaining to your remote service.
Here are some things to consider:

1. The type of data that you will be receiving/sending

2. Authentication - how/if you will handle authentication

3. Timeout Interval - how long before the service should timeout and fail

4. The endpoint that you will hit

To configure these settings somewhere towards the start of your application you will want to pull up the RRRemoteService singleton and change the values.
Here is a sample of how you can do that:
```objc
#import "RRRemoteService.h"

- (void) applicationDidFinishLaunching:(NSNotification*)aNotification {
  RRRemoteService service = [RRRemoteService instance];
  
  // Type of Data
  RRJSONDataConverter * converter = [[RRJSONDataConverter alloc] init];
  [service setConverter:converter];
  
  // Authentication
  SampleAuthenticator * authenticator = [[SampleAuthenticator alloc] init];
  [authenticator setUsername:@"username" andPassword:@"password"];
  [service setAuthenticator:authenticator];
  
  // Timeout Interval
  [service setTimeoutInterval:60.0]; // 60 seconds
  
  // Endpoint
  [service setEndpointURL:[NSURL URLWithString:@"http://someurl.com/api/"]];
}
```

The DataConverter object is responsible from taking raw NSData objects that are returned from the server and converting them into either NSDictionary, NSArray, NSNumber, or NSString.
To create a new DataConverter you would subclass RRDataConverter and supply an implementation to these methods:
```objc
- (NSString*) contentType;
- (NSObject*) objectFromData:(NSData*)data withError:(NSError**)error;
- (NSData*) dataFromObject:(NSObject*)object withError:(NSError**)error;
```

There is already a provided JSON DataConverter called RRJSONDataConverter. Here is what it looks like:
RRJSONDataConverter.m
```objc
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
```

The content type os placed into the headers of the request to pass on to the service. The other two methods are used for transforming data back and forth.

The Authenticator is a method of adding authentication to your requests. Since there are so many authentication schemes available the library does not restrict you in how you want to implement it.
An Authenticator object has to subclass RRAuthenticator and has to provide these methods:
```objc
- (void) addAuthenticationToRequest:(NSMutableURLRequest*)request;
- (BOOL) isAuthenticated;
```

I am considering taking out the isAuthenticated method but as it stands, the library will not call addAuthenticationToRequest if isAuthenticated returns NO.
A sample authenticator might look like this:
SampleAuthenticator.h:
```objc
#import "RRAuthenticator.h"

@interface SampleAuthenticator : RRAuthenticator

@property (strong, nonatomic) NSNumber * userID;
@property (strong, nonatomic) NSString * sessionToken;
@property (strong, nonatomic) NSDate * expirationDate;

typedef void (^LoginHandler)(NSNumber * userID, NSError * error);
- (void)loginWithUsername:(NSString*)username andPassword:(NSString*)password completionHandler:(LoginHandler)handler;

@end
```

SampleAuthenticator.m:
```objc
#import "SampleAuthenticator.h"
#import "RRRemoteService.h"

@implementation SampleAuthenticator

- (void)loginWithUsername:(NSString*)username andPassword:(NSString*)password completionHandler:(LoginHandler)handler {
  NSParameterAssert(handler);
  
  NSDictionary * loginParams = [NSDictionary dictionaryWithObjectsAndKeys:username, @"username", password, @"password",nil];
  [[RRRemoteService instance] executeAsynchronousRequestWithMethod:POST andPath:@"/signin" andParameters:loginParams completionHandler:^(NSObject *resource, NSError *error) {
    if(resource == nil) {
      handler(nil, error);
    }
    else {
      if([resource isKindOfClass:[NSDictionary class]]) {
        _sessionToken = [resource objectForKey:@"sessionToken"];
        _expirationDate = [NSDate dateFromString:[resource objectForKey:@"expiration"]];
        _userID = [resource objectForKey:@"userID"];
        handler(_userID, nil);
      }
      else {
        handler(nil, [NSError errorWithDomain:@"yourdomain" code:1 userInfo:nil]);
      }
  }];
}

- (BOOL)isAuthenticated {
  return _userID != nil && _sessionToken != nil && _expirationDate != nill && [expirationDate compare:[NSDate date]] == NSOrderDescending;
}

- (void) addAuthenticationToRequest:(NSMutableURLRequest*)request {
  [request addValue:_sessionToken forHTTPHeaderField:@"X-Api-Session-Token"];
}

@end
```

The time interval and service endpoint are pretty self explanatory. Service endpoint is concatenated with the path that your resource returns to generate the full resource path.
