//
//  Application.swift
//  Mini-project
//
//  Created by Mini Project on 10/02/24.
//

import Foundation
import UIKit

final class Application_utility{
    
    static var rootViewController: UIViewController{
        
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            
            return .init()
        }
        guard let root = screen.windows.first?.rootViewController else{
            
            return .init()
        }
        return root
    }
}
