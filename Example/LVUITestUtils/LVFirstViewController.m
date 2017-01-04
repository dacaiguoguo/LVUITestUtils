//
//  LVFirstViewController.m
//  LVUITestUtils
//
//  Created by yanguo sun on 04/01/2017.
//  Copyright © 2017 sunyanguo. All rights reserved.
//

#import "LVFirstViewController.h"

@implementation LVFirstViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:NSURLSessionConfiguration.ephemeralSessionConfiguration];
    NSMutableURLRequest *mutRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:5000/login"]];
    mutRequest.HTTPMethod = @"GET";
    NSURLSessionDataTask *task = [session dataTaskWithRequest:mutRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *htmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [self.mainWebView loadHTMLString:htmlString baseURL:mutRequest.URL];
    }];
    [task resume];
}
@end
