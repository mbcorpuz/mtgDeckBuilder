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
    
    @IBOutlet weak var statsView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabBar: UITabBar!
    
    
    // MARK: - Stored Properties
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var deck: Deck!
    var cards = [Card]()
    
    // MARK: - View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = deck.name
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Deck", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(searchForCards))
        
        NotificationCenter.default.addObserver(self, selector: #selector(viewRotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        tabBar.delegate = self
        tabBar.selectedItem = tabBar.items![0]
        
        statsView.backgroundColor = UIColor.groupTableViewBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(self)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Methods
    
    func searchForCards() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AddCardViewController") as? AddCardViewController {
            vc.deck = deck
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func fetchCards() {
        let cardRequest = Card.createFetchRequest()
        cardRequest.predicate = NSPredicate(format: "deck.id == %@", deck.id)
        if let cards = try? appDelegate.persistentContainer.viewContext.fetch(cardRequest) {
            self.cards = cards
            tableView.reloadData()
        } else {
            print("core data error fetching")
        }
    }
    
    
    // MARK: - StoreSubscriber Delegate Methods
    
    func newState(state: State) {
        fetchCards()
        if state.isDownloadingImages {
        } else {
            tableView.reloadData()
        }
    }
    
}

extension DeckViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.tabBar.isUserInteractionEnabled = false
        
        if item == tabBar.items![0] && tableView.isHidden {
            tableView.alpha = 0
            tableView.isHidden = false
            UIView.animate(
                withDuration: 0.35,
                animations: { [unowned self] in
                    self.statsView.alpha = 0
                    self.tableView.alpha = 1
                },
                completion: { [unowned self] finished in
                    self.statsView.isHidden = true
                })
        } else if item == tabBar.items![1] && !tableView.isHidden {
            statsView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            statsView.alpha = 0
            statsView.isHidden = false
            UIView.animate(
                withDuration: 0.35,
                animations: { [unowned self] in
                    self.tableView.alpha = 0
                    self.statsView.alpha = 1
                },
                completion: { [unowned self] finished in
                    self.tableView.isHidden = true
                })
            drawStats()
        }
        
        self.tabBar.isUserInteractionEnabled = true
    }
}

