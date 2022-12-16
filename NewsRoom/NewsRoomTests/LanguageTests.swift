//
//  LanguageTests.swift
//  NewsRoomTests
//
//  Created by Kunal Shrivastava on 11/25/19.
//  Copyright © 2019 Kunal Shrivastava. All rights reserved.
//

import Foundation

import XCTest
@testable import Mukhya_Samachar

class LanguageTests: XCTestCase {
    func testTranslateMartian() {
        let sut = Language.martian
        
        XCTAssertEqual(sut.translate(text: #"ABCD"#), #"Boinga"#)
        XCTAssertEqual(sut.translate(text: "$10000000"), "$10000000")
        XCTAssertEqual(sut.translate(text: "Mars?"), "Boinga?")
        XCTAssertEqual(sut.translate(text: "20,000 Leagues Under the Sea"), "20,000 Boinga Boinga the Sea")
        XCTAssertEqual(sut.translate(text: "fri3nd"), "boinga")
        XCTAssertEqual(sut.translate(text: "Is there life on Mars."), "Is boinga boinga on Boinga.")
        XCTAssertEqual(sut.translate(text: "ABCD"), "Boinga")
        XCTAssertEqual(sut.translate(text: "aBCD"), "boinga")
        XCTAssertEqual(sut.translate(text: "aBC"), "aBC")
        XCTAssertEqual(sut.translate(text: "aBC"), "aBC")
        XCTAssertEqual(sut.translate(text: "1"), "1")
        XCTAssertEqual(sut.translate(text: "1234"), "1234")
        XCTAssertEqual(sut.translate(text: "1.2.3.4"), "1.2.3.4")
        XCTAssertEqual(sut.translate(text: "S1.2.3.4"), "Boinga")
        XCTAssertEqual(sut.translate(text: "s1.2.3.4"), "boinga")
        XCTAssertEqual(sut.translate(text: "1.2.3.4S"), "boinga")
        XCTAssertEqual(sut.translate(text: "$10000000"), "$10000000")
        XCTAssertEqual(sut.translate(text: "$20,000"), "$20,000")
        XCTAssertEqual(sut.translate(text: "$20,000.12"), "$20,000.12")
        XCTAssertEqual(sut.translate(text: "0.000000016"), "0.000000016")
        XCTAssertEqual(sut.translate(text: "0.0000S0016"), "boinga")
        XCTAssertEqual(sut.translate(text: "73213:2240333"), "73213:2240333")
        XCTAssertEqual(sut.translate(text: multilineText), martianMultilineText)
    }
    
    var multilineText = """
                        Hey Jude, don't make it bad
                        Take a sad song and make it better
                        Remember to let her into your heart
                        Then you can start to make it better

                        Hey Jude, don't be afraid
                        You were made to go out and get her
                        The minute you let her under your skin
                        Then you begin to make it better

                        And anytime you feel the pain
                        Hey Jude, refrain
                        Don't carry the world upon your shoulders
                        For well you know that it's a fool
                        Who plays it cool
                        By making his world a little colder
                        Na-na-na, na, na
                        Na-na-na, na


                        """
    
    var martianMultilineText = """
                        Hey Boinga, boinga boinga it bad
                        Boinga a sad boinga and boinga it boinga
                        Boinga to let her boinga boinga boinga
                        Boinga you can boinga to boinga it boinga

                        Hey Boinga, boinga be boinga
                        You boinga boinga to go out and get her
                        The boinga you let her boinga boinga boinga
                        Boinga you boinga to boinga it boinga

                        And boinga you boinga the boinga
                        Hey Boinga, boinga
                        Boinga boinga the boinga boinga boinga boinga
                        For boinga you boinga boinga boinga a boinga
                        Who boinga it boinga
                        By boinga his boinga a boinga boinga
                        Boinga, na, na
                        Boinga, na


                        """
}
