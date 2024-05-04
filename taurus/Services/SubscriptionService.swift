//
//  SubscriptionManager.swift
//  storekit-2-demo-app
//
//  Created by Aisultan Askarov on 11.01.2024.
//

import StoreKit
import SwiftUI

//class EntitlementManager: ObservableObject {
//    static let userDefaults = UserDefaults(suiteName: "group.demo.app")!
//    
//    @AppStorage("hasPro", store: userDefaults)
//    var hasPro: Bool = false
//}

@MainActor
class SubscriptionService: NSObject, ObservableObject, SKPaymentTransactionObserver {
    static let shared = SubscriptionService()
    
    nonisolated func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
    }
    
    nonisolated func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        return true
    }
    
    let productIDs: [String] = ["powerup.bomb", "powerup.shield", "powerup.portal", "basic.starter_pack"]
    var purchasedProductIDs: Set<String> = []

    @Published var products: [Product] = []
    
//    private var entitlementManager: EntitlementManager? = nil
    private var updates: Task<Void, Never>? = nil
    
//    init(entitlementManager: EntitlementManager) {
    override init() {
//        self.entitlementManager = entitlementManager
        super.init()
        self.updates = observeTransactionUpdates()
        SKPaymentQueue.default().add(self)
    }
    
    deinit {
        updates?.cancel()
    }
    
    func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [unowned self] in
            for await _ in Transaction.updates {
                await self.updatePurchasedProducts()
            }
        }
    }
}

// MARK: StoreKit2 API
extension SubscriptionService {
    func loadProducts() async {
        print("try to load products")
        do {
            self.products = try await Product.products(for: productIDs)
                .sorted(by: { $0.price > $1.price })
            
            print("load \(self.products.count) products")
        } catch {
            print("Failed to fetch products!")
        }
    }
    
    func buyProduct(_ product: Product) async {
        do {
            let result = try await product.purchase()
            
            switch result {
            case let .success(.verified(transaction)):
                // Successful purhcase
                await transaction.finish()
                await self.updatePurchasedProducts()
            case let .success(.unverified(_, error)):
                // Successful purchase but transaction/receipt can't be verified
                // Could be a jailbroken phone
                print("Unverified purchase. Might be jailbroken. Error: \(error)")
                break
            case .pending:
                // Transaction waiting on SCA (Strong Customer Authentication) or
                // approval from Ask to Buy
                break
            case .userCancelled:
                print("User cancelled!")
                break
            @unknown default:
                print("Failed to purchase the product!")
                break
            }
        } catch {
            print("Failed to purchase the product!")
        }
    }
    
    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }
            
            if transaction.revocationDate == nil {
                self.purchasedProductIDs.insert(transaction.productID)
            } else {
                self.purchasedProductIDs.remove(transaction.productID)
            }
        }
        
//        self.entitlementManager?.hasPro = !self.purchasedProductIDs.isEmpty
    }
    
    func restorePurchases() async {
        do {
            try await AppStore.sync()
        } catch {
            print(error)
        }
    }
}
