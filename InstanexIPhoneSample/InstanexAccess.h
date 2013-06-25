//
//  InstanexAccess.h
//  InstanexIPhoneSample
//
//  Created by David P Fekke on 3/16/13.
//  Copyright (c) 2013 David Fekke L.L.C. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>
#import <CommonCrypto/CommonHMAC.h>
#import "NSData+Additions.h"

@interface InstanexAccess : NSObject

@property (weak, nonatomic) NSString *appSecretKey;
@property (weak, nonatomic) NSString *appAccessKey;
@property (weak, nonatomic) NSString *apiToken;
@property (weak, nonatomic) NSString *baseURL;

- (id)initWithAccessKey:(NSString *)accessKey andSecretKey:(NSString *)secretKey andBaseURL:(NSString *)baseURL;
- (NSString *)hashed_string:(NSString *)input;
- (NSString *)createCurrentDateString:(NSDate *)currDate;
- (NSString *)compute_signature:(NSString *)currDateString withMethod:(NSString *)method withURL:(NSString *)url;

- (NSData *)getAuthorizationWithUsername:(NSString *)username password:(NSString *)password;
- (NSMutableArray *)getCompanies;
@end
