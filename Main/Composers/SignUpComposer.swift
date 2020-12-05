import Foundation
import Domain
import Validation
import Presentation
import UI
import Infra

public final class SignUpComposer {
    public static func composeControllerWith(addAccount: AddAccount) -> SignUpViewController{
        let controller = SignUpViewController.instantiate()
        let validationComposite = ValidationComposite(validations: makeValidations())
        let presenter = SignUpPresenter(alertView: WeakVarProxy(controller), loadingView: WeakVarProxy(controller), validation: validationComposite, addAccount: addAccount)
        controller.signUp = presenter.signUp
        return controller
    }
    
    public static func makeValidations() -> Array<Validation> {
        return [
            RequiredFieldValidation(fieldName: "name", fieldLabel: "name"),
            RequiredFieldValidation(fieldName: "email", fieldLabel: "e-mail"),
            EmailValidation(fieldName: "email", fieldLabel: "e-mail", emailValidator: EmailValidatorAdapter()),
            RequiredFieldValidation(fieldName: "password", fieldLabel: "password"),
            RequiredFieldValidation(fieldName: "passwordConfirmation", fieldLabel: "password confirmation"),
            CompareFieldsValidation(fieldName: "password", fieldToCompareName: "passwordConfirmation", fieldLabel: "password")
        ]
    }
}
