//
//  Stats Extension.swift
//  MTGPrices
//
//  Created by Gabriele Pregadio on 12/12/16.
//  Copyright © 2016 Gabriele Pregadio. All rights reserved.
//

import Foundation
import UIKit

extension DeckViewController {
    
    func viewRotated() {
        statsView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        drawStats()
    }
    
    func drawStats() {
        drawColorCircle()
    }
    
    func drawColorCircle() {
        
        var whiteCount: CGFloat = 0
        var blueCount: CGFloat = 0
        var blackCount: CGFloat = 0
        var redCount: CGFloat = 0
        var greenCount: CGFloat = 0
        
        for card in cards {
            if let manaCost = card.manaCost, !card.isSideboard {
                for color in manaCost.characters {
                    switch color {
                    case "W": whiteCount += 1 * CGFloat(card.amount)
                    case "U": blueCount += 1 * CGFloat(card.amount)
                    case "B": blackCount += 1 * CGFloat(card.amount)
                    case "R": redCount += 1 * CGFloat(card.amount)
                    case "G": greenCount += 1 * CGFloat(card.amount)
                    default: break
                    }
                }
            }
        }
        
        let totalColoredCards = whiteCount + blueCount + blackCount + redCount + greenCount
        let whiteEndAngle = 360 * (whiteCount / totalColoredCards)
        let blueEndAngle = 360 * (blueCount / totalColoredCards) + whiteEndAngle
        let blackEndAngle = 360 * (blackCount / totalColoredCards) + blueEndAngle
        let redEndAngle = 360 * (redCount / totalColoredCards) + blackEndAngle
        
        let circleCenter = CGPoint(x: statsView.frame.midX, y: statsView.frame.midY)
        let piePieces = [
            (UIBezierPath(circleSegmentCenter: circleCenter, radius: Constants.radius, startAngle: 0, endAngle: whiteEndAngle), UIColor.white),
            (UIBezierPath(circleSegmentCenter: circleCenter, radius: Constants.radius, startAngle: whiteEndAngle, endAngle: blueEndAngle), UIColor.blue),
            (UIBezierPath(circleSegmentCenter: circleCenter, radius: Constants.radius, startAngle: blueEndAngle, endAngle: blackEndAngle), UIColor.black),
            (UIBezierPath(circleSegmentCenter: circleCenter, radius: Constants.radius, startAngle: blackEndAngle, endAngle: redEndAngle), UIColor.red),
            (UIBezierPath(circleSegmentCenter: circleCenter, radius: Constants.radius, startAngle: redEndAngle, endAngle: 360), UIColor(red: 0.18, green: 0.76, blue: 0.36, alpha: 1.0))
        ]
        drawPieChart(pieces: piePieces)
        
        let innerCirceLayer = CAShapeLayer()
        innerCirceLayer.path = UIBezierPath(arcCenter: circleCenter, radius: Constants.radius / 2, startAngle: 0, endAngle: 360, clockwise: true).cgPath
        innerCirceLayer.fillColor = UIColor.groupTableViewBackground.cgColor
        statsView.layer.addSublayer(innerCirceLayer)
    }
    
    func drawPieChart(pieces: [(UIBezierPath, UIColor)]) {
        var layers = [CAShapeLayer]()
        for piece in pieces {
            let layer = CAShapeLayer()
            layer.path = piece.0.cgPath
            layer.fillColor = piece.1.cgColor
            layer.strokeColor = UIColor.groupTableViewBackground.cgColor
            layer.lineWidth = 5.0
            layers.append(layer)
        }
        for layer in layers {
            statsView.layer.addSublayer(layer)
        }
    }
    
    
    // MARK: - Supporting Functionality
    
    struct Constants {
        static let radius: CGFloat = 100
    }
    
}

extension CGFloat {
    var radians: CGFloat {
        return CGFloat(M_PI) * (self / 180)
    }
}

extension UIBezierPath {
    convenience init(circleSegmentCenter center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat) {
        self.init()
        self.move(to: CGPoint(x: center.x, y: center.y))
        self.addArc(withCenter: center, radius: radius, startAngle: startAngle.radians, endAngle: endAngle.radians, clockwise: true)
        self.close()
    }
}
