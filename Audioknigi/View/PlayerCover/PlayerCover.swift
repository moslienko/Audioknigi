//
//  PlayerCover.swift
//  Audioknigi
//
//  Created by Pavel Moslienko on 15/12/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import UIKit

class PlayerCover: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var backgroundCover: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("PlayerCover", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

}
