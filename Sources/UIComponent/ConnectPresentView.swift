//
//  ConnectPresentView.swift
//
//
//  Created by X Tommy on 2023/1/11.
//

import Presentable
import UIKit

public class ConnectPresentView: ProposalPresentView {

    private lazy var messageView = ConnectMessageView()

    public override init(frame: CGRect) {
        super.init(frame: frame)

        title = "Connect to this site?"
        confirmButtonTitle = "Connect"
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override var contentView: UIView? {
        set {
            super.contentView = newValue
        }
        get {
            messageView
        }
    }
}
