//
//  CardCollectionViewCell.swift
//  Match App
//
//  Created by Melissa  Garrett on 10/2/19.
//  Copyright © 2019 MelissaGarrett. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    @IBOutlet var frontImageView: UIImageView!
    @IBOutlet var backImageView: UIImageView!
    
    var card: Card?
    
    func setCard(_ card: Card) {
        self.card = card
        
        // To aid reusable cells when scrolling back and forth in the collection view
        if card.isMatched { // make image views invisible if card has been matched
            backImageView.alpha = 0
            frontImageView.alpha = 0
            
            return
        } else { // make image views visible if card hasn't been matched
            backImageView.alpha = 1
            frontImageView.alpha = 1
        }
        
        frontImageView.image = UIImage(named: card.imageName)
        
        // To make sure the correct image is on top in the displayed cell
        // (This is to aid reusable cells when scrolling back and forth in the collection view)
        if card.isFlipped {
            UIView.transition(from: backImageView, to: frontImageView, duration: 0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        } else {
            UIView.transition(from: frontImageView, to: backImageView, duration: 0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        }
    }
    
    // Flip card from back image to front image
    func flipFront() {
        UIView.transition(from: backImageView, to: frontImageView, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
    }
    
    // Flip card from front image to back image
    func flipBack() {
        // Add a delay of 1/2 a second before flipping the cards back (after no match was found)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        }
    }
    
    // Remove both image views from being visible
    func remove() {
        backImageView.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {                    self.frontImageView.alpha = 0
        }, completion: nil)
    }
}
