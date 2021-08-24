//
//  StringExtension.swift
//  testMVVM
//
//  Created by Leo Ostrovskiy on 20.08.2021.
//

import Foundation

private enum Constants {
    static let loginRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    static let passwordRegex = "^[0-9a-zA-Z\\_]{6,18}$"
}

extension String {
    func isLoginValid() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: Constants.loginRegex, options: .caseInsensitive)
            if regex.matches(
                in: self,
                options: [],
                range: NSMakeRange(0, self.count)).count > 0 {
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }

    func isPasswordValid() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: Constants.passwordRegex, options: .caseInsensitive)
            if regex.matches(
                in: self,
                options: [],
                range: NSMakeRange(0, self.count)).count > 0 {
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }
}
