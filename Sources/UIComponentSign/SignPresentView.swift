//
//  SignPresentView.swift
//  
//
//  Created by X Tommy on 2023/1/10.
//

import UIKit

public class SignPresentView: ProposalPresentView {
    
    private lazy var messageView = SignMessageView()
 
    public var message: String? {
        didSet {
            messageView.message = message
        }
    }
    
    public override var contentView: UIView? {
        get {
            self.messageView
        }
        set {
            super.contentView = newValue
        }
    }
}
