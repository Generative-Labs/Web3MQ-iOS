//
//  SignAccountBar.swift
//
//
//  Created by X Tommy on 2022/10/14.
//

import Kingfisher
import SnapKit
import UIKit

class AccountBar: UIView {

    public var avatarUrl: String? {
        didSet {
            onAvatarUrlChanged(url: avatarUrl)
        }
    }

    public var address: String? {
        didSet {
            onAddressChanged(address: address)
        }
    }

    override var tintColor: UIColor! {
        didSet {
            super.tintColor = tintColor
            avatarImageView.backgroundColor = tintColor
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

    private let avatarImageView = UIImageView()
    private let addressLabel = UILabel()

    private func onAvatarUrlChanged(url: String?) {
        if let avatarUrl {
            avatarImageView.kf.setImage(with: URL(string: avatarUrl))
        } else {
            avatarImageView.image = nil
        }
    }

    private func onAddressChanged(address: String?) {
        addressLabel.text = address
    }

}

extension AccountBar {

    private func configureHierarchy() {

        avatarImageView.layer.cornerRadius = 22
        avatarImageView.layer.masksToBounds = true
        avatarImageView.backgroundColor = tintColor
        avatarImageView.contentMode = .scaleAspectFill
        addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(32)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(44)
        }

        addressLabel.textColor = UIColor.darkText
        addressLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        addSubview(addressLabel)
        addressLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(8)
            make.centerY.equalTo(avatarImageView)
            make.right.equalToSuperview().offset(-32)
        }

        layer.cornerRadius = 8
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.border.cgColor
    }

}
