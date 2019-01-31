//
//  EmojiArtViewController.swift
//  MyEmojiArt
//
//  Created by Peter on 31/01/2019.
//  Copyright © 2019 Excellence. All rights reserved.
//

import UIKit

class EmojiArtViewController: UIViewController, UIDropInteractionDelegate
{

    
    // MARK: - @IBOutlets & @IBActions
    @IBOutlet weak var dropZone: UIView!{
        didSet{
            dropZone.addInteraction(UIDropInteraction(delegate: self))
        }
    }
    
    @IBOutlet weak var emojiArtView: EmojiArtView!
     var imageFetcher: ImageFetcher!
    
    
    // MARK: - Drag and Drop
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        self.imageFetcher = ImageFetcher() { (url, image) in
            DispatchQueue.main.async{
              self.emojiArtView.backgroundImage = image
            }
            

        }
        
        session.loadObjects(ofClass: NSURL.self, completion: { nsurls in
            if let url = nsurls.first as? URL {
                self.imageFetcher.fetch(url)
            }
            
        })
            
        session.loadObjects(ofClass: UIImage.self, completion: {images in
            if let image = images.first as? UIImage {
                self.imageFetcher.backup = image
            }
        })
    }
    
   
 
}

