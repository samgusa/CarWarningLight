//
//  TipJarStore.swift
//  CarWarningLight
//
//  Created by Sam Greenhill on 9/6/26.
//  Copyright © 2026 simplyAmazingMachines. All rights reserved.
//

import StoreKit

@Observable
@MainActor
final class TipJarStore {
    var products: [Product] = []
    var showCelebration: Bool = false

    var hasEverTipped: Bool {
        get { UserDefaults.standard.bool(forKey: "hasEverTipped") }
        set { UserDefaults.standard.set(newValue, forKey: "hasEverTipped") }
    }

    private let productIDs = [
        "com.simple.CarWarningLight.tip.small",
        "com.simple.CarWarningLight.tip.medium",
        "com.simple.CarWarningLight.tip.large"
    ]

    private var updatesTasks: Task<Void, Never>?

    init() {
        updatesTasks = Task { [weak self] in
            for await update in Transaction.updates {
                await self?.handle(update)
            }
        }
    }

    private func handle(_ result: VerificationResult<Transaction>) async {
        guard case .verified(let tranaction) = result,
              productIDs.contains(tranaction.productID) else { return }

        await tranaction.finish()
        hasEverTipped = true
    }

    func loadProducts() async {
        do {
            let fetched = try await Product.products(for: productIDs)
            products = fetched.sorted { $0.price < $1.price }
        } catch {
            print("Failed to load tip products: \(error)")
        }
    }

    func purchase(_ product: Product) async {
        do {
            let result = try await product.purchase()
            if case .success(let verification) = result, case .verified = verification {
                await verification.payloadTransaction.finish()
                hasEverTipped = true
                showCelebration = true
            }
        } catch {
            print("Purchase failed: \(error)")
        }
    }
}

private extension VerificationResult<Transaction> {
    var payloadTransaction: Transaction {
        switch self {
        case .verified(let transaction):        return transaction
        case .unverified(let transaction, _):   return transaction
        }
    }
}
