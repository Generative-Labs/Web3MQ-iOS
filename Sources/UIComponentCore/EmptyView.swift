//
//  EmptyView.swift
//  
//
//  Created by X Tommy on 2023/1/17.
//

import UIKit
import SnapKit

public class EmptyView: UIView {
    
    private lazy var imageView = UIImageView()
    private lazy var titleLabel = UILabel()
    
    private lazy var stackView = UIStackView()
    
    public var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    public var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    public convenience init(image: UIImage? = nil, title: String? = nil) {
        self.init()
        self.image = image
        self.title = title
        imageView.image = image
        titleLabel.text = title
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureHierarchy()
    }
    
    public func display() {
        isHidden = false
    }
    
    public func hide() {
        isHidden = true
    }
    
}

extension EmptyView {
    
    private func configureHierarchy() {
               
        hide()
        
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.axis = .vertical
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.tintColor = UIColor.systemGray
        imageView.contentMode = .scaleAspectFill
        stackView.addArrangedSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.width.equalTo(34)
            make.height.equalTo(40)
        }
        
        titleLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        titleLabel.textColor = UIColor.placeholderText
        stackView.addArrangedSubview(titleLabel)
        
    }
}


