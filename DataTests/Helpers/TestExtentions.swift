import XCTest
import Foundation

extension XCTestCase {
    func checkMemoryLeak(for instance: AnyObject, file: StaticString = #file, line: UInt = #line){
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, file: file, line: line)
        }
    }
}
