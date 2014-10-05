//
//  FTKDataManager.m
//  flytokiwi
//
//  Created by Q on 14-10-5.
//  Copyright (c) 2014年 zwq. All rights reserved.
//

#import "FTKDataManager.h"

@interface FTKDataManager () <NSURLSessionDataDelegate>

@property (strong,nonatomic) NSURLSession *session;

@end

@implementation FTKDataManager

+ (instancetype)sharedData
{
    static FTKDataManager *sharedData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedData = [[FTKDataManager alloc] init];
    });
    return sharedData;
}

- (id)fetchData
{
    __block NSArray *jsonObject;
//    NSString *requestSting = @"http://flytokiwi.com/blog/wp-json/posts";
    NSString *requestSting = @"http://flytokiwi.com/blog/wp-json/posts";
    
    NSURL *url = [NSURL URLWithString:requestSting];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if ([jsonObject isKindOfClass:[NSArray class]]) {
            NSLog(@"%lu jsonObj",jsonObject.count);
            NSLog(@"array");
//            NSLog(@"%@",jsonObject);
        }
        
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            NSLog(@"%@",jsonObject);
            NSLog(@"dict");
        }
    }];
    [dataTask resume];
    return jsonObject;
}
@end













