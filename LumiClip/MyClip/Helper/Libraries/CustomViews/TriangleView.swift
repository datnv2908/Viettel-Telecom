//
//  TriangleView.swift
//  MyClip
//
//  Created by Os on 6/29/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class TriangleView: UIView {

    var color = UIColor.gray {
        didSet {
            setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        self.backgroundColor = UIColor.clear
        let layerHeight = self.layer.frame.height
        let layerWidth = self.layer.frame.width
        let line = UIBezierPath()
        line.move(to: CGPoint(x: 0, y: layerHeight))
        line.addLine(to: CGPoint(x: layerWidth, y: layerHeight/2))
        line.addLine(to: CGPoint(x: 0, y: 0))
        line.addLine(to: CGPoint(x: 0, y: layerHeight))
        line.close()
        color.setStroke()
        color.setFill()
        line.lineWidth = 3.0
        line.fill()
        line.stroke()
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = line.cgPath
        self.layer.mask = shapeLayer
    }
}
