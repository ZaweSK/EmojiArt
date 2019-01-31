//
//  EmojiArtView.swift
//  MyEmojiArt
//
//  Created by Peter on 31/01/2019.
//  Copyright © 2019 Excellence. All rights reserved.
//

import UIKit

class EmojiArtView: UIView {

    var backgroundImage: UIImage? {
        didSet{
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        backgroundImage?.draw(in: bounds)
    }

}
