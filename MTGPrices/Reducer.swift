//
//  Reducer.swift
//  MTGPrices
//
//  Created by Gabriele Pregadio on 11/28/16.
//  Copyright © 2016 Gabriele Pregadio. All rights reserved.
//

import Foundation
import ReSwift
import CoreData

func getInitialState() -> State {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var decks = [Deck]()
    
    let request = Deck.createFetchRequest()
    let sort = NSSortDescriptor(key: "name", ascending: true)
    request.sortDescriptors = [sort]
    
    do {
        decks = try appDelegate.persistentContainer.viewContext.fetch(request)
    } catch {
        print("core data decks fetch failed")
    }
    
    return State(decks: decks, cardResults: nil, parameters: nil, shouldSearch: false, isLoading: false, remainingRequests: nil, additionalCardResults: nil, isDownloadingImages: false)
}

struct StateReducer: Reducer {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func handleAction(action: Action, state: State?) -> State {
        var state = state ?? getInitialState()
        
        switch action {
        case let action as AddNewDeck:
            let deck = Deck(context: appDelegate.persistentContainer.viewContext)
            deck.name = action.name ?? "Untitled"
            deck.format = action.format
            deck.cards = []
            deck.id = UUID().uuidString
            appDelegate.saveContext()
            state.decks.append(deck)
            
        case let action as EditDeck:
            action.deck.name = action.name ?? action.deck.name
            action.deck.format = action.format ?? action.deck.format
            
        case let action as IncrementCardAmount:
            action.card.amount = action.card.amount + 1
            
        case let action as DecrementCardAmount:
            let request = Card.createFetchRequest()
            request.predicate = NSPredicate(format: "deck.id == %@ AND id == %@", action.deck.id, action.cardId)
            if let cards = try? appDelegate.persistentContainer.viewContext.fetch(request) {
                if !cards.isEmpty {
                    cards[0].amount = max(cards[0].amount - 1, 0)
                }
            } else {
                print("core data error fetching")
            }
            appDelegate.saveContext()
            
        case let action as UpdateCardReference:
            let request = Card.createFetchRequest()
            request.predicate = NSPredicate(format: "deck.id == %@ AND id == %@", action.deck.id, action.cardId)
            if let cards = try? appDelegate.persistentContainer.viewContext.fetch(request) {
                if !cards.isEmpty {
                    if cards[0].amount == 0 {
                        appDelegate.persistentContainer.viewContext.delete(cards[0])
                    }
                }
            }
            appDelegate.saveContext()
            
        case let action as DeleteDeck:
            let request = Card.createFetchRequest()
            request.predicate = NSPredicate(format: "deck.id == %@", action.deck.id)
            if let cards = try? appDelegate.persistentContainer.viewContext.fetch(request) {
                for card in cards {
                    appDelegate.persistentContainer.viewContext.delete(card)
                }
            } else {
                print("core data error- couldn't delete cards in the deck")
            }
            appDelegate.persistentContainer.viewContext.delete(action.deck)
            appDelegate.saveContext()
            state.decks.remove(at: action.index)
            
        case let action as AddCardResultToDeck:
            let request = Card.createFetchRequest()
            request.predicate = NSPredicate(format: "deck.id == %@ AND id == %@ AND isSideboard == false", action.deck.id, action.card.id)
            if let existingCards = try? appDelegate.persistentContainer.viewContext.fetch(request) {
                if !existingCards.isEmpty {
                    // Card exists, just update its amount.
                    let card = existingCards[0]
                    card.amount += 1
                } else {
                    // Create new card.
                    let card = Card(context: appDelegate.persistentContainer.viewContext)
                    if let imageUrl = action.card.imageUrl {
                        // Download image.
                        card.isDownloadingImage = true
                        state.isDownloadingImages = true
                        let url = URL(string: imageUrl)!
                        DispatchQueue.global(qos: .userInteractive).async {
                            if let data = try? Data(contentsOf: url) {
                                DispatchQueue.main.async {
                                    card.imageData = data as NSData
                                    card.isDownloadingImage = false
                                    store.dispatch(ImagesDownloadComplete())
                                }
                            } else {
                                DispatchQueue.main.async {
                                    card.isDownloadingImage = false
                                    store.dispatch(ImagesDownloadComplete())
                                }
                            }
                        }
                    } else {
                        card.isDownloadingImage = false
                    }
                    card.cmc = action.card.cmc
                    card.id = action.card.id
                    card.imageUrl = action.card.imageUrl
                    card.manaCost = action.card.manaCost
                    card.name = action.card.name
                    card.power = action.card.power
                    card.rarity = action.card.rarity
                    card.set = action.card.set
                    card.toughness = action.card.toughness
                    card.type = action.card.type
                    card.text = action.card.text
                    card.colors = action.card.colors?.joined(separator: ", ") ?? "Colorless"
                    card.names = action.card.names?.joined(separator: "|")
                    card.deck = action.deck
                    card.isSideboard = false
                    card.amount = 1
                }
            } else {
                print("core data error fetching")
            }
            appDelegate.saveContext()
            
        case let action as RemoveCardFromDeck:
            appDelegate.persistentContainer.viewContext.delete(action.card)
            appDelegate.saveContext()
            
        case let action as SearchForCards:
            state.cardResults = action.results
            state.parameters = action.parameters
            state.shouldSearch = false
            state.isLoading = action.isLoading
            state.remainingRequests = action.remainingRequests
            
        case let action as SearchForAdditionalCards:
            state.additionalCardResults = action.results
            state.isLoading = action.isLoading
            state.remainingRequests = action.remainingRequests
            
        case let action as SetNewParameters:
            state.parameters = action.parameters
            state.shouldSearch = true
            
        case is ImagesDownloadComplete:
            state.isDownloadingImages = false
            
        case let action as MoveCardToSideboard:
            action.card.isSideboard = true
            
        case let action as AddCardResultToSideboard:
            let request = Card.createFetchRequest()
            request.predicate = NSPredicate(format: "deck.id == %@ AND id == %@ AND isSideboard == true", action.deck.id, action.card.id)
            if let existingCards = try? appDelegate.persistentContainer.viewContext.fetch(request) {
                if !existingCards.isEmpty {
                    // Card exists, just update its amount.
                    let card = existingCards[0]
                    card.amount += 1
                } else {
                    // Create new card.
                    let card = Card(context: appDelegate.persistentContainer.viewContext)
                    if let imageUrl = action.card.imageUrl {
                        // Download image.
                        card.isDownloadingImage = true
                        state.isDownloadingImages = true
                        let url = URL(string: imageUrl)!
                        DispatchQueue.global(qos: .userInteractive).async {
                            if let data = try? Data(contentsOf: url) {
                                DispatchQueue.main.async {
                                    card.imageData = data as NSData
                                    card.isDownloadingImage = false
                                    store.dispatch(ImagesDownloadComplete())
                                }
                            } else {
                                DispatchQueue.main.async {
                                    card.isDownloadingImage = false
                                    store.dispatch(ImagesDownloadComplete())
                                }
                            }
                        }
                    } else {
                        card.isDownloadingImage = false
                    }
                    card.cmc = action.card.cmc
                    card.id = action.card.id
                    card.imageUrl = action.card.imageUrl
                    card.manaCost = action.card.manaCost
                    card.name = action.card.name
                    card.power = action.card.power
                    card.rarity = action.card.rarity
                    card.set = action.card.set
                    card.toughness = action.card.toughness
                    card.type = action.card.type
                    card.text = action.card.text
                    card.colors = action.card.colors?.joined(separator: ", ") ?? "Colorless"
                    card.names = action.card.names?.joined(separator: "|")
                    card.deck = action.deck
                    card.isSideboard = true
                    card.amount = 1
                }
            }

            
        default:
            break
        }
        
        return state
    }
    
}
