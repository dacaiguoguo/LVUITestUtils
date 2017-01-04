//
//  LVTestCase.m
//  Pods
//
//  Created by yanguo sun on 04/01/2017.
//
//

#import <XCTest/XCTest.h>
#import "LVTestCase.h"
@import SimulatorStatusMagic;

NSString * const uiTestServerAddress = @"http://localhost:5000";

@implementation LVTestCase

- (void)setUp {
    [super setUp];
    self.waitTimeout = 20.0;
}

- (void)tearDown {
    [super tearDown];
}

- (NSString *)uiTestServerAddress {
    return uiTestServerAddress;
}

- (NSString *)urlencodeString:(NSString *)string {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[string UTF8String];
    int sourceLen = (int)strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

- (NSString *)realHomeDirectory {
    NSString *home = NSHomeDirectory();
    NSString *realHome = [home substringToIndex:[home rangeOfString:@"/Library/Developer/"].location];
    return realHome;
}

- (NSString *)screenResolution {
    return [self stringGetFromRemoteEndpoint:@"screenResolution" args:nil];
}

- (NSString *)deviceType {
    return [self stringGetFromRemoteEndpoint:@"deviceType" args:nil];
}

- (void)overrideStatusBar {
    [[SDStatusBarManager sharedInstance] enableOverrides];
}

- (void)restoreStatusBar{
    [[SDStatusBarManager sharedInstance] disableOverrides];
}

- (UIInterfaceOrientation)orientation {
    NSString *deviceTypeString = [self stringGetFromRemoteEndpoint:@"deviceType" args:nil];
    return deviceTypeString.integerValue;
}

- (void)setOrientation:(UIInterfaceOrientation)orientation {
    [self callGetRemoteEndpoint:@"setOrientation" args:@[@(orientation).description]];
}

- (NSURLSession *)session {
    if (!_session) {
        self.session = [NSURLSession sessionWithConfiguration:NSURLSessionConfiguration.ephemeralSessionConfiguration];
    }
    return _session;
}

- (NSString *)urlForEndpoint:(NSString *)endpoint args:(NSArray *)args {
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@/%@",self.uiTestServerAddress, endpoint];
    for (NSString *arg in args) {
        [urlString appendString:@"/"];
        [urlString appendString:[self urlencodeString:arg]];
    }
    if (urlString.length == 0) {
        XCTFail("Invalid URL: %@", urlString);
    }
    
    return urlString;
}

- (NSData *)dataFromRemoteEndpoint:(NSString *)endpoint method:(NSString *)method args:(NSArray *)args {
    NSString *url = [self urlForEndpoint:endpoint args:args];
    if (!url) {
        return nil;
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = method;
    __block NSData *result;
    XCTestExpectation *expectation = [self expectationWithDescription:@"result"];
    self.taskGet = [[self session] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            XCTFail("dataTaskWithRequest error (please check if UITestServer is running): %@",error);
            return;
        }
        if (response) {
            if ([((NSHTTPURLResponse *)response) statusCode] != 200) {
                XCTFail("dataTaskWithRequest: status code %d received, please check if UITestServer is running",[((NSHTTPURLResponse *)response) statusCode]);
                return;
            }
        }
        if (!data) {
            XCTFail("No data received (UITestServer not running?)");
            return;
        }
        result = data;
        [expectation fulfill];
    }];
    [self.taskGet resume];
    [self waitForExpectationsWithTimeout:10 handler:nil];
    return result;
}

- (NSData *)dataGetFromRemoteEndpoint:(NSString *)endpoint args:(NSArray *)args {
    return [self dataFromRemoteEndpoint:endpoint method:@"GET" args:args];
}

- (NSString *)stringFromRemoteEndpoint:(NSString *)endpoint method:(NSString *)method args:(NSArray *)args {
    NSData *data = [self dataFromRemoteEndpoint:endpoint method:method args:args];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}

- (NSString *)stringGetFromRemoteEndpoint:(NSString *)endpoint args:(NSArray *)args {
    NSString *ret = [self stringFromRemoteEndpoint:endpoint method:@"GET" args:args];
    return ret;
}

- (void)callRemoteEndpoint:(NSString *)endpoint method:(NSString *)method args:(NSArray *)args {
    __attribute__((unused)) NSData *data = [self dataFromRemoteEndpoint:endpoint method:method args:args];
}

- (void)callGetRemoteEndpoint:(NSString *)endpoint args:(NSArray *)args {
    __attribute__((unused)) NSData *data = [self dataFromRemoteEndpoint:endpoint method:@"GET" args:args];
}

- (void)saveScreenshot:(NSString * _Nonnull)filename createDirectory:(BOOL)createDirectory {
    if (createDirectory) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *directory = [filename stringByDeletingLastPathComponent];
        if (![fileManager fileExistsAtPath:directory]) {
            [fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSData *data = [self dataGetFromRemoteEndpoint:@"screenshot.png" args:nil];
        NSData *imageData = data;
        if (!imageData) {
            XCTFail(@"No data received (UITestServer not running?)");
            return;
        }
        if (imageData.length == 0) {
            XCTFail(@"Empty screenshot received");
            return;
        }
        BOOL result = [imageData writeToURL:[NSURL fileURLWithPath:filename] atomically:YES];
        if (!result) {
            XCTFail(@"Screenshot not saved:%@", filename);
        }
        NSLog(@"%@",[NSString stringWithFormat:@"Screenshot saved:%@",filename]);
    }
}

- (void)waitForDuration:(NSTimeInterval)duration {
    self.waitExpectation = [self expectationWithDescription:@"wait"];
    [NSTimer scheduledTimerWithTimeInterval:duration repeats:NO block:^(NSTimer * _Nonnull timer) {
        [self.waitExpectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:duration + 3 handler:nil];
}

- (void)waitForExpectationsWithCommonTimeoutUsingHandler:(XCWaitCompletionHandler)handler {
    [self waitForExpectationsWithTimeout:self.waitTimeout handler:handler];
}
@end
