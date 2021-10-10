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
        let seachingController = SearchingController()
        // let searchController = Sear
        
        //specify route
        let playgroundAPI = api.grouped("playground")
        let searchAPI = api.grouped("search")
        
        //playground controller
        playgroundAPI.get("getGenre", use: playgroundControllor.getGenre(req:))
        playgroundAPI.get("getActor", use: playgroundControllor.getActor(req:))
        playgroundAPI.get("getDirector", use: playgroundControllor.getDirector(req:))
        playgroundAPI.get("getPreview", use: playgroundControllor.getPreviewResult(req:))
        
        //searching controller
        searchAPI.get("getSearchList",":keyWord",use:seachingController.getSearchingResult(req:))
        searchAPI.get("getSearchResults",":seachKeyWord", use:seachingController.getSearchingFinalResult(req:))
    }
}

