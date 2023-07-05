//
//  DoneButton.swift
//  
//
//  Created by X Tommy on 2023/2/2.
//

import UIKit

///
public class DoneButton: UIButton {
    
    ///
    public var isSelectable: Bool = true {
        didSet {
            changeState(isSelectable: isSelectable)
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureHierarchy()
    }
    
    private func configureHierarchy() {
        isSelectable = true
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
    
    private func changeState(isSelectable: Bool) {
        self.isEnabled = isSelectable
        if isSelectable {
            self.backgroundColor = UIColor(named: "AccentColor")
            self.setTitleColor(UIColor.white, for: .normal)
        } else {
            self.backgroundColor = UIColor(displayP3Red: 224/256.0, green: 224/256.0, blue: 254/256.0, alpha: 1)
            self.setTitleColor(UIColor(displayP3Red: 136/256.0, green: 133/256.0, blue: 253/256.0, alpha: 1), for: .normal)
        }
    }
    
}
