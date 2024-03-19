//
//  Array+Ext.swift
//  telly
//
//  Created by Felipe Passos on 24/08/23.
//

import Foundation

import Foundation

extension Array {
    /// Find a element in array and if not find return nil
    func find(at index: Int) -> Element? {
        guard index >= 0 && index < count else {
            return nil
        }

        return self[index]
    }
}
