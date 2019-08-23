//
//  Accordion.swift
//  M46SwiftyAccordion
//
//  Created by David Jobe on 2019-04-26.
//  Copyright © 2019 se.mobility46. All rights reserved.
//

import UIKit



class Accordion : UIView {
    
    enum State {
        case open
        case closed
    }
    
    let title: String
    let body: String

    let pane: UIButton
    let content: UIView
    let contentBody: UILabel = UILabel()

    var state: State = .closed
    
    public var contentPadding: CGFloat = 10

    public required init?(coder aDecoder: NSCoder) {
        self.title = ""
        self.body = ""
        self.pane = UIButton()
        self.content = UIView()
        super.init(coder: aDecoder)
        initialize()
    }

    public init(title: String, body: String) {
        self.title = title
        self.body = body
        self.pane = UIButton()
        self.content = UIView()
        super.init(frame: .zero)
        initialize()
    }

    func initialize() {
        backgroundColor = .red
        pane.backgroundColor = .blue
        content.backgroundColor = .cyan
        contentBody.backgroundColor = .purple
        pane.setTitle(title, for: .normal)

        pane.addTarget(self, action: #selector(toggle), for: .touchUpInside)

        content.clipsToBounds = true

        contentBody.text = body

        addSubview(pane)
        addSubview(content)
        
        content.addSubview(contentBody)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configure()
    }
    
    @objc func toggle() {
        state = state == .open ? .closed : .open
        let height = expandedHeight

        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
            if self.state == .open {
                self.content.frame.size.height += height
            } else {
                self.content.frame.size.height -= height
            }
        })
    }
    
}

extension Accordion {
    
    fileprivate var paneSize: CGSize {
        guard let superview = superview else { return .zero }
        return CGSize(width: superview.frame.width, height: 50)
    }
    
    fileprivate var contentSize: CGSize {
        guard let superview = superview else { return .zero }
        return CGSize(width: superview.frame.width, height: 0)
    }
    
    fileprivate var expandedHeight: CGFloat {
        return contentBody.frame.height + contentPadding
    }
    
    fileprivate func configure() {
        frame.size = paneSize
        pane.frame.size = paneSize
        content.frame.size = contentSize
        
        content.translatesAutoresizingMaskIntoConstraints = false
        contentBody.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            content.topAnchor.constraint(equalTo: pane.bottomAnchor),
            contentBody.topAnchor.constraint(equalTo: content.topAnchor, constant: contentPadding),
            contentBody.leftAnchor.constraint(equalTo: content.leftAnchor, constant: contentPadding)
            ])
    }
}
