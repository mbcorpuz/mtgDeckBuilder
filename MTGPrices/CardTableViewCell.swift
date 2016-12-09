//
//  CardTableViewCell.swift
//  MTGPrices
//
//  Created by Gabriele Pregadio on 12/7/16.
//  Copyright © 2016 Gabriele Pregadio. All rights reserved.
//
import UIKit

class CardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var costStackView: UIStackView!
    var originalContentsRect: CGRect!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        originalContentsRect = cardImageView.layer.contentsRect
    }
    
    func configureCost(from imageViews: [UIImageView]?) {
        guard let imageViews = imageViews else {
            costStackView.isHidden = true
            return
        }
        costStackView.isHidden = false
        
        for view in costStackView.arrangedSubviews {
            costStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        for view in imageViews {
            costStackView.addArrangedSubview(view)
        }
    }
    
    func configureFrame() {
        cardImageView.layer.contentsRect = originalContentsRect
        cardImageView.clipsToBounds = true
        cardImageView.contentMode = .scaleAspectFill
        cardImageView.layer.cornerRadius = cardImageView.frame.size.height / 5
        cardImageView.layer.contentsRect = cardImageView.layer.contentsRect.offsetBy(dx: 0, dy: -0.2).insetBy(dx: 0.12, dy: 0.1)
    }
    
}
