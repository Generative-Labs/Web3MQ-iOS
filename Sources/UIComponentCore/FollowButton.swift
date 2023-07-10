//
//  FollowButton.swift
//
//
//  Created by X Tommy on 2023/2/3.
//

import UIKit

///
public class FollowButton: UIButton {

    ///
    public var isFollowing: Bool = false {
        didSet {
            onIsFollowingChanged(isFollowing: isFollowing)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureHierarchy()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        configureHierarchy()
    }

    private func onIsFollowingChanged(isFollowing: Bool) {
        if isFollowing {
            setTitleColor(UIColor.label, for: .normal)
            setTitle("Following", for: .normal)
            backgroundColor = .white
            layer.borderWidth = 1
            layer.borderColor = UIColor.secondarySystemFill.cgColor
        } else {
            setTitleColor(UIColor.white, for: .normal)
            setTitle("Follow", for: .normal)
            backgroundColor = tintColor
            layer.borderWidth = 0
        }
    }

}

extension FollowButton {

    private func configureHierarchy() {
        setTitle("Follow", for: .normal)
        backgroundColor = tintColor

        titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        layer.cornerRadius = 6
        layer.masksToBounds = true

        if #available(iOS 15.0, *) {
            var theConfiguration = UIButton.Configuration.plain()
            theConfiguration.contentInsets = NSDirectionalEdgeInsets(
                top: 6, leading: 16, bottom: 6, trailing: 16)
            configuration = theConfiguration
        } else {
            contentEdgeInsets = UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16)
        }
    }

}
