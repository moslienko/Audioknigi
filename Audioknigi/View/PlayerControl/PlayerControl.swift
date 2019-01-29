//
//  PlayerControl.swift
//  Audioknigi
//
//  Created by Pavel Moslienko on 15/12/2018.
//  Copyright © 2018 Pavel Moslienko. All rights reserved.
//

import UIKit

class PlayerControl: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var playerSlider: UISlider!
    @IBOutlet weak var hasLeftTimeLabel: UILabel!
    @IBOutlet weak var leftTimeLabel: UILabel!
    
    @IBOutlet weak var nameBook: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nameCharter: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("PlayerControl", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
}
