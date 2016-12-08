//
//  DeckListViewController
//  MTGPrices
//
//  Created by Gabriele Pregadio on 11/28/16.
//  Copyright © 2016 Gabriele Pregadio. All rights reserved.
//

import UIKit
import Alamofire
import ReSwift

class DeckListViewController: UIViewController, StoreSubscriber {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var decks = [Deck]()
    
    // MARK: - View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("testing difference")
        title = "Decklist Viewer"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Decks", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        store.unsubscribe(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - StoreSubscriber Delegate Methods
    
    func newState(state: State) {
        self.decks = state.decks
        tableView.reloadData()
    }
    
}

