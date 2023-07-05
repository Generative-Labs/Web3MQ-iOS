//
//  AccountBar.swift
//
//
//  Created by X Tommy on 2022/10/14.
//

import Kingfisher
import SnapKit
import UIKit

public class AccountBar: UIView {

    public var avatarUrl: String? {
        didSet {
            if let avatarUrl {
                avatarImageView.kf.setImage(with: URL(string: avatarUrl))
            } else {
                avatarImageView.image = nil
            }
        }
    }

    public var address: String? {
        didSet {
            addressLabel.text = address
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        configureHierarchy()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let avatarImageView = UIImageView()
    private let addressLabel = UILabel()

}

extension AccountBar {

    private func configureHierarchy() {

        avatarImageView.layer.cornerRadius = 22
        avatarImageView.layer.masksToBounds = true
        avatarImageView.backgroundColor = UIColor.accent
        avatarImageView.contentMode = .scaleAspectFill
        addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(32)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(44)
        }

        addressLabel.textColor = UIColor.label
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
