//
//  ConnectMessageView.swift
//
//
//  Created by X Tommy on 2023/1/11.
//

import SnapKit
import UIKit

class ConnectMessageView: UIView {

    private let contentView = UIStackView()

    private let messageLabel0 = UIButton()
    private let messageLabel1 = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureHierarchy()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ConnectMessageView {

    private func configureHierarchy() {

        layer.cornerRadius = 8
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.border.cgColor

        contentView.alignment = .leading
        contentView.axis = .vertical
        contentView.spacing = 8
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }

        messageLabel0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -6, bottom: 0, right: 0)
        messageLabel0.setTitleColor(UIColor.label, for: .normal)
        messageLabel0.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        messageLabel0.setTitle("View your wallet balance and activities", for: .normal)
        messageLabel0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .footnote)
        contentView.addArrangedSubview(messageLabel0)

        messageLabel1.imageEdgeInsets = UIEdgeInsets(top: 0, left: -6, bottom: 0, right: 0)
        messageLabel1.setTitleColor(UIColor.label, for: .normal)
        messageLabel1.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        messageLabel1.setTitle("Request for approval of transaction", for: .normal)
        messageLabel1.titleLabel?.font = UIFont.preferredFont(forTextStyle: .footnote)
        contentView.addArrangedSubview(messageLabel1)

    }

}
