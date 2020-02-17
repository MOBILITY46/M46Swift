//
//  Dialog.swift
//  M46SwiftyDialog
//
//  Created by David Jobe on 2019-05-17.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import UIKit

// TODO: Add possibility to process and follow links in the content text

class Dialog : UIView, Modal {
    
    var background = UIView()
    var dialogView = UIView()
    var parent: UIViewController
    var dismissable: Bool = false
    
    convenience init(parent: UIViewController, title: String, text: String) {
        self.init(frame: UIScreen.main.bounds)
        initialize(parent, title, text, nil)
    }
    
    convenience init(parent: UIViewController, title: String, text: String, closeIcon: UIImage) {
        self.init(frame: UIScreen.main.bounds)
        initialize(parent, title, text, closeIcon)
    }
    
    override init(frame: CGRect) {
        self.parent = UIViewController()
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize(_ parent: UIViewController, _ title: String, _ text: String, _ closeIcon: UIImage?) {
        self.parent = parent
        dialogView.clipsToBounds = true
        
        background.frame = frame
        background.backgroundColor = UIColor.black
        background.alpha = 0.6
        if dismissable {
            background.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didClose)))
        }
        addSubview(background)
        
        let dialogViewWidth = UIScreen.main.bounds.width - 32
        
        let titleLabel = UILabel(frame: CGRect(x: 8, y: 8, width: dialogViewWidth - 40, height: 30))
        titleLabel.text = title
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        dialogView.addSubview(titleLabel)
        
        if dismissable {
            if let icon = closeIcon {
                let closeButton = UIButton(frame: CGRect(x: dialogViewWidth - 32, y: 8, width: 24, height: 30))
                closeButton.setImage(icon, for: .normal)
                closeButton.addTarget(self, action: #selector(didClose), for: .touchUpInside)
                dialogView.addSubview(closeButton)
            }
        }

        let line = UIView()
        line.frame.origin = CGPoint(x: 10, y: titleLabel.frame.height + 8)
        line.frame.size = CGSize(width: dialogViewWidth - 20, height: 1)
        line.backgroundColor = .systemBlue
        dialogView.addSubview(line)
        
        let textView = UILabel()
        textView.numberOfLines = 0
        textView.lineBreakMode = .byWordWrapping
        textView.text = text
        textView.textColor = .darkGray
        textView.frame.origin = CGPoint(x: 8, y: line.frame.height + line.frame.origin.y + 8)
        textView.frame.size = CGSize(width: dialogViewWidth - 16, height: dialogViewWidth - 16)
        textView.sizeToFit()
        dialogView.addSubview(textView)

        let dialogViewHeight = titleLabel.frame.height + 8 + line.frame.height + 8 + textView.frame.height + 8
        
        dialogView.frame.origin = CGPoint(x: 32, y: frame.height)
        dialogView.frame.size = CGSize(width: dialogViewWidth, height: dialogViewHeight)
        dialogView.backgroundColor = UIColor.white
        dialogView.layer.cornerRadius = 6
        addSubview(dialogView)
    }
    
    @objc func didClose() {
        dismiss(animated: true)
    }

}
