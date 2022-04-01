//
//  TransactionsViewModel.swift
//  Transactions Fetcher
//
//  Created by oren shalev on 31/03/2022.
//

import Foundation

typealias VoidClosure = () -> ()

class TransactionsViewModel {
    var currentPage = 0
    var transactionsDidChange: VoidClosure?
    var address: String!
    var transactions: [Transaction] = []
    {
        didSet {
            Task {
                await MainActor.run {
                    transactionsDidChange?()
                }
            }
        }
    }
    
    func getTransactions(address: String? = nil) async throws {
        if let address = address {
            self.address = address
            self.transactions.removeAll()
            currentPage = 0
        }
        
        let transactions = try await Network.manager.getTransactionsForAddress(address: self.address, page: self.currentPage, offset: 10)
        self.currentPage += 1
        self.transactions = self.transactions + transactions

    }
    
}
