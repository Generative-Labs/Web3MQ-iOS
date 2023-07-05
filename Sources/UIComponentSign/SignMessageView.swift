//
//  SignMessageView.swift
//
//
//  Created by X Tommy on 2022/10/14.
//

import UIKit

class SignMessageView: UIView {

    public var message: String? {
        didSet {
            contentLabel.text = message
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

    private let titleLabel = UILabel()
    private let contentLabel = UILabel()

}

extension SignMessageView {

    private func configureHierarchy() {

        titleLabel.textColor = UIColor.darkText
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.text = "Sign message"
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
        }

        contentLabel.textColor = UIColor(displayP3Red: 63/256.0, green: 63/256.0, blue: 70/256.0, alpha: 1)
        contentLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        contentLabel.numberOfLines = 5
        addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        }

        layer.cornerRadius = 8
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.border.cgColor
    }

}
