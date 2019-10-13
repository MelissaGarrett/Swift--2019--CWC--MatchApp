//
//  ViewController.swift
//  Match App
//
//  Created by Melissa  Garrett on 10/2/19.
//  Copyright © 2019 MelissaGarrett. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var timerLabel: UILabel!
    
    @IBOutlet var collectionView: UICollectionView!
    
    var model = CardModel()
    var cardArray = [Card]()
    
    var firstFlippedCardIndex: IndexPath?
    
    var timer: Timer?
    var milliseconds: Float = 30000 // 30 seconds
    
    var alertTitle = ""
    var message = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cardArray = model.getCards()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Create timer object; Timer calls timerElapsed() every millisecond
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        
        // So timer doesn't stop when the user scrolls the app
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SoundManager.playSound(.shuffle)
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
        // To prevent user from selecting cards if time has run out
        if milliseconds <= 0 {
            return
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        let card = cardArray[indexPath.row]
        
        if !card.isFlipped && !card.isMatched {
            cell.flipFront()
            SoundManager.playSound(.flip)
            
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
            SoundManager.playSound(.match)
            
            firstCard.isMatched = true
            secondCard.isMatched = true
            
            firstCardCell?.remove()
            secondCardCell?.remove()
            
            checkGameEnded()
        } else {
            SoundManager.playSound(.nomatch)
            
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
    
    func checkGameEnded() {
        var hasWon = true
        
        for card in cardArray {
            if card.isMatched == false { // not all cards have been matched
                hasWon = false
                break
            }
        }
        
        if hasWon {
            if milliseconds > 0 {
                timer?.invalidate()
            }
            
            alertTitle = "Congratulations!"
            message = "You've won"
        } else {
            if milliseconds > 0 { // still some time left
                return
            }
            
            alertTitle = "Game Over!"
            message = "You've lost"
        }
        
        showAlert(alertTitle, message)
    }
    
    // Show alert when game is over
    func showAlert(_ alertTitle: String, _ message: String) {
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    // Update the UI label with every tick of the timer
    @objc func timerElapsed() {
        milliseconds -= 1
        
        // Convert to seconds
        let seconds = String(format: "%.2f", milliseconds / 1000)
        timerLabel.text = "Time Remaining: \(seconds)"
        
        // Stop the timer
        if milliseconds <= 0 {
            timer?.invalidate()
            timerLabel.textColor = UIColor.red
            
            checkGameEnded()
        }
    }
}

