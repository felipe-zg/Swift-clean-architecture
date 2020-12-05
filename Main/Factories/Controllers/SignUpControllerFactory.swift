import Foundation
import UI
import Presentation
import Validation
import Domain

public func makeSignUpController(addAccount: AddAccount) -> SignUpViewController{
    let controller = SignUpViewController.instantiate()
    let validationComposite = ValidationComposite(validations: makeSignUpValidations())
    let presenter = SignUpPresenter(alertView: WeakVarProxy(controller), loadingView: WeakVarProxy(controller), validation: validationComposite, addAccount: addAccount)
    controller.signUp = presenter.signUp
    return controller
}

public func makeSignUpValidations() -> Array<Validation> {
    return [
        RequiredFieldValidation(fieldName: "name", fieldLabel: "name"),
        RequiredFieldValidation(fieldName: "email", fieldLabel: "e-mail"),
        EmailValidation(fieldName: "email", fieldLabel: "e-mail", emailValidator: makeEmailValidatorAdapter()),
        RequiredFieldValidation(fieldName: "password", fieldLabel: "password"),
        RequiredFieldValidation(fieldName: "passwordConfirmation", fieldLabel: "password confirmation"),
        CompareFieldsValidation(fieldName: "password", fieldToCompareName: "passwordConfirmation", fieldLabel: "password")
    ]
}
