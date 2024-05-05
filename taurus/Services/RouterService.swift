//
//  RouterService.swift
//  taurus
//
//  Created by Felipe Passos on 18/03/24.
//

import Foundation
import SwiftUI

/// A service responsible for routing and managing screen navigation and alerts.
///
/// This class provides a centralized way to control the current screen displayed to the user and
/// to manage alert presentations. It leverages the `ObservableObject` protocol to enable dynamic
/// and reactive UI updates in SwiftUI.
class RouterService: ObservableObject {
    
    /// The shared singleton instance of `RouterService`.
    static var shared = RouterService()

    /// Represents the current screen being displayed to the user.
    ///
    /// Changes to this property will trigger UI updates in any views observing it.
    @Published var screen: Screen = .start
    
    @Published var lastScreen: Screen = .start
        
    /// A flag indicating if an alert is currently being presented.
    ///
    /// Changes to this property will trigger UI updates in any views observing it.
    @Published var isAlertPresented: Bool = false
    
    @Published var isSheetPresented: Bool = false
    
    /// The current alert object to be displayed.
    ///
    /// This property holds the specifics of an alert, including its title and any associated actions.
    @Published var alert: Alert = Alert(title: Text(""))
    
    @Published var sheet: AnyView = AnyView(Text("Sheet"))

    /// Displays a given alert to the user.
    ///
    /// - Parameter alert: The `Alert` object that specifies the details of the alert to be presented.
    func showAlert(_ alert: Alert) {
        self.alert = alert
        isAlertPresented = true
    }
    
    func showSheet(_ sheet: some View) {
        self.sheet = AnyView(sheet)
        isSheetPresented = true
    }
    
    func hideSheet() {
        isSheetPresented = false
    }
    
    /// Changes the currently displayed screen to the provided one.
    ///
    /// - Parameter screen: The target `Screen` enum value representing the desired screen.
    func navigate(_ screen: Screen) {
        self.lastScreen = self.screen
        self.screen = screen
    }
    
    func back() {
        navigate(lastScreen)
    }
}
