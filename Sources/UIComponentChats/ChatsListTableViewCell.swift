//
//  ChatsListTableViewCell.swift
//  Web3MQDemo
//
//  Created by X Tommy on 2023/1/18.
//

import Kingfisher
import SnapKit
import UIComponentCore
import UIKit
import Web3MQ

public class ChatsListTableViewCell: ChatsItemTableViewCell {

    let avatarImageView = UIImageView()

    let titleLabel = UILabel()

    let contentLabel = UILabel()

    let dateLabel = UILabel()

    let unreadCountLabel = PaddingLabel()

    private let topBarStackView = UIStackView()
    private let bottomBarStackView = UIStackView()
    private let contentStackView = UIStackView()

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        return formatter
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureHierarchy()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        configureHierarchy()
    }

    public override func render(chatItem: ChannelItem) {
        switch chatItem.type {
        case .topic:
            avatarImageView.kf.setImage(
                with: chatItem.avatarURL,
                placeholder: UIImage(systemName: "ellipsis.vertical.bubble"),
                options: [.processor(RoundCornerImageProcessor(radius: Radius.point(0.1)))])
        case .user:
            avatarImageView.kf.setImage(
                with: chatItem.avatarURL,
                placeholder: UIImage(systemName: "person.circle.fill"),
                options: [.processor(RoundCornerImageProcessor(radius: Radius.point(0.5)))])
        case .group:
            avatarImageView.kf.setImage(
                with: chatItem.avatarURL,
                placeholder: UIImage(systemName: "person.3.fill"),
                options: [.processor(RoundCornerImageProcessor(radius: Radius.point(0.1)))])
        }

        titleLabel.text = chatItem.name ?? chatItem.topicId
        contentLabel.text = chatItem.lastMessageText

        if let lastMessageAt = chatItem.lastMessageAt {
            dateLabel.text = dateFormatter.string(from: lastMessageAt)
        } else {
            dateLabel.text = nil
        }

        if let badge = chatItem.badge,
            badge != "",
            badge != "0"
        {
            unreadCountLabel.text = badge
            unreadCountLabel.isHidden = false
        } else {
            unreadCountLabel.text = nil
            unreadCountLabel.isHidden = true
        }
    }
}

extension ChatsListTableViewCell {

    private func configureHierarchy() {

        avatarImageView.image = UIImage(systemName: "person.circle.fill")
        avatarImageView.backgroundColor = UIComponentConfiguration.shared.accentColor
        avatarImageView.contentMode = .scaleAspectFit
        contentView.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }

        contentStackView.axis = .vertical
        contentStackView.spacing = 0
        contentStackView.distribution = .fill
        contentView.addSubview(contentStackView)
        contentStackView.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(12)
            make.height.equalTo(58)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
        }

        bottomBarStackView.setContentCompressionResistancePriority(.required, for: .vertical)
        contentStackView.addArrangedSubview(topBarStackView)
        contentStackView.addArrangedSubview(bottomBarStackView)

        topBarStackView.axis = .horizontal
        topBarStackView.distribution = .fill

        bottomBarStackView.axis = .horizontal
        bottomBarStackView.distribution = .fill
        bottomBarStackView.spacing = 12

        titleLabel.textColor = UIColor.label
        titleLabel.font = UIFont.preferredFont(forTextStyle: .callout).bold()
        topBarStackView.addArrangedSubview(titleLabel)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        dateLabel.textAlignment = .right
        dateLabel.textColor = UIColor.tertiaryLabel
        dateLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        topBarStackView.addArrangedSubview(dateLabel)

        contentLabel.numberOfLines = 1
        contentLabel.textColor = UIColor.label
        contentLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        bottomBarStackView.addArrangedSubview(contentLabel)

        unreadCountLabel.layer.cornerRadius = 9
        unreadCountLabel.layer.masksToBounds = true
        unreadCountLabel.textColor = UIColor.white
        unreadCountLabel.backgroundColor = UIColor.systemRed
        unreadCountLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        unreadCountLabel.textInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        unreadCountLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        bottomBarStackView.addArrangedSubview(unreadCountLabel)
        unreadCountLabel.snp.makeConstraints { make in
            make.height.equalTo(18)
        }

    }

}
