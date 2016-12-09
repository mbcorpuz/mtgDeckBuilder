//
//  Actions.swift
//  MTGPrices
//
//  Created by Gabriele Pregadio on 11/28/16.
//  Copyright © 2016 Gabriele Pregadio. All rights reserved.
//

import Foundation
import ReSwift
import Alamofire

struct AddNewDeck: Action {
    let name: String?
    let format: String!
}

struct EditDeck: Action {
    let deck: Deck
    let name: String?
    let format: String?
}

struct IncrementCardAmount: Action {
    let card: Card
}

struct DecrementCardAmount: Action {
    let deck: Deck
    let cardId: String
}

struct UpdateCardReference: Action {
    let deck: Deck
    let cardId: String
}

struct DeleteDeck: Action {
    let deck: Deck
    let index: Int
}

struct AddCardResultToDeck: Action {
    let deck: Deck
    let card: CardResult
}

struct RemoveCardFromDeck: Action {
    let card: Card
}

struct SetNewParameters: Action {
    let parameters: [String: Any]
}

struct SearchForCards: Action {
    let results: Result<[CardResult]>?
    let parameters: [String: Any]
    let isLoading: Bool
    let remainingRequests: Int?
}

struct SearchForAdditionalCards: Action {
    let results: Result<[CardResult]>?
    let isLoading: Bool
    let remainingRequests: Int?
}

struct ImagesDownloadComplete: Action {
    
}
