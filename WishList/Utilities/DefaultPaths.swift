//
//  DefaultPaths.swift
//  FillableLoaders
//
//  Created by Pol Quintana on 2/8/15.
//  Copyright (c) 2015 Pol Quintana. All rights reserved.
//

import Foundation
import UIKit

struct Paths {
    static func twitterPath() -> CGPath {
        //Created with PaintCode
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 190, y: 281))
        bezierPath.addCurve(to: CGPoint(x: 142, y: 329), controlPoint1: CGPoint(x: 163.49, y: 281), controlPoint2: CGPoint(x: 142, y: 302.49))
        bezierPath.addCurve(to: CGPoint(x: 190, y: 377), controlPoint1: CGPoint(x: 142, y: 355.51), controlPoint2: CGPoint(x: 163.49, y: 377))
        bezierPath.addCurve(to: CGPoint(x: 238, y: 329), controlPoint1: CGPoint(x: 216.51, y: 377), controlPoint2: CGPoint(x: 238, y: 355.51))
        bezierPath.addCurve(to: CGPoint(x: 190, y: 281), controlPoint1: CGPoint(x: 238, y: 302.49), controlPoint2: CGPoint(x: 216.51, y: 281))
        bezierPath.close()
        bezierPath.miterLimit = 4;
        return bezierPath.cgPath
    }
}
