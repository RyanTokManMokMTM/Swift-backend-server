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
        playgroundAPI.get("getgenre", use: playgroundControllor.getGenreById(req:))
        playgroundAPI.get("getallgenres", use: playgroundControllor.getGenreAll(req:))
        playgroundAPI.get("getactors", use: playgroundControllor.getActor(req:))
        playgroundAPI.get("getdirectors", use: playgroundControllor.getDirector(req:))
        
        //Post data
        let previewMiddware = playgroundAPI.grouped(PreviewResultAlgorithmMiddleware())
        previewMiddware.post("getpreview",use : playgroundControllor.postPreviewResult(req:))
        
        
        playgroundAPI.get("test", use: playgroundControllor.postPreviewResult(req:))
//        playgroundAPI.post("getpreview",use : playgroundControllor.postPreviewResult(req:))
        
        //searching controller
        searchAPI.get("getSearchList",":keyWord",use:seachingController.getSearchingResult(req:))
        searchAPI.get("getSearchResults",":seachKeyWord", use:seachingController.getSearchingFinalResult(req:))
    }
}

