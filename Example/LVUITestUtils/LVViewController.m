//
//  LVViewController.m
//  LVUITestUtils
//
//  Created by dacaiguoguo on 01/03/2017.
//  Copyright (c) 2017 dacaiguoguo. All rights reserved.
//

#import "LVViewController.h"

@interface LVViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *mainWebView;

@end

@implementation LVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:NSURLSessionConfiguration.ephemeralSessionConfiguration];
    NSMutableURLRequest *mutRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:5000/login"]];
    mutRequest.HTTPMethod = @"GET";
    NSURLSessionDataTask *task = [session dataTaskWithRequest:mutRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *htmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [self.mainWebView loadHTMLString:htmlString baseURL:mutRequest.URL];
    }];
    [task resume];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
