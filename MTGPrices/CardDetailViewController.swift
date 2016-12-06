//
//  CardDetailViewController.swift
//  MTGPrices
//
//  Created by Gabriele Pregadio on 12/5/16.
//  Copyright © 2016 Gabriele Pregadio. All rights reserved.
//

import UIKit
import ReSwift

/// This view controller is used to display both `Card` and `CardResult` types based on its stored property `shouldUseResult`.
class CardDetailViewController: UIViewController, StoreSubscriber {

    // MARK: - Properties
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    /// Used to determine whether the data source should be of type `CardResult` (true) or `Card` (false).
    var shouldUseResult = true
    var cardResult: CardResult?
    var card: Card?
    var deck: Deck!
    
    // Storing these properties in case the card is removed from the deck, in which case its reference would be illegal.
    var cardName = ""
    var cost: String?
    var type = ""
    var text: String?
    var imageStringUrl: String?
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var imageUnavailableLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var deckCountLabel: UILabel!
    
    
    // MARK: - IBActions
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        if shouldUseResult {
            store.dispatch(AddCardToDeck(deck: deck, card: cardResult!))
        } else {
            store.dispatch(IncrementCardAmount(card: card!))
        }
    }
    
    @IBAction func removeButtonPressed(_ sender: UIButton) {
        if shouldUseResult {
            store.dispatch(DecrementCardAmount(deck: deck, cardId: cardResult!.id))
        } else {
            store.dispatch(DecrementCardAmount(deck: deck, cardId: card!.id))
        }
    }
    
    // MARK: - View Lifecycle Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchImage()
        getDeckCount()
        
        cardName = shouldUseResult ? cardResult!.name : card!.name
        cost = shouldUseResult ? cardResult!.manaCost : card!.manaCost
        type = shouldUseResult ? cardResult!.type : card!.type
        text = shouldUseResult ? cardResult!.text : card!.text
        imageStringUrl = shouldUseResult ? cardResult!.imageUrl : card!.imageUrl
        
        cardNameLabel.text = cardName
        costLabel.text = "Cost: \(cost ?? "None")"
        typeLabel.text = "Types: \(type)"
        textLabel.text = text
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Methods
    
    private func fetchImage() {
        imageUnavailableLabel.text = "Image Unavailable"
        imageUnavailableLabel.isHidden = true
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        
        if let urlString = shouldUseResult ? cardResult!.imageUrl : card!.imageUrl {
            if let cardUrl = URL(string: urlString) {
                DispatchQueue.global(qos: .userInteractive).async { [unowned self] in
                    if let data = try? Data(contentsOf: cardUrl) {
                        DispatchQueue.main.async {
                            self.imageView.image = UIImage(data: data)
                            self.spinner.stopAnimating()
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.spinner.stopAnimating()
                            self.imageView.isHidden = true
                            self.imageUnavailableLabel.isHidden = false
                        }
                    }
                }
            }
        } else {
            spinner.stopAnimating()
            imageView.isHidden = true
            imageUnavailableLabel.isHidden = false
        }
    }
    
    private func getDeckCount() {
        let request = Card.createFetchRequest()
        let cardId = shouldUseResult ? cardResult!.id : card!.id
        request.predicate = NSPredicate(format: "deck.id == %@ AND id == %@", deck.id, cardId!)
        if let cards = try? appDelegate.persistentContainer.viewContext.fetch(request) {
            if !cards.isEmpty {
                deckCountLabel.text = "Deck Count: \(cards[0].amount)"
            } else {
                deckCountLabel.text = "Deck Count: 0"
            }
        } else {
            print("error fetching card count in deck")
        }
    }

    
    // MARK: - StoreSubscriber Delegate Methods
    
    func newState(state: State) {
        getDeckCount()
    }
    
}
