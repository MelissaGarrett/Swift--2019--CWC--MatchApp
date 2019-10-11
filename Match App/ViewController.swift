//
//  ViewController.swift
//  Match App
//
//  Created by Melissa  Garrett on 10/2/19.
//  Copyright © 2019 MelissaGarrett. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet var collectionView: UICollectionView!
    
    var model = CardModel()
    var cardArray = [Card]()
    
    var firstFlippedCardIndex: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cardArray = model.getCards()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        // Get the current card and set its front image on the UI
        let card = cardArray[indexPath.row]
        cell.setCard(card)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        let card = cardArray[indexPath.row]
        
        if !card.isFlipped && !card.isMatched {
            cell.flipFront()
            card.isFlipped = true
            
            // Determine if this is the 1st or 2nd card that was flipped
            if firstFlippedCardIndex == nil {
                firstFlippedCardIndex = indexPath
            } else {
                checkForMatches(indexPath)
            }
        }
    }
    
    func checkForMatches(_ secondFlippedCardIndex: IndexPath) {
        let firstCardCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let secondCardCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        let firstCard = cardArray[firstFlippedCardIndex!.row]
        let secondCard = cardArray[secondFlippedCardIndex.row]
        
        if firstCard.imageName == secondCard.imageName {
            firstCard.isMatched = true
            secondCard.isMatched = true
            
            firstCardCell?.remove()
            secondCardCell?.remove()
        } else {
            firstCard.isFlipped = false
            secondCard.isFlipped = false
            
            firstCardCell?.flipBack()
            secondCardCell?.flipBack()
        }
        
        // Reload the cell of the 1st card if it's nil (a match was made)
        // (To aid reusable cells when scrolling)
        if firstCardCell == nil {
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        
        // Reset so user can start again with two more cards
        firstFlippedCardIndex = nil
    }

}

