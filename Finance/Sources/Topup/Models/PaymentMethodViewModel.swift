//
//  PaymentMethodViewModel.swift
//  
//
//  Created by SEUNGHA on 2022/02/08.
//

import UIKit
import FinanceEntity

struct PaymentMethodViewModel {
    let name: String
    let digits: String
    let color: UIColor

    init(_ paymentMethod: PaymentMethod) {
        name = paymentMethod.name
        digits = "**** \(paymentMethod.digits)"
        color = UIColor(hex: paymentMethod.color) ?? .systemGray2
    }
}
