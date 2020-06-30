//
//  SemVer+Parser.swift
//  M46Swift
//
//  Created by David Jobe on 2020-06-30.
//  Copyright © 2020 se.mobility46. All rights reserved.
//

import Foundation



extension SemVer {
    
    public enum ParsingError: Error, Equatable {
        public enum Component {
            case major, minor, patch
        }
        
        case digitsNotFound(String)
        case missingVersionComponent(Component)
        
        var localizedDescription: String {
            switch self {
            case .digitsNotFound(let str):
                return "No digits in \(str)"
            case .missingVersionComponent(let comp):
                return "Missing version component (\(comp))"
            }
        }

    }
    
    public static func parse(_ input: String) throws -> SemVer {

        let charSet = CharacterSet(charactersIn: ".-")
        let scanner = Scanner(string: input)
        scanner.charactersToBeSkipped = charSet
        
        guard let majorStr = scanner.scanUpToCharacters(from: charSet) else {
            throw ParsingError.digitsNotFound(scanner.string)
        }
        
        guard let minorStr = scanner.scanUpToCharacters(from: charSet) else {
            throw ParsingError.digitsNotFound(scanner.string)
        }
        
        guard let patchStr = scanner.scanUpToCharacters(from: charSet) else {
            throw ParsingError.digitsNotFound(scanner.string)
        }
        
        guard let major = UInt(majorStr) else {
            throw ParsingError.missingVersionComponent(.major)
        }
        
        guard let minor = UInt(minorStr) else {
            throw ParsingError.missingVersionComponent(.minor)
        }
        
        guard let patch = UInt(patchStr) else {
            throw ParsingError.missingVersionComponent(.patch)
        }
        
        return SemVer(major: major, minor: minor, patch: patch)
    }
}
