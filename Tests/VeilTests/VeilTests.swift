import XCTest
@testable import Veil

final class VeilTests: XCTestCase {
    func test_can_mask_input() {
        let mask = Veil(pattern: "(###)")
        let result = mask.mask(input: "123")
        XCTAssert(result == "(123)")
    }

    func test_can_process_input() {
        let mask = Veil(pattern: "(###)")
        let (maskedInput, unmaskedInput) = mask.process(input: "(123")
        XCTAssert(maskedInput == "(123)")
        XCTAssert(unmaskedInput == "123")
    }
    
    func test_can_process_letter_pattern() {
        let mask = Veil(pattern: "(AAAA)")
        let (maskedInput, unmaskedInput) = mask.process(input: "Veil")
        XCTAssert(maskedInput == "(Veil)")
        XCTAssert(unmaskedInput == "Veil")
    }

    func test_textfield_input_non_exhaustive() {
        let mask = Veil(pattern: "(###)")
        let (maskedInput, unmaskedInput) = mask.process(input: "12", exhaustive: false)
        XCTAssert(maskedInput == "(12")
        XCTAssert(unmaskedInput == "12")
    }

    func test_cannot_process_digit_pattern() {
        let mask = Veil(pattern: "##.##.####")
        let (maskedInput, unmaskedInput) = mask.process(input: "sometext", exhaustive: false)
        XCTAssertEqual(maskedInput, "")
        XCTAssertEqual(unmaskedInput, "")
    }
    
    func test_can_process_some_digit_pattern() {
        let mask = Veil(pattern: "##.##.####")
        let (maskedInput, unmaskedInput) = mask.process(input: "12andtext", exhaustive: false)
        XCTAssertEqual(maskedInput, "12.")
        XCTAssertEqual(unmaskedInput, "12")
    }

    static var allTests = [
        ("testExample", test_can_mask_input),
    ]
}

final class VeilTokenTests: XCTestCase {
    
    func test_letter_token_writes_letter() {
        let token = Veil.Token(fromCharacter: "A", config: .defaultConf())
        XCTAssert(token == Veil.Token.letter)
        let (matched, output) = token.maskCharacter("y")
        XCTAssert(matched)
        XCTAssert(output == "y")
    }
    func test_digit_token_writes_digit() {
        let token = Veil.Token(fromCharacter: "#", config: .defaultConf())
        let (matched, output) = token.maskCharacter("3")
        XCTAssert(matched)
        XCTAssert(output == "3")
    }

    func test_writting_symbol_token_ignores_input() {
        let token = Veil.Token(fromCharacter: "[", config: .defaultConf())
        let (matched, output) = token.maskCharacter("3")
        XCTAssert(!matched)
        XCTAssert(output == "[")
    }
    

    func test_reading_symbol_is_always_ignored() {
        let token = Veil.Token(fromCharacter: "[", config: .defaultConf())
        let (matched, output) = token.read("[")
        XCTAssert(output == "")
        XCTAssert(token.read("3").1 == "")
    }
    
    
}
