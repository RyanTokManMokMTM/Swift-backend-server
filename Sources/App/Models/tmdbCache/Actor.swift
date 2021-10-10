//
//  File.swift
//  
//
//  Created by Jackson on 7/10/2021.
//

import Foundation
import Fluent
import Vapor

final class ActorInfos : Model,Content{
    static let schema = "actorInfos"
    
    @ID(key: .id)
    var id: UUID? //actor in

    
    
    init(){
        
    }
}
