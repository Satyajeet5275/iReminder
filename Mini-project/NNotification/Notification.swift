//
//  Notification.swift
//  Mini-project
//
//  Created by mini project on 06/03/24.
//

import Foundation
import SwiftUI

struct NotificationCenterKey: EnvironmentKey {
    static let defaultValue: NotificationCenter = .default
}

extension EnvironmentValues {
    var notificationCenter: NotificationCenter {
        get { self[NotificationCenterKey.self] }
        set { self[NotificationCenterKey.self] = newValue }
    }
}


