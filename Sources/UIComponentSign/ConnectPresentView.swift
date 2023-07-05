//
//  ConnectPresentView.swift
//  
//
//  Created by X Tommy on 2023/1/11.
//

import UIKit
import Presentable

public class ConnectPresentView: ProposalPresentView {

    private lazy var intentionView = ConnectIntentionView()
        
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureHierarchy()
    }
    
    public override var contentView: UIView? {
        set {
            super.contentView = newValue
        }
        get {
            intentionView
        }
    }
    
    private func configureHierarchy() {
        title = "Connect to this site?"
        confirmButtonTitle = "Connect"
    }
    
}
