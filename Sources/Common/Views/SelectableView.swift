//
//  SelectableView.swift
//  MyApp
//
//  Created by Manh Pham on 8/16/21.
//

import Foundation

final class SelectableView: UIButton {
    
    var onClick: (Int) -> Void = { _ in }
    
    var isSelect = false {
        didSet {
            if isSelect {
                setImage(Asset.Assets.icTick.image.tint(with: Asset.Colors.main.color).resized(toSize: CGSize(width: 13, height: 10)), for: .normal)
                setTitleColor(Asset.Colors.main.color, for: .normal)
                titleEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 0)
            } else {
                setImage(nil, for: .normal)
                setTitleColor(Asset.Colors._00000054.color, for: .normal)
                titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
            }
        }
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentHorizontalAlignment = .leading
        addTarget(self, action: #selector(onClick(sender:)), for: .touchUpInside)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var title: String = "" {
        didSet {
            setTitle(title, for: .normal)
        }
    }
    
    @objc
    private func onClick(sender: UIButton) {
        guard let superview = superview as? UIStackView else { return }
        superview.subviews
            .compactMap { $0 as? SelectableView }
            .filter { $0.tag != tag }
            .forEach { $0.isSelect = false }
        isSelect = true
        onClick(sender.tag)
    }
    
}
