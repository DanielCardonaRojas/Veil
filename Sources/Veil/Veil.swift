//
//  StringMask.swift
//  Veil
//
//  Created by Daniel Cardona Rojas on 1/07/20.
//  Copyright © 2020 Daniel Cardona Rojas. All rights reserved.
//

import Foundation

public class Veil {
    typealias Pattern = [Token]

    enum Token {
        case digit, any
        case symbol(Character)

        init(fromCharacter char: Character, config: Config) {
            if char == config.digitChar {
                self = .digit
            } else if char == config.anyChar {
                self = .any
            } else {
                self = .symbol(char)
            }
        }

        /**
         Process a char accordinto to token

           Writes either the provided character if matches digit or any token
           or the token symbol.

         - Parameter char: The input character being processed
         - Returns: Single character string

         */
        public func write(_ char: Character) -> (Bool, String) {
            let charString = String(char)
            switch self {
            case .digit:
                let isInt = Int(charString) != nil
                return (isInt, isInt ? charString : "")
            case .any:
                return (true, charString)
            case .symbol(let sym):
                return (char == sym, String(sym))
            }
        }

        public func read(_ char: Character) -> (Bool, String) {

            let charString = String(char)
            switch self {
            case .digit:
                let isInt = Int(charString) != nil
                return (isInt, isInt ? charString : "")
            case .any:
                return (true, charString)
            case .symbol(let sym):
                return (char == sym, "")
            }
        }

        func toChar(config: Config) -> Character {
            switch self {
            case .digit:
                return config.digitChar
            case .any:
                return config.anyChar
            case .symbol(let sym):
                return sym
            }
        }
    }

    /// Configuration used to parse mask pattern
    public struct Config {
        let digitChar: Character
        let anyChar: Character

        public init(digitChar: Character, anyChar: Character) {
            self.digitChar = digitChar
            self.anyChar = anyChar
        }

        public static func defaultConf() -> Config {
            Config(digitChar: "#", anyChar: "*")
        }
    }

    // MARK: Properties
    let pattern: Pattern
    let config: Config

    // MARK: Constructors
    init(pattern: Pattern, config: Config = .defaultConf()) {
        self.pattern = pattern
        self.config = config
    }

    /**
     Creates a masking object

     Note the default configuration uses `#` to represent any digit and `*` to represent any char.

     - Parameter config: The configuration used to parse the mask pattern
     - Parameter pattern: A string representing the mask that will be applied to a give input

     */
    public convenience init(pattern string: String, config: Config = .defaultConf()) {
        let pattern = Self.stringToChars(string).map {
            Token(fromCharacter: $0, config: config)
        }
        self.init(pattern: pattern, config: config)
    }

    /**
     Provide masked

     Note to do live input masking make sure to use non exhuastive option.

     - Parameter input: The input string to process
     - Parameter exhaustive: Wether or not should stop at last token of the pattern.
     - Returns: String masking the input string

     */
    public func mask(input: String, exhaustive: Bool = true) -> String {
        Self.mask(input: input, pattern: pattern, config: config, exhaustive: exhaustive)
    }

    /**
     Provide masked and unmasked versions of input

     Note to do live input masking make sure to use non exhuastive option.

     - Parameter input: The input string to process
     - Parameter exhaustive: Wether or not should stop at last token of the pattern.
     - Returns: A 2 component tuple of masked and unmasked input

     */
    public func process(input: String, exhaustive: Bool = true) -> (masked: String, unmasked: String) {
        Self.process(input: input, pattern: pattern, config: config, exhaustive: exhaustive)
    }

    // MARK: Helpers

    static func stringToChars(_ string: String) -> [Character] {
        let chars = Array(string)
        return chars
    }

    static func patternToString(_ pattern: Pattern, config: Config) -> String {
        String(pattern.map({ $0.toChar(config: config) }))
    }

    static func mask(input: String, pattern: Pattern, config: Config, exhaustive: Bool = true) -> String {
        Self.process(input: input, pattern: pattern, config: config, exhaustive: exhaustive).masked
    }

    static func process(input: String, pattern: Pattern, config: Config, exhaustive: Bool = true) -> (masked: String, unmasked: String) {
        guard let token = pattern.first else {
            return ("", "")
        }

        guard let inputChar = input.first else {
            return exhaustive ? (Self.patternToString(pattern, config: config), "") : ("", "")
        }

        let inputRemaining = input.tail
        let tokensRemaining = Array(pattern.suffix(from: 1))

        let (matches, output) = token.write(inputChar)
        let (_, pureInput) = token.read(inputChar)

        let result = process(
                    input: matches ? String(inputRemaining) : input, pattern: tokensRemaining,
                    config: config,
                    exhaustive: exhaustive)


        return (output + result.masked, pureInput + result.unmasked)

    }
}

extension String {
    var tail: ArraySlice<Character> {
        let chars = Array(self)
        return chars.suffix(from: 1)
    }
}
