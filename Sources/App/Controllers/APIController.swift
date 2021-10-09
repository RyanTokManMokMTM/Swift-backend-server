//
//  File.swift
//  
//
//  Created by Jackson on 9/10/2021.
//

import Foundation
import Vapor
struct APIController : RouteCollection{
    func boot(routes: RoutesBuilder) throws {
        let api = routes.grouped("api")
        
        //specify controller
        //controller instance
        let playgroundControllor = PlaygroundController()
        
        
        //specify route
        let playgroundAPI = api.grouped("playground")
//        let searchAPI = api.grouped("search")
        
        //playground controller
        playgroundAPI.get("getGenre", use: playgroundControllor.getGenre)
        playgroundAPI.get("getActor", use: playgroundControllor.getActor)
        playgroundAPI.get("getDirector", use: playgroundControllor.getDirector)
        
        
        //searching controller
            //....
    }
}

