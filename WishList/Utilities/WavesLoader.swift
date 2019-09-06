//
//  WavesLoader.swift
//  PQFFillableLoaders
//
//  Created by Pol Quintana on 2/8/15.
//  Copyright (c) 2015 Pol Quintana. All rights reserved.
//

import Foundation
import UIKit

open class WavesLoader: FillableLoader {
    
    internal override func generateLoader() {
        layoutPath()
    }
    
    internal override func layoutPath() {
        super.layoutPath()
        shapeLayer.path = shapePathAtIndex(0, count: 7)
    }
    
    
    // MARK: Animate
    
    internal override func startAnimating() {
        guard animate else { return }
        if swing { startswinging() }
        startWaving()
        startMoving(up: true)
    }
    
    internal func startWaving() {
        let waveAnimation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "path")
        waveAnimation.values = shapesArray(7)
        waveAnimation.duration = 2.0
        waveAnimation.isRemovedOnCompletion = false
        waveAnimation.fillMode = CAMediaTimingFillMode.forwards
        waveAnimation.delegate = self as? CAAnimationDelegate
        waveAnimation.setValue("shape", forKey: "animation")
        shapeLayer.add(waveAnimation, forKey: "shape")
    }
    
    
    //MARK: Waves
    
    internal func shapesArray(_ count: Int) -> [AnyObject] {
        let shapesArray: NSMutableArray = []
        for i in 0..<count*2 {
            shapesArray.add(shapePathAtIndex(i, count: count*2))
        }
        return shapesArray as [AnyObject]
    }
    
    internal func shapePathAtIndex(_ index: Int, count: Int) -> CGMutablePath {
        let width = loaderView.frame.width
        let height = loaderView.frame.height
        let xMovement: CGFloat = (width/CGFloat(count))*CGFloat(index)
        let initialOrLast: Bool = index == 1 || index == count
        let divisions: CGFloat = 8
        var variation: CGFloat = 10
        
     let path = CGMutablePath()
        path.move(to: CGPoint(x: -width,y:height/2))
        
        // First wave
        if !initialOrLast { variation = randomFloat() }
        path.addQuadCurve(to: CGPoint(x: -width + width/divisions + xMovement,y: height/2 + variation), control: CGPoint(x:  -width + width/4 + xMovement , y: height/2))
        //CGPathAddQuadCurveToPoint(path, nil, -width + width/divisions + xMovement, height/2 + variation, -width + width/4 + xMovement, height/2)
        if !initialOrLast { variation = randomFloat() }
        path.addQuadCurve(to: CGPoint(x: -width + width/divisions*3 + xMovement,y: height/2 - variation), control: CGPoint(x:  -width + width/2 + xMovement , y: height/2))
       // CGPathAddQuadCurveToPoint(path, nil, -width + width/divisions*3 + xMovement, height/2 - variation, -width + width/2 + xMovement, height/2)
        
        // Second wave
        if !initialOrLast { variation = randomFloat() }
        path.addQuadCurve(to: CGPoint(x: -width + width/divisions*5 + xMovement,y: height/2 + variation), control: CGPoint(x:  -width + width/4*3 + xMovement , y: height/2))
        //CGPathAddQuadCurveToPoint(path, nil, -width + width/divisions*5 + xMovement, height/2 + variation, -width + width/4*3 + xMovement, height/2)
        if !initialOrLast { variation = randomFloat() }
        path.addQuadCurve(to: CGPoint(x: -width + width/divisions*7 + xMovement,y: height/2 - variation), control: CGPoint(x:  -width + width + xMovement , y: height/2))
       // CGPathAddQuadCurveToPoint(path, nil, -width + width/divisions*7 + xMovement, height/2 - variation, -width + width + xMovement, height/2)
        
        // Third wave
        if !initialOrLast { variation = randomFloat() }
        path.addQuadCurve(to: CGPoint(x: width/divisions + xMovement,y: height/2 + variation), control: CGPoint(x: width/4 + xMovement , y: height/2) )
        //CGPathAddQuadCurveToPoint(path, nil, width/divisions + xMovement, height/2 + variation, width/4 + xMovement, height/2)
        if !initialOrLast { variation = randomFloat() }
         path.addQuadCurve(to: CGPoint(x: width/divisions*3 + xMovement,y: height/2 - variation), control: CGPoint(x:  width/2 + xMovement , y: height/2))
        //CGPathAddQuadCurveToPoint(path, nil, width/divisions*3 + xMovement, height/2 - variation, width/2 + xMovement, height/2)
        
        // Forth wave
        if !initialOrLast { variation = randomFloat() }
        path.addQuadCurve(to: CGPoint(x: width/divisions*5 + xMovement,y: height/2 + variation), control: CGPoint(x: width/4*3 + xMovement , y: height/2))
        //CGPathAddQuadCurveToPoint(path, nil, width/divisions*5 + xMovement, height/2 + variation, width/4*3 + xMovement, height/2)
        if !initialOrLast { variation = randomFloat() }
          path.addQuadCurve(to: CGPoint(x:  width/divisions*7 + xMovement,y: height/2 - variation), control: CGPoint(x:  width + xMovement , y: height/2))
        //CGPathAddQuadCurveToPoint(path, nil, width/divisions*7 + xMovement, height/2 - variation, width + xMovement, height/2)
        
        // Closing path
        //CGPathAddLineToPoint(path, nil, width + 100, height/2)
        path.addLine(to: CGPoint(x: width + 100, y: height/2))
        //CGPathAddLineToPoint(path, nil, width + 100, height*2)
        path.addLine(to: CGPoint(x: width + 100, y: height*2))
        //CGPathAddLineToPoint(path, nil, -width, height*2)
        path.addLine(to: CGPoint(x: -width, y: height*2))
        path.closeSubpath()
        return path
    }
    
    
    //MARK: Animations Delegate
    
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard animate, let key = anim.value(forKey: "animation") as? String else { return }
        if key == "up" {
            startMoving(up: false)
        }
        else if key == "down" {
            startMoving(up: true)
        }
        if key == "shape" {
            startWaving()
        }
        if key == "rotation" {
            startswinging()
        }
    }
    
    
    //MARK: Helpers
    
    internal func randomFloat() -> CGFloat {
        return CGFloat(arc4random_uniform(10) + 5)
    }
}
