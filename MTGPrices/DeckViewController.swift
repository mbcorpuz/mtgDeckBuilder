//
//  DeckViewController.swift
//  MTGPrices
//
//  Created by Gabriele Pregadio on 11/29/16.
//  Copyright © 2016 Gabriele Pregadio. All rights reserved.
//

import UIKit
import ReSwift

class DeckViewController: UIViewController, StoreSubscriber {

    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Stored Properties
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var deck: Deck!
    var cards = [Card]()
    
    var creatures: [Card] {
        return cards.filter { $0.type.contains("Creature") && !$0.type.contains("Land") }.sorted {
            if $0.0.cmc.cmcToInt != $0.1.cmc.cmcToInt {
                return $0.0.cmc.cmcToInt < $0.1.cmc.cmcToInt
            } else {
                return $0.0.name < $0.1.name
            }
        }
    }
    
    var spells: [Card] {
        return cards.filter { !$0.type.contains("Creature") && !$0.type.contains("Land") }.sorted {
            if $0.0.cmc.cmcToInt != $0.1.cmc.cmcToInt {
                return $0.0.cmc.cmcToInt < $0.1.cmc.cmcToInt
            } else {
                return $0.0.name < $0.1.name
            }
        }
    }
    
    var lands: [Card] {
        return cards.filter { $0.type.contains("Land") }.sorted { $0.0.name < $0.1.name }
    }
    
    // MARK: - View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = deck.name
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Deck", style: .plain, target: nil, action: nil)
        
        fetchCards()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self)
        fetchCards()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Methods
    
    func fetchCards() {
        let cardRequest = Card.createFetchRequest()
        cardRequest.predicate = NSPredicate(format: "deck.id == %@", deck.id)
        if let cards = try? appDelegate.persistentContainer.viewContext.fetch(cardRequest) {
            self.cards = cards
            tableView.reloadData()
        }
    }
    
    
    // MARK: - StoreSubscriber Delegate Methods
    
    func newState(state: State) {
        fetchCards()
    }
    
}
