//
//  EmojiArtViewController.swift
//  MyEmojiArt
//
//  Created by Peter on 31/01/2019.
//  Copyright © 2019 Excellence. All rights reserved.
//

import UIKit

class EmojiArtViewController: UIViewController, UIDropInteractionDelegate, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{

    
    // MARK: - @IBOutlets & @IBActions
    @IBOutlet weak var dropZone: UIView!{
        didSet{
            dropZone.addInteraction(UIDropInteraction(delegate: self))
        }
    }
    
    
    var imageFetcher: ImageFetcher!

    
    // MARK: - ScrollView
    @IBOutlet weak var scrollViewWidth: NSLayoutConstraint!
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    var emojiArtView = EmojiArtView()
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.minimumZoomScale = 0.1
            
            scrollView.maximumZoomScale = 5.0
            scrollView.delegate = self
            scrollView.addSubview(emojiArtView)
        }
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollViewWidth.constant = scrollView.contentSize.width
        scrollViewHeight.constant = scrollView.contentSize.height
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return emojiArtView
    }
    
    var emojiArtViewBackgroundImage: UIImage? {
        get{
            return emojiArtView.backgroundImage
        }
        set{
            scrollView.zoomScale = 1.0
            emojiArtView.backgroundImage = newValue
            let size = newValue?.size ?? CGSize.zero
            emojiArtView.frame = CGRect(origin: CGPoint.zero, size: size)
            scrollView?.contentSize = size
            scrollViewWidth?.constant = size.width
            scrollViewHeight?.constant = size.height
            if let dropZone = self.dropZone, size.width > 0 , size.height > 0 {
                scrollView?.zoomScale = max(dropZone.bounds.size.width / size.width, dropZone.bounds.size.height / size.height )
            }
        }
    }
    
    // MARK: - Drag and Drop
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        spinner.startAnimating()
        self.imageFetcher = ImageFetcher() { (url, image) in
            DispatchQueue.main.async{
              self.emojiArtViewBackgroundImage = image
                self.spinner.stopAnimating()
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
    
    
    // MARK: - Collection View
    
    var emojis = "😇🏹🥎🕊🐒🦸🏼‍♀️🤫🛹📕♥️〒".map { String($0)}
    
    @IBOutlet weak var emojiCollectionView: UICollectionView! {
        didSet{
            emojiCollectionView.delegate = self
            emojiCollectionView.dataSource = self
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath)
        
        return cell
    }
    
   
    
   
 
}

