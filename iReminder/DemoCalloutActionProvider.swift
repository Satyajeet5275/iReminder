//
//  DemoCalloutActionProvider.swift
//  Keyboard


import KeyboardKit
import UIKit

/**
 This demo-specific callout action provider adds a couple of
 dummy callouts when typing.
 */
class DemoCalloutActionProvider: BaseCalloutActionProvider {
    private weak var keyboardViewController: KeyboardViewController?
    override func calloutActionString(for char: String) -> String {
        switch char {
        case "k": String("keyboard".reversed())
        default: super.calloutActionString(for: char)
            
        }
    }
    
}
