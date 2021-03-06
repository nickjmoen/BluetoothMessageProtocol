import XCTest
@testable import BluetoothMessageProtocolTests

XCTMain([
    testCase(CompanyIdentifierTests.allTests),
    testCase(MemberIdentifierTests.allTests),
    testCase(CharacteristicCurrentTimeTests.allTests),
    testCase(CodeableTests.allTests),
    testCase(GymConnectTests.allTests),
    testCase(HeartRateTests.allTests),
    testCase(HomeKitTests.allTests),
    testCase(ModelIdentifierTests.allTests),
])
