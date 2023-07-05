//
//  NotificationBaseTableViewCell.swift
//  
//
//  Created by X Tommy on 2023/1/16.
//

import UIKit
import SnapKit
import UIComponentCore
import Kingfisher

class NotificationBaseTableViewCell: NotificationItemTableViewCell {
    
    let avatarImageView = UIImageView()
    
    let titleLabel = UILabel()
    
    let contentLabel = UILabel()
    
    let dateLabel = UILabel()
    
    open var accessoryButton: UIButton? {
        return nil
    }
    
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
    
    var notification: Notification?
    
    override func render(notification: Notification) {
        self.notification = notification
        
        titleLabel.text = notification.title
        contentLabel.text = notification.content
        let dateString = dateFormatter.string(from: Date(timeIntervalSince1970: Double(notification.timestamp) / 1000))
        dateLabel.text = dateString
    }

}

extension NotificationBaseTableViewCell {
    
    private func configureHierarchy() {
        
        avatarImageView.image = UIImage(systemName: "person.circle.fill")
        avatarImageView.backgroundColor = UIComponentConfiguration.shared.accentColor
        avatarImageView.contentMode = .scaleAspectFill
        contentView.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        contentStackView.distribution = .fillProportionally
        contentStackView.axis = .vertical
        contentView.addSubview(contentStackView)
        contentStackView.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(12)
            make.height.equalTo(58)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
        }
        
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
        
        contentLabel.numberOfLines = 2
        contentLabel.textColor = UIColor.secondaryLabel
        contentLabel.font =  UIFont.preferredFont(forTextStyle: .caption1)
        bottomBarStackView.addArrangedSubview(contentLabel)
        
        if let accessoryButton {
            accessoryButton.setContentHuggingPriority(.required, for: .horizontal)
            bottomBarStackView.addArrangedSubview(accessoryButton)
        }
        
    }
    
}
