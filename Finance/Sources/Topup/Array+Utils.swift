//
//  Array+Utils.swift
//  
//
//  Created by SEUNGHA on 2022/02/08.
//

import Foundation

extension Array {
  subscript(safe index: Int) -> Element? {
    return indices ~= index ? self[index] : nil
  }
}
