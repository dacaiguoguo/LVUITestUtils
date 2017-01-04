//
//  LVTestCase.m
//  Pods
//
//  Created by yanguo sun on 04/01/2017.
//
//

#import <XCTest/XCTest.h>

@interface LVTestCase : XCTestCase
@property (nonatomic, assign) NSTimeInterval waitTimeout;
@property (nonatomic, readonly, strong) NSString * _Nonnull uiTestServerAddress;
@property (nonatomic, readonly, copy) NSString * _Nonnull realHomeDirectory;
@property (nonatomic, readonly, copy) NSString * _Nonnull screenResolution;
@property (nonatomic, readonly, copy) NSString * _Nonnull deviceType;
@property (nonatomic) UIInterfaceOrientation orientation;
@property (nonatomic, weak) XCTestExpectation * _Nullable waitExpectation;
@property (nonatomic, strong) NSURLSession * _Nonnull session;
@property (nonatomic, strong) NSURLSessionDataTask *taskGet;

- (nonnull NSString *)realHomeDirectory;
- (nonnull NSString *)screenResolution;
- (nonnull NSString *)deviceType;
- (void)overrideStatusBar;
- (void)restoreStatusBar;
- (nonnull NSString *)urlForEndpoint:(nonnull NSString *)endpoint args:(nullable NSArray *)args;
- (nonnull NSData *)dataFromRemoteEndpoint:(nonnull NSString *)endpoint method:(nonnull NSString *)method args:(nullable NSArray *)args;
- (nonnull NSData *)dataGetFromRemoteEndpoint:(nonnull NSString *)endpoint args:(nullable NSArray *)args;
- (nonnull NSString *)stringGetFromRemoteEndpoint:(nonnull NSString *)endpoint args:(nullable NSArray *)args;
- (void)callRemoteEndpoint:(nonnull NSString *)endpoint method:(nonnull NSString *)method args:(nullable NSArray *)args;
- (void)callGetRemoteEndpoint:(nonnull NSString *)endpoint args:(nullable NSArray *)args;
- (void)saveScreenshot:(NSString * _Nonnull)filename createDirectory:(BOOL)createDirectory;
- (void)waitForDuration:(NSTimeInterval)duration;
- (void)waitForExpectationsWithCommonTimeoutUsingHandler:(nullable XCWaitCompletionHandler)handler;
@end


