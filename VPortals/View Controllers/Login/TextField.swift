
import UIKit

class TextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    //MARK: Intialisers
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
     private func setupViews() {
            
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = 8.0
        self.layer.borderWidth = 1.0
            
        }
    
}
