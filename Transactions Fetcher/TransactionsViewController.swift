//
//  ViewController.swift
//  Transactions Fetcher
//
//  Created by oren shalev on 30/03/2022.
//

import UIKit

class TransactionsViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let transactionViewModel = TransactionsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        textField.delegate = self
        textField.attributedPlaceholder = NSAttributedString(string: "Enter Address",
                                    attributes: [.foregroundColor: UIColor.white])
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        registerToKeyboardEvents()

        transactionViewModel.transactionsDidChange = { [weak self] in
            self?.tableView.reloadData()
        }
        
    }

}






fileprivate typealias TableView = TransactionsViewController
extension TableView: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        transactionViewModel.transactions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 317
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let transaction = transactionViewModel.transactions[indexPath.row]
        let transactionCell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell") as! TransactionTableViewCell
        transactionCell.setCell(transaction: transaction)
        
        return transactionCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
                    
        if indexPath.row == transactionViewModel.transactions.count - 1 {
            let loadingFooterView = Bundle.main.loadNibNamed("LoadingFooterView", owner: nil, options: [:])!.first as! UIView
            tableView.tableFooterView = loadingFooterView
            Task {
                do {
                    try await transactionViewModel.getTransactions()
                    await MainActor.run {
                        tableView.tableFooterView = nil
                    }
                } catch {
                    await MainActor.run { [weak self] in
                        tableView.tableFooterView = nil
                        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self?.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
        
    
    }
}





fileprivate typealias Keboard = TransactionsViewController
extension Keboard: UITextFieldDelegate {
    
    @objc private func handle(keyboardNotification notification: Notification) {
        if let userInfo = notification.userInfo,
           let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            self.view.frame.size.height = keyboardRectangle.origin.y
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activityIndicator.startAnimating()
        Task {
            do {
                try await self.transactionViewModel.getTransactions(address: textField.text ?? "")
                await MainActor.run {
                    activityIndicator.stopAnimating()
                }
            } catch {
                await MainActor.run { [weak self] in
                    activityIndicator.stopAnimating()
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            }

        }
        textField.resignFirstResponder()
        return true
    }
    
    func registerToKeyboardEvents() {
        NotificationCenter.default.addObserver(self,
        selector: #selector(handle(keyboardNotification:)),
        name: UIResponder.keyboardWillShowNotification,
        object: nil)
        
        NotificationCenter.default.addObserver(self,
        selector: #selector(handle(keyboardNotification:)),
        name: UIResponder.keyboardWillHideNotification,
        object: nil)
    }
    
}
