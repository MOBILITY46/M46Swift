//
//  Dialog.swift
//  M46SwiftyDialog
//
//  Created by David Jobe on 2019-05-17.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import UIKit

// TODO: Add possibility to process and follow links in the content text

public class Dialog : UIView, Modal {
    
    public var background = UIView()
    public var dialogView = UIView()
    public var parent: UIViewController
    public var margin: CGFloat = 16
    public var closeAction: (() -> Void)?
    
    public convenience init(parent: UIViewController, title: String, text: String, footer: UILabel?) {
        self.init(frame: UIScreen.main.bounds)
        initialize(parent, title, text, footer)
    }
    
    override init(frame: CGRect) {
        self.parent = UIViewController()
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize(_ parent: UIViewController, _ title: String, _ text: String, _ footer: UILabel?) {
        self.parent = parent
        dialogView.clipsToBounds = true
        
        background.frame = frame
        background.backgroundColor = UIColor.black
        background.alpha = 0.6
        background.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didClose)))
        addSubview(background)
        
        let dialogViewWidth = UIScreen.main.bounds.width - 32
        
        let titleLabel = UILabel(frame: CGRect(x: margin, y: margin, width: dialogViewWidth - 40, height: 30))
        titleLabel.text = title
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        titleLabel.font = titleLabel.font.withSize(20)
        dialogView.addSubview(titleLabel)

        let textView = UILabel()
        textView.numberOfLines = 0
        textView.lineBreakMode = .byWordWrapping
        textView.text = text
        textView.textColor = .darkGray
        textView.frame.origin = CGPoint(x: margin, y: titleLabel.frame.height + (margin * 2))
        textView.frame.size = CGSize(width: dialogViewWidth - (margin * 2), height: dialogViewWidth - (margin * 2))
        textView.sizeToFit()
        dialogView.addSubview(textView)

        let dialogViewHeight = titleLabel.frame.height + margin + textView.frame.height + 220
        
        let closeButton = UIButton(frame: CGRect(x: margin, y: dialogViewHeight - 30 - margin, width: dialogViewWidth - (margin * 2), height: 30))
        closeButton.backgroundColor = .systemBlue
        closeButton.setTitle("OK", for: .normal)
        closeButton.addTarget(self, action: #selector(didClose), for: .touchUpInside)
        closeButton.layer.cornerRadius = 6
        dialogView.addSubview(closeButton)
        
        footer?.frame.origin = CGPoint(x: margin, y: closeButton.frame.origin.y - (margin * 2))
        footer?.frame.size = CGSize(width: dialogViewWidth - (margin * 2), height: 30)
        footer?.textColor = .gray
        footer?.font = footer?.font.withSize(12)
        footer?.textAlignment = .left
        
        if let footer = footer {
            dialogView.addSubview(footer)
        }

        dialogView.frame.origin = CGPoint(x: 32, y: frame.height)
        dialogView.frame.size = CGSize(width: dialogViewWidth, height: dialogViewHeight)
        dialogView.backgroundColor = UIColor.white
        dialogView.layer.cornerRadius = 6
        addSubview(dialogView)
    }
    
    @objc func didClose() {
        dismiss(animated: true)
        self.closeAction?()
    }

}
