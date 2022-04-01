//
//  TransactionTableViewCell.swift
//  Transactions Fetcher
//
//  Created by oren shalev on 31/03/2022.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var hashLabel: UILabel!
    @IBOutlet weak var confirmationsLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCell(transaction: Transaction) {
        let date = Date(timeIntervalSince1970: Double(transaction.timeStamp)!)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateLabel.text = dateFormatter.string(from: date)
        confirmationsLabel.text = transaction.confirmations
        toLabel.text = transaction.to
        fromLabel.text = transaction.from
        valueLabel.text = transaction.value
        hashLabel.text = transaction.hash
    }
}
