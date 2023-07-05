//
//  SignProposalPresentView.swift
//
//
//  Created by X Tommy on 2023/1/11.
//

import Kingfisher
import Presentable
import UIKit

open class ProposalPresentView: PresentableView {

    open override var transition: PresentableTransitionType {
        return .bottom
    }

    open override var shouldDismissIfTappedBlankArea: Bool {
        false
    }

    public var accountAddress: String? {
        didSet {
            accountBar.address = "Account(\(accountAddress ?? "")"
        }
    }

    public var accountAvatarUrl: String? {
        didSet {
            accountBar.avatarUrl = accountAvatarUrl
        }
    }

    public var avatarUrl: String? {
        didSet {
            if let avatarUrl {
                titleImageView.kf.setImage(with: URL(string: avatarUrl))
            } else {
                titleImageView.image = nil
            }
        }
    }

    public var websiteUrl: String? {
        didSet {
            websiteLabel.text = websiteUrl
        }
    }

    open var contentView: UIView?

    public var confirmButtonTitle: String? {
        didSet {
            confirmButton.setTitle(confirmButtonTitle, for: .normal)
        }
    }

    public var cancelButtonTitle: String? {
        didSet {
            cancelButton.setTitle(cancelButtonTitle, for: .normal)
        }
    }

    public var title: String? {
        didSet {
            titleLabel.text = title
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        configureHierarchy()
        bindEvents()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let titleImageView = UIImageView()
    private let websiteStackView = UIStackView()
    private let websiteImageView = UIImageView(image: UIImage(systemName: "lock.fill"))
    private let websiteLabel = UILabel()

    private let titleLabel = UILabel()
    private let accountBar = AccountBar()
    private let stackView = UIStackView()
    private let cancelButton = UIButton()
    private let confirmButton = UIButton()

    private var continuation: UnsafeContinuation<Bool, Never>?

    /// return true or false
    public func asyncPresent() async -> Bool {
        self.present()
        return await withUnsafeContinuation({ [weak self] continuation in
            self?.continuation = continuation
        })
    }

}

extension ProposalPresentView {

    private func configureHierarchy() {

        backgroundColor = UIColor.secondarySystemBackground
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.cornerRadius = 16
        layer.masksToBounds = true

        titleImageView.layer.cornerRadius = 32
        titleLabel.layer.masksToBounds = true
        titleImageView.backgroundColor = UIColor.accent
        titleImageView.contentMode = .scaleAspectFill
        addSubview(titleImageView)
        titleImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(16)
            make.width.height.equalTo(64)
        }

        websiteStackView.axis = .horizontal
        websiteStackView.spacing = 8.4
        addSubview(websiteStackView)
        websiteStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleImageView.snp.bottom).offset(12)
        }

        websiteImageView.contentMode = .scaleAspectFit
        websiteStackView.addArrangedSubview(websiteImageView)
        websiteImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 12, height: 12))
        }

        websiteLabel.textColor = UIColor.label
        websiteLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        websiteStackView.addArrangedSubview(websiteLabel)

        titleLabel.text = "Sign this message？"
        titleLabel.textColor = UIColor.label
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(websiteStackView.snp.bottom).offset(16)
        }

        addSubview(accountBar)
        accountBar.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.height.equalTo(66)
        }

        if let contentView {
            addSubview(contentView)
            contentView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(16)
                make.right.equalToSuperview().offset(-16)
                make.top.equalTo(accountBar.snp.bottom).offset(16)
            }

            stackView.axis = .horizontal
            stackView.spacing = 32
            stackView.distribution = .fillEqually
            addSubview(stackView)
            stackView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(16)
                make.right.equalToSuperview().offset(-16)
                make.top.equalTo(contentView.snp.bottom).offset(16)
                make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-32)
            }

            cancelButton.layer.cornerRadius = 8
            cancelButton.layer.borderWidth = 1
            cancelButton.layer.borderColor = UIColor.border.cgColor
            cancelButton.backgroundColor = UIColor.tertiarySystemBackground
            cancelButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
            cancelButton.setTitle("Cancel", for: .normal)
            cancelButton.setTitleColor(UIColor.label, for: .normal)
            stackView.addArrangedSubview(cancelButton)
            cancelButton.snp.makeConstraints { make in
                make.height.equalTo(40)
            }

            confirmButton.layer.cornerRadius = 8
            confirmButton.backgroundColor = UIColor.accent
            confirmButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
            confirmButton.setTitle("Sign", for: .normal)
            confirmButton.setTitleColor(UIColor.white, for: .normal)
            stackView.addArrangedSubview(confirmButton)
            confirmButton.snp.makeConstraints { make in
                make.height.equalTo(40)
            }

            stackView.addArrangedSubview(cancelButton)
            stackView.addArrangedSubview(confirmButton)
        }
    }

    private func bindEvents() {
        cancelButton.addTarget(self, action: #selector(onCanceled), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(onConfirmed), for: .touchUpInside)
    }

    @objc
    private func onCanceled() {
        continuation?.resume(returning: false)
        dismiss()
    }

    @objc
    private func onConfirmed() {
        continuation?.resume(returning: true)
        dismiss()
    }

}
