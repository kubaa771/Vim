//
//  Extensions.swift
//  Vim
//
//  Created by Jakub Iwaszek on 11/02/2019.
//  Copyright © 2019 Jakub Iwaszek. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}

extension UIViewController {
    func displayErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}

extension Sequence where Iterator.Element : Hashable {
    
    func intersects<S : Sequence>(with sequence: S) -> Bool
        where S.Iterator.Element == Iterator.Element
    {
        let sequenceSet = Set(sequence)
        return self.contains(where: sequenceSet.contains)
    }
}

open class HashableClass {
    public init() {}
}

// MARK: - <Hashable>

extension HashableClass: Hashable {
    public var hashValue: Int {
        return ObjectIdentifier(self).hashValue
    }
}

// MARK: - <Equatable>

extension HashableClass: Equatable {}
public func ==(lhs: HashableClass, rhs: HashableClass) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}

extension Array where Element: Hashable {
    var uniqueItems: Array  {
        var set = Set<Element>()
        return compactMap { set.insert($0).inserted ? $0 : nil }
    }
}

extension UITextView {
    func setBottomBorder() {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        border.frame = CGRect(x: 0, y: self.frame.size.height - width,   width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

extension UILabel {
    func setBottomBorder() {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
        border.frame = CGRect(x: 0, y: self.frame.size.height - width,   width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}
