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

- (void)testShareInstance {
    JTWalletManager *instance = [JTWalletManager shareInstance];
    XCTAssertTrue(_jtWalletManager == instance);
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
    [_jtWalletManager createWallet:BIZAIN_CHAIN completion:^(NSError *error, JingtumWallet *wallet) {
        XCTAssertNil(error);
        XCTAssertTrue([wallet isKindOfClass:JingtumWallet.class]);
        NSString __block *address = wallet.address;
        [weakSelf.jtWalletManager importSecret:wallet.secret chain:BIZAIN_CHAIN completion:^(NSError *error, JingtumWallet *wallet) {
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
    
    [_jtWalletManager isValidAddress:@"bDGbTGBLCrSqW54YZrjQ5qQNQKSBX6GJUK" chain:BIZAIN_CHAIN completion:^(BOOL isValid) {
        XCTAssertTrue(isValid);
        [e3 fulfill];
    }];
    
    [_jtWalletManager isValidAddress:@"shWSppK2jFUGg2tMhfaLVs7fDWinW" chain:BIZAIN_CHAIN completion:^(BOOL isValid) {
        XCTAssertFalse(isValid);
        [e4 fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)testImportSecret {
    XCTestExpectation *e1 = [self expectationWithDescription:@"import invalid secret"];
    
    [_jtWalletManager importSecret:@"1" chain:SWTC_CHAIN completion:^(NSError *error, JingtumWallet *wallet) {
        XCTAssertNotNil(error);
        XCTAssertNil(wallet);
        [e1 fulfill];
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
    
    [_jtWalletManager isValidSecret:@"shWSppK2jFUGg2tMhfaLVs7fDWinW" chain:BIZAIN_CHAIN completion:^(BOOL isValid) {
        XCTAssertTrue(isValid);
        [e3 fulfill];
    }];
    
    [_jtWalletManager isValidSecret:@"bDGbTGBLCrSqW54YZrjQ5qQNQKSBX6GJUK" chain:BIZAIN_CHAIN completion:^(BOOL isValid) {
        XCTAssertFalse(isValid);
        [e4 fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)testSignJingtumData {
    XCTestExpectation *e1 = [self expectationWithDescription:@"locally sign jingtum transaction data successfully"];
    XCTestExpectation *e2 = [self expectationWithDescription:@"locally sign jingtum transaction data unsuccessfully"];
    NSMutableDictionary *transaction = [[NSMutableDictionary alloc] initWithCapacity:0];
    [transaction setValue:@"jpgWGpfHz8GxqUjz5nb6ej8eZJQtiF6KhH" forKey:@"Account"];
    [transaction setValue:@"Payment" forKey:@"TransactionType"];
    [transaction setValue:@"j4JJb3c17HuwRoKycjtrd9adpmbrneEE6w" forKey:@"Destination"];
    [transaction setValue:[[NSNumber alloc] initWithDouble:0.00001] forKey:@"Fee"];
    [transaction setValue:[[NSNumber alloc] initWithInt:0] forKey:@"Flags"];
    [transaction setValue:[[NSNumber alloc] initWithInt:1] forKey:@"Amount"];
    [transaction setValue:[[NSNumber alloc] initWithInt:1] forKey:@"Sequence"];
    NSString *secret = @"snfXQMEVbbZng84CcfdKDASFRi4Hf";
    NSString *sign = @"120000220000000024000000016140000000000F424068400000000000000A732102C13075B18C87A032226CE383AEFD748D7BB719E02CD7F5A8C1F2C7562DE7C12A7446304402201C26C28C8DE3282D6B1ADE62CFFB64173976D33041DB853E7864B9463D189E4B0220265622645B6E56AEB9B42D4946AAAA7D86F37774F3956DEF3A81D4EB4EBA6B2181141270C5BE503A3A22B506457C0FEC97633B44F7DD8314E9A06519E65C7122C67380797BAE5B857E2822CF";
    [_jtWalletManager sign:transaction secret:secret chain:SWTC_CHAIN completion:^(NSError *error, NSString *signature) {
        XCTAssertNil(error);
        XCTAssertTrue([sign isEqualToString:signature]);
        [e1 fulfill];
    }];
    [_jtWalletManager sign:transaction secret:@"aaa" chain:SWTC_CHAIN completion:^(NSError *error, NSString *signature) {
        XCTAssertNil(signature);
        XCTAssertNotNil(error);
        [e2 fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)testSignBizainData {
    XCTestExpectation *e1 = [self expectationWithDescription:@"locally sign bizain transaction data successfully"];
    NSMutableDictionary *transaction = [[NSMutableDictionary alloc] initWithCapacity:0];
    [transaction setValue:@"bMAy4Pu8CSf5apR44HbYyLFKeC9Dbau16Q" forKey:@"Account"];
    [transaction setValue:@"Payment" forKey:@"TransactionType"];
    [transaction setValue:@"bDGbTGBLCrSqW54YZrjQ5qQNQKSBX6GJUK" forKey:@"Destination"];
    [transaction setValue:[[NSNumber alloc] initWithDouble:0.00001] forKey:@"Fee"];
    [transaction setValue:[[NSNumber alloc] initWithInt:0] forKey:@"Flags"];
    [transaction setValue:[[NSNumber alloc] initWithInt:1] forKey:@"Amount"];
    [transaction setValue:[[NSNumber alloc] initWithInt:1] forKey:@"Sequence"];
    NSString *secret = @"ssySqG4BhxpngV2FjAe1SJYFD4dcm";
    NSString *sign = @"120000220000000024000000016140000000000F424068400000000000000A73210305907425BF03CD414D089EB48FE0AB7898B74985F43B0A42EB06588DA6FFC58E74463044022067DAA47DAF9FEF458E5E64993183BDA4B603F9D0582466967E5CD38B5A46FBB1022006003164A4F5FB312E6A5336E69EDE6F18A1D484586470212C3A803474EC11C48114E5C8083009E1C466A7484CF57497009AB5A31AED831486782075FDFAAAB18F245142883C0B56BC23C18F";
    [_jtWalletManager sign:transaction secret:secret chain:BIZAIN_CHAIN completion:^(NSError *error, NSString *signature) {
        XCTAssertNil(error);
        XCTAssertTrue([sign isEqualToString:signature]);
        [e1 fulfill];
    }];
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}


@end
