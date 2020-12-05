import Foundation
import Presentation

public final class CompareFieldsValidation: Validation, Equatable {
    private let fieldName: String
    private let fieldToCompareName: String
    private let fieldLabel: String
    
    public init(fieldName: String, fieldToCompareName: String, fieldLabel: String) {
        self.fieldName = fieldName
        self.fieldToCompareName = fieldToCompareName
        self.fieldLabel = fieldLabel
    }
    
    public func validate(data: [String : Any]?) -> String? {
        guard let _ = data,  data?[fieldName] as? String == data?[fieldToCompareName] as? String else {
            return "\(fieldLabel) does not match"
        }
        return nil
    }
    
    public static func == (lhs: CompareFieldsValidation, rhs: CompareFieldsValidation) -> Bool {
        return lhs.fieldName == rhs.fieldName && lhs.fieldLabel == rhs.fieldLabel && lhs.fieldToCompareName == rhs.fieldToCompareName
    }
}
