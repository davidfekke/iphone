//
//  InstanexAccess.m
//  InstanexIPhoneSample
//
//  Created by David P Fekke on 3/16/13.
//  Copyright (c) 2013 David Fekke L.L.C. All rights reserved.
//

#import "InstanexAccess.h"

@implementation InstanexAccess

- (id)initWithAccessKey:(NSString *)accessKey andSecretKey:(NSString *)secretKey andBaseURL:(NSString *)baseURL
{
    self = [super init];
    if (!self) return nil;
    self.appAccessKey = accessKey;
    self.appSecretKey = secretKey;
    self.baseURL = baseURL;
    return self;
}

- (NSData *)getAuthorizationWithUsername:(NSString *)username password:(NSString *)password
{
    NSDate *currentDate = [NSDate date];
    NSString *path = @"/api/account/token";
    NSString *dateString = [self createCurrentDateString:currentDate];
    NSString *unencrypted_signature = [self compute_signature:dateString withMethod:@"POST" withURL:path];
    NSString *hashed_signature = [self hashed_string:unencrypted_signature];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *fullURL = [[NSString alloc] initWithFormat:@"%@%@", self.baseURL, path];
    NSURL *myURL = [NSURL URLWithString:fullURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:self.appAccessKey forHTTPHeaderField:@"Instanext-AccessKey"];
    [request setValue:dateString forHTTPHeaderField:@"Date"];
    [request setValue:hashed_signature forHTTPHeaderField:@"Instanext-Signature"];
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //[ request setValue:@"api.instanexdev.com" forHTTPHeaderField:@"Host"];
    NSLog(@"Unencrypted Signature: %@", unencrypted_signature);
    NSLog(@"RFC2822 Date: %@", dateString);
    NSLog(@"Hashed Signature: %@", hashed_signature);
    NSDictionary *bodyDict = @{
                               @"Username": username,
                               @"Password": password
                               };
    NSError *myErr;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:bodyDict options:kNilOptions error:&myErr];
    //NSString *jsonBody = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
    [request setHTTPBody:bodyData];
    NSURLResponse *response = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&myErr];

    return data;
}

- (NSArray *)getCompanies
{
    NSDate *currentDate = [NSDate date];
    NSString *path = @"/api/companies";
    NSString *apiToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"ApiToken"];
    NSString *dateString = [self createCurrentDateString:currentDate];
    NSString *unencrypted_signature = [self compute_signature:dateString withMethod:@"GET" withURL:path];
    NSString *hashed_signature = [self hashed_string:unencrypted_signature];
    NSLog(@"Hashed Signature: %@", hashed_signature);
    NSString *fullURL = [[NSString alloc] initWithFormat:@"%@%@", self.baseURL, path];
    NSURL *myURL = [NSURL URLWithString:fullURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:self.appAccessKey forHTTPHeaderField:@"Instanext-AccessKey"];
    [request setValue:dateString forHTTPHeaderField:@"Date"];
    [request setValue:hashed_signature forHTTPHeaderField:@"Instanext-Signature"];
    [request setValue:apiToken forHTTPHeaderField:@"Instanext-AuthToken"];
    
    NSURLResponse *response = nil;
    NSError *myErr = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&myErr];
    
    NSMutableArray *companiesArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&myErr];
    
    return companiesArray;
}

- (NSString *)hashed_string:(NSString *)input
{
    //NSString *key = @"LMsRKlmz+IlLbJR7adp0KAaWYwONkMggHZ0L0aktU0A=";
    NSData *mySecretKey = [NSData dataWithBase64EncodedString:self.appSecretKey];
    
    const char *cData = [input cStringUsingEncoding:NSUTF8StringEncoding];
    
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA256, [mySecretKey bytes], [mySecretKey length], cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    NSString *hash = [HMAC base64Encoding];
    
    return hash;
}

- (NSString *)createCurrentDateString:(NSDate *)currDate
{
    //Date has to follow the following format 3/13/2013 10:19:07 PM +00:00
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // maybe there exist a new-method now
    dateFormatter.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss z"; ////RFC2822-Format@"M/d/yyyy hh':'mm':'ss a '+00:00'";
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    return dateString;
}

//-(NSString *)compute_signature:(NSString *)currDateString
//{
//    NSMutableString *signature = [[NSMutableString alloc] init];
//    [signature appendString:self.appAccessKey];
//    [signature appendString:@"\r\n"];
//    [signature appendString:@"POST"];
//    [signature appendString:@"\r\n"];
//    [signature appendString:@"/api/account/token"];
//    [signature appendString:@"\r\n"];
//    [signature appendString:currDateString];
//    [signature appendString:@"\r\n"];
//    return signature;
//}

-(NSString *)compute_signature:(NSString *)currDateString withMethod:(NSString *)method withURL:(NSString *)url
{
    NSMutableString *signature = [[NSMutableString alloc] init];
    [signature appendString:self.appAccessKey];
    [signature appendString:@"\r\n"];
    [signature appendString:method];
    [signature appendString:@"\r\n"];
    [signature appendString:url];
    [signature appendString:@"\r\n"];
    [signature appendString:currDateString];
    [signature appendString:@"\r\n"];
    return signature;
}

@end
