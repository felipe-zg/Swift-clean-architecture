import Foundation
import UIKit

public final class RoundedTextField: UITextField {
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        layer.borderColor = UIColor.red.cgColor
        layer.borderWidth = 0.5
        layer.cornerRadius = 5
    }
}
