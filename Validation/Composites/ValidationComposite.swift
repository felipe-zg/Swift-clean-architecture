import Foundation
import Presentation

public class ValidationComposite: Validation {
    private let validations: Array<Validation>
    
    public init(validations: Array<Validation>) {
        self.validations = validations
    }
    
    public func validate(data: [String : Any]?) -> String? {
        for validation in validations {
            if let errorMessage = validation.validate(data: data) {
                return errorMessage
            }
        }
        
        return nil
    }
}
