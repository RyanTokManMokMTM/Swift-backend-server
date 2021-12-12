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
        let movieController = MovieController()
        
        let movieAPI = api.grouped("movie")
        movieAPI.get("getmoviecard", use: movieController.getMovieByGenre(req:))
//        le  movieAPI = Movie
        // let searchController = Sear
        
        //specify route
        let previewAPI = api.grouped("previewsearch")
        let searchAPI = api.grouped("search")
        
        //playground controller
        previewAPI.get("getgenre", use: playgroundControllor.getGenreById(req:))
        previewAPI.get("getallgenres", use: playgroundControllor.getGenreAll(req:))
        previewAPI.get("getactors", use: playgroundControllor.getActor(req:))
        previewAPI.get("getdirectors", use: playgroundControllor.getDirector(req:))
        
        //Post data
        let previewMiddware = previewAPI.grouped(PreviewResultAlgorithmMiddleware())
        previewMiddware.post("getpreview",use : playgroundControllor.postPreviewResult(req:))
        previewAPI.get("getpreviewlist", use: playgroundControllor.getPreviewMovieList(req:))
        
        
//        playgroundAPI.get("test", use: playgroundControllor.postPreviewResult(req:))
//        playgroundAPI.post("getpreview",use : playgroundControllor.postPreviewResult(req:))
        
//        //searching controller
        searchAPI.get("getrecommandsearch",use:seachingController.getRecommandSeachKey(req:))
//        searchAPI.get("getSearchResults",":seachKeyWord", use:seachingController.getSearchingFinalResult(req:))
    }
}

