//
//  File.swift
//  
//
//  Created by Kao Li Chi on 2021/5/21.
//

import Foundation
import Fluent
import Vapor

//This is playload model
struct Me: Content {
    var id : UUID?
    var UserName : String
}
