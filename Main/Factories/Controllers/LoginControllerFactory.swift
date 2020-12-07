import Foundation
import UI
import Presentation
import Validation
import Domain

public func makeLoginController(authentication: Authentication) -> LoginViewController{
    let controller = LoginViewController.instantiate()
    let validationComposite = ValidationComposite(validations: makeLoginValidations())
    let presenter = LoginPresenter(alertiView: WeakVarProxy(controller), loadingView: WeakVarProxy(controller), validation: validationComposite, authentication: authentication)
    controller.login = presenter.login
    return controller
}

public func makeLoginValidations() -> Array<Validation> {
    return [
        RequiredFieldValidation(fieldName: "email", fieldLabel: "e-mail"),
        EmailValidation(fieldName: "email", fieldLabel: "e-mail", emailValidator: makeEmailValidatorAdapter()),
        RequiredFieldValidation(fieldName: "password", fieldLabel: "password")
    ]
}
