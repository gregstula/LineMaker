//
//  DrawView.swift
//  TouchTracker
//
//  Created by Gregory Stula on 4/24/16.
//  Copyright © 2016 Gregory Stula. All rights reserved.
//

import UIKit

class DrawView: UIView {
    var currentLines = [NSValue: Line]()
    var finishedLines = [Line]()

    func strokeLine (line: Line) {
        let path = UIBezierPath()
        path.lineWidth = 10
        path.lineCapStyle = CGLineCap.Round
        
        path.moveToPoint (line.begin)
        path.addLineToPoint (line.end)
        path.stroke()
    }
    
    override func drawRect (rect: CGRect) {
        // Draw finished lines in black
        UIColor.blackColor().setStroke()
        
        for line in finishedLines {
            strokeLine (line)
        }
        
        // If there is a line currently being drawn, do it in red
        UIColor.redColor().setStroke()
        for (_, line) in currentLines {
            strokeLine (line)
        }
    }
    
    override func touchesBegan (touches: Set <UITouch>, withEvent event: UIEvent?) {
        
        print(#function)
        
        for touch in touches {
            let location = touch.locationInView (self)
            
            let newLine = Line (begin: location, end: location)
            
            let key = NSValue (nonretainedObject: touch)
            currentLines[key] = newLine
        }
        
        setNeedsDisplay()
    }
    
    
    override func touchesMoved (touches: Set<UITouch>, withEvent event: UIEvent?) {
        print(#function)
        
        for touch in touches {
            let key = NSValue (nonretainedObject: touch)
            currentLines[key]?.end = touch.locationInView (self)
        }
        
        setNeedsDisplay()
    }

    
    override func touchesEnded (touches: Set <UITouch>, withEvent event: UIEvent?) {
        print(#function)
         for touch in touches {
            let key = NSValue (nonretainedObject: touch)
            if var line = currentLines[key] {
                line.end = touch.locationInView (self)
                
                finishedLines.append (line)
                currentLines.removeValueForKey (key)
            }
        }
            setNeedsDisplay()
    }
    
    override func touchesCancelled (touches: Set <UITouch>?, withEvent event: UIEvent?) {
        print (#function)
        
        currentLines.removeAll()
        
        setNeedsDisplay()
    }
}

