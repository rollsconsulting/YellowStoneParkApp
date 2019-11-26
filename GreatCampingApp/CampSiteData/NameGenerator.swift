//
//  NameGenerator.swift
//  GreatCampingApp
//
//  Created by Roland Sarkissian on 11/26/19.
//  Copyright © 2019 Rolls Consulting. All rights reserved.
//

import Foundation

func getCamperName() -> String {
    let camperNames = ["Anthony", "Charley", "Julie", "Mike", "Tony", "Annette", "Roman", "Skylar"]
      return camperNames[Int.random(in: 0...camperNames.count-1)]
}


func camperProvidedNumber() -> String {
    let camperNum = ["000 111 2222", "000 112 2222", "000 113 2222", "000 114 2222", "000 115 2222", "000 115 2222", "000 115 2222", "000 117 2222"]
      return camperNum[Int.random(in: 0...camperNum.count-1)]
}


func NATOPhoneticAlphabet() -> [String] {
    return ["Alfa",
            "Bravo",
            "Charlie",
            "Delta",
            "Echo",
            "Foxtrot",
            "Golf",
            "Hotel",
            "India",
            "Juliett",
            "Kilo",
            "Lima",
            "vMike",
            "November",
            "Oscar",
            "Papa",
            "Quebec",
            "Romeo",
            "Sierra",
            "Tango",
            "Uniform",
            "Victor",
            "Whiskey",
            "X-ray",
            "Yankee",
            "Zulu"]
}
