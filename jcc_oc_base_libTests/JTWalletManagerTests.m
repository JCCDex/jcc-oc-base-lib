//
//  JTWalletManagerTests.m
//  jcc_oc_base_libTests
//
//  Created by 沐生 on 2019/1/2.
//  Copyright © 2019 JCCDex. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JTWalletManager.h"
#import "JingtumWallet.h"
#import "JccChains.h"

@interface JTWalletManagerTests : XCTestCase
@property (strong, nonatomic) JTWalletManager *jtWalletManager;
@end

@implementation JTWalletManagerTests

- (void)setUp {
    _jtWalletManager = [JTWalletManager shareInstance];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testCreateMoacWallet {
    XCTestExpectation *expectation = [self expectationWithDescription:@"create moac wallet unsuccessfully"];
    [_jtWalletManager createWallet: @"moac" completion:^(NSError *error, JingtumWallet *wallet) {
        XCTAssertNil(wallet);
        XCTAssertNotNil(error);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)testCreateJingtumWallet {
    __weak typeof(self) weakSelf = self;
    XCTestExpectation *expectation = [self expectationWithDescription:@"create jingtum wallet successfully"];
    [_jtWalletManager createWallet:SWTC_CHAIN completion:^(NSError *error, JingtumWallet *wallet) {
        XCTAssertNil(error);
        XCTAssertTrue([wallet isKindOfClass:JingtumWallet.class]);
        NSString __block *address = wallet.address;
        [weakSelf.jtWalletManager importSecret:wallet.secret chain:SWTC_CHAIN completion:^(NSError *error, JingtumWallet *wallet) {
            XCTAssertTrue([address isEqualToString:wallet.address]);
            [expectation fulfill];
        }];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)testCreateBizianWallet {
    __weak typeof(self) weakSelf = self;
    XCTestExpectation *expectation = [self expectationWithDescription:@"create bizian wallet successfully"];
    [_jtWalletManager createWallet:BIZIAN_CHAIN completion:^(NSError *error, JingtumWallet *wallet) {
        XCTAssertNil(error);
        XCTAssertTrue([wallet isKindOfClass:JingtumWallet.class]);
        NSString __block *address = wallet.address;
        [weakSelf.jtWalletManager importSecret:wallet.secret chain:BIZIAN_CHAIN completion:^(NSError *error, JingtumWallet *wallet) {
            XCTAssertTrue([address isEqualToString:wallet.address]);
            [expectation fulfill];
        }];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)testIsValidAddress {
    XCTestExpectation *e1 = [self expectationWithDescription:@"is valid jingtum address"];
    XCTestExpectation *e2 = [self expectationWithDescription:@"is invalid jingtum address"];
    XCTestExpectation *e3 = [self expectationWithDescription:@"is valid bizain address"];
    XCTestExpectation *e4 = [self expectationWithDescription:@"is invalid bizain address"];
    
    [_jtWalletManager isValidAddress:@"j4JJb3c17HuwRoKycjtrd9adpmbrneEE6w" chain:SWTC_CHAIN completion:^(BOOL isValid) {
        XCTAssertTrue(isValid);
        [e1 fulfill];
    }];
    
    [_jtWalletManager isValidAddress:@"jajajjaja" chain:SWTC_CHAIN completion:^(BOOL isValid) {
        XCTAssertFalse(isValid);
        [e2 fulfill];
    }];
    
    [_jtWalletManager isValidAddress:@"bDGbTGBLCrSqW54YZrjQ5qQNQKSBX6GJUK" chain:BIZIAN_CHAIN completion:^(BOOL isValid) {
        XCTAssertTrue(isValid);
        [e3 fulfill];
    }];
    
    [_jtWalletManager isValidAddress:@"shWSppK2jFUGg2tMhfaLVs7fDWinW" chain:BIZIAN_CHAIN completion:^(BOOL isValid) {
        XCTAssertFalse(isValid);
        [e4 fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)testIsValidSecret {
    XCTestExpectation *e1 = [self expectationWithDescription:@"is valid jingtum secret"];
    XCTestExpectation *e2 = [self expectationWithDescription:@"is invalid jingtum secret"];
    XCTestExpectation *e3 = [self expectationWithDescription:@"is valid bizain secret"];
    XCTestExpectation *e4 = [self expectationWithDescription:@"is invalid bizain secret"];
    
    [_jtWalletManager isValidSecret:@"ssb7GB1XXRMwkpqcf8gjkR5v3jXDQ" chain:SWTC_CHAIN completion:^(BOOL isValid) {
        XCTAssertTrue(isValid);
        [e1 fulfill];
    }];
    
    [_jtWalletManager isValidSecret:@"jajajjaja" chain:SWTC_CHAIN completion:^(BOOL isValid) {
        XCTAssertFalse(isValid);
        [e2 fulfill];
    }];
    
    [_jtWalletManager isValidSecret:@"shWSppK2jFUGg2tMhfaLVs7fDWinW" chain:BIZIAN_CHAIN completion:^(BOOL isValid) {
        XCTAssertTrue(isValid);
        [e3 fulfill];
    }];
    
    [_jtWalletManager isValidSecret:@"bDGbTGBLCrSqW54YZrjQ5qQNQKSBX6GJUK" chain:BIZIAN_CHAIN completion:^(BOOL isValid) {
        XCTAssertFalse(isValid);
        [e4 fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

@end
