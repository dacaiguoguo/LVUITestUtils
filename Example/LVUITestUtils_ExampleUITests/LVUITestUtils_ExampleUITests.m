//
//  LVUITestUtils_ExampleUITests.m
//  LVUITestUtils_ExampleUITests
//
//  Created by yanguo sun on 03/01/2017.
//  Copyright © 2017 sunyanguo. All rights reserved.
//

#import <XCTest/XCTest.h>
@import LVUITestUtils;
#import <LVUITestUtilsServer/LVUITestUtilsServer-Swift.h>


@interface LVUITestUtils_ExampleUITests : LVTestCase
@property (nonatomic, strong) XCUIApplication *app;
@end

@implementation LVUITestUtils_ExampleUITests

- (void)setUp {
    [super setUp];

    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    self.app = [[XCUIApplication alloc] init];
    [self.app launch];
    [self waitForDuration:2];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {

    [self waitForDuration:2];
    [self overrideStatusBar];
    [self waitForDuration:2];
    XCUIElementQuery *tabBars = [self.app tabBars];
    [tabBars.buttons[@"Second"] tap];
    [self waitForDuration:2];
    NSString *path = [NSString stringWithFormat:@"%@/Temp/Screenshots/%@_%@_", self.realHomeDirectory,self.deviceType, self.screenResolution];
    [self saveScreenshot:[path stringByAppendingString:@"screenshot1.png"] createDirectory:YES];
    [self waitForDuration:2];
    self.orientation = UIInterfaceOrientationLandscapeLeft;
    [self waitForDuration:2];
    [self saveScreenshot:[path stringByAppendingString:@"screenshot2.png"] createDirectory:YES];
    NSLog(@"Current orientation (as Int): %ld",(long)self.orientation);
    self.orientation = UIInterfaceOrientationPortrait;
    [self waitForDuration:2];
    
    XCUIElement *textField = [self.app textFields][@"Enter text"];
    [textField tap];
    [textField typeText:@"Alert text"];
    [self waitForDuration:2];
    XCUIElement *alertButton = [self.app buttons][@"Alert"];
    [alertButton tap];
    [self waitForDuration:2];

    XCUIElement *okButton = [[self.app sheets][@"Message"] buttons][@"Ok"];
    [okButton tap];
    [self waitForDuration:2];
    [tabBars.buttons[@"First"] tap];
    [self waitForDuration:2];
    [self restoreStatusBar];
    [self waitForDuration:5];
}

@end
