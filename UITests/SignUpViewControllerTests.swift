import XCTest
import UIKit
@testable import UI
import Presentation

class SignUpViewControllerTests: XCTestCase {
    func test_loading_is_hidden_on_start() throws {
        let sb = UIStoryboard(name: "SignUp", bundle: Bundle(for: SignUpViewController.self))
        let sut = sb.instantiateViewController(identifier: "SignUpViewController") as! SignUpViewController
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.loadingIndicator?.isAnimating, false)
    }
    
    func test_it_implements_LoadingView() throws {
        XCTAssertNotNil(makeSut() as LoadingView)
    }
    
    
    func test_it_implements_AlertView() throws {
        XCTAssertNotNil(makeSut() as AlertView)
    }
}


extension SignUpViewControllerTests {
    func makeSut() -> SignUpViewController {
        let sb = UIStoryboard(name: "SignUp", bundle: Bundle(for: SignUpViewController.self))
        let sut = sb.instantiateViewController(identifier: "SignUpViewController") as! SignUpViewController
        sut.loadViewIfNeeded()
        return sut
    }
}

extension UIControl {
    func simulate(event: UIControl.Event) {
        allTargets.forEach { (target) in
            actions(forTarget: target, forControlEvent: event)?.forEach({ (action) in
                (target as NSObject).perform(Selector(action))
            })
        }
    }
    
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}
