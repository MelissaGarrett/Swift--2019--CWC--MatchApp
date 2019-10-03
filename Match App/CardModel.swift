//
//  CardModel.swift
//  Match App
//
//  Created by Melissa  Garrett on 10/2/19.
//  Copyright © 2019 MelissaGarrett. All rights reserved.
//

import Foundation

class CardModel {
    func getCards() -> [Card] {
        var generatedCardsArray = [Card]()
        
        // create 8 pairs of cards, 1-13
        for _ in 1...8 {
            let randomNumber = arc4random_uniform(13) + 1
            
            let cardOne = Card()
            cardOne.imageName = "card\(randomNumber)"
            generatedCardsArray.append(cardOne)
            
            let cardTwo = Card()
            cardTwo.imageName = "card\(randomNumber)"
            generatedCardsArray.append(cardTwo)
        }
        
        return generatedCardsArray
    }
}
