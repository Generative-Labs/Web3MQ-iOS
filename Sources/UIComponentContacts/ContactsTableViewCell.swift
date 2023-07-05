//
//  ContactsTableViewCell.swift
//  Web3MQDemo
//
//  Created by X Tommy on 2023/1/20.
//

import UIKit
import UIComponentCore
import Web3MQ
import SnapKit
import Kingfisher
import Web3MQServices

class ContactsTableViewCell: UITableViewCell, Reusable {

    private let avatarImageView = UIImageView()
    
    private let nameLabel = UILabel()
    
    private let accessoryButton = FollowButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureHierarchy()
        bindEvents()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureHierarchy()
        bindEvents()
    }
    
    @objc
    private func onTappedAccessoryButton() {
        guard let tapped else {
            return
        }
        tapped()
    }
    
    private func bindEvents() {
        accessoryButton.addTarget(self, action: #selector(onTappedAccessoryButton), for: .touchUpInside)
    }
    
    private var tapped: (() -> Void)?
    
    func render(contactsUser: ContactUser, type: ContactsType, tapped: @escaping () -> Void) {
        self.tapped = tapped
        avatarImageView.kf.setImage(with: URL(string: contactsUser.avatarUrl ?? ""))
        nameLabel.text = contactsUser.nickName
        switch type {
        case .followers:
            accessoryButton.isFollowing = false
        case .following:
            accessoryButton.isFollowing = true
        }
    }
    
}

extension ContactsTableViewCell {
    
    private func configureHierarchy() {
        
        avatarImageView.layer.cornerRadius = 20
        avatarImageView.layer.masksToBounds = true
        contentView.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        nameLabel.textColor = UIColor.label
        nameLabel.font = UIFont.preferredFont(forTextStyle: .footnote).bold()
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(12)
            make.centerY.equalToSuperview()
        }
                
        accessoryButton.layer.cornerRadius = 6
        accessoryButton.layer.masksToBounds = true
        accessoryButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        contentView.addSubview(accessoryButton)
        accessoryButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.equalTo(75)
            make.left.greaterThanOrEqualTo(nameLabel.snp.right).offset(16)
        }
        
    }
    
}
