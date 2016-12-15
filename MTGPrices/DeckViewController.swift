//
//  DeckViewController.swift
//  MTGPrices
//
//  Created by Gabriele Pregadio on 11/29/16.
//  Copyright © 2016 Gabriele Pregadio. All rights reserved.
//
import UIKit
import ReSwift
import Charts

class DeckViewController: UIViewController, StoreSubscriber {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var statsScrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabBar: UITabBar!
    
    
    // MARK: - Properties
    
    let colorPieChartView = PieChartView()
    let typePieChartView = PieChartView()
    let costBarChartView = BarChartView()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var deck: Deck!
    var cards = [Card]()
    
    // MARK: - View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = deck.name
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Deck", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(searchForCards))
        
        NotificationCenter.default.addObserver(self, selector: #selector(redraw), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        tabBar.delegate = self
        tabBar.selectedItem = tabBar.items![0]
        
        statsScrollView.delegate = self
        statsScrollView.isHidden = true
        statsScrollView.backgroundColor = Colors.background
        
        statsScrollView.addSubview(colorPieChartView)
        statsScrollView.addSubview(typePieChartView)
        statsScrollView.addSubview(costBarChartView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        store.subscribe(self)
        setColorPieChartData()
        setTypePieChartData()
        setCostBarChartData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        redraw()
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
    
    func redraw() {
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            colorPieChartView.frame = CGRect(x: 0, y: 0, width: statsScrollView.frame.width * 0.33, height: statsScrollView.frame.height)
            typePieChartView.frame = CGRect(x: colorPieChartView.frame.maxX, y: 0, width: statsScrollView.frame.width * 0.33, height: statsScrollView.frame.height)
            costBarChartView.frame = CGRect(x: typePieChartView.frame.maxX, y: 0, width: statsScrollView.frame.width * 0.34, height: statsScrollView.frame.height)
        } else {
            colorPieChartView.frame = CGRect(x: 0, y: 0, width: statsScrollView.frame.width, height: statsScrollView.frame.height * 0.33)
            typePieChartView.frame = CGRect(x: 0, y: colorPieChartView.frame.maxY, width: statsScrollView.frame.width, height: statsScrollView.frame.height * 0.33)
            costBarChartView.frame = CGRect(x: 0, y: typePieChartView.frame.maxY, width: statsScrollView.frame.width, height: statsScrollView.frame.height * 0.34)
        }
        statsScrollView.contentSize = statsScrollView.frame.size
    }
    
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
    
    func viewRotated() {
        guard !statsScrollView.isHidden else { return }
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
                    self.statsScrollView.alpha = 0
                    self.tableView.alpha = 1
                },
                completion: { [unowned self] finished in
                    self.statsScrollView.isHidden = true
                })
        } else if item == tabBar.items![1] && !tableView.isHidden {
            setColorPieChartData()
            setTypePieChartData()
            setCostBarChartData()
            statsScrollView.alpha = 0
            statsScrollView.isHidden = false
            UIView.animate(
                withDuration: 0.35,
                animations: { [unowned self] in
                    self.tableView.alpha = 0
                    self.statsScrollView.alpha = 1
                    self.colorPieChartView.animate(xAxisDuration: 0.0, yAxisDuration: 0.5)
                    self.typePieChartView.animate(xAxisDuration: 0.0, yAxisDuration: 0.5)
                    self.costBarChartView.animate(xAxisDuration: 0.5, yAxisDuration: 0.5)
                },
                completion: { [unowned self] finished in
                    self.tableView.isHidden = true
                })
        }
        
        self.tabBar.isUserInteractionEnabled = true
    }
}

