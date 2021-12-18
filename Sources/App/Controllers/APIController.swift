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
        let trailerController = TrailerVideoController()
        
        let movieAPI = api.grouped("movie")
        movieAPI.get("getmoviecard", use: movieController.getMovieByGenre(req:))
        
        //specify route
        //api/previewsearch
        //api/search
        //api/trailer
        let previewAPI = api.grouped("previewsearch")
        let searchAPI = api.grouped("search")
        let trailerAPI = api.grouped("video")
        
        //previewsearch controller
        //api/previewsearch/get/genre
        //api/previewsearch/get/genre/{id}
        //api/previewsearch/get/actor
        //api/previewsearch/get/actor/{id}
        previewAPI.get("getgenre", use: playgroundControllor.getGenreById(req:))
        previewAPI.get("getallgenres", use: playgroundControllor.getGenreAll(req:))
        previewAPI.get("getactors", use: playgroundControllor.getActor(req:))
        previewAPI.get("getdirectors", use: playgroundControllor.getDirector(req:))
        
        //api/previewsearch/post/preview
        //api/previewsearch/get/previewlist
        let previewMiddware = previewAPI.grouped(PreviewResultAlgorithmMiddleware())
        previewMiddware.post("getpreview",use : playgroundControllor.postPreviewResult(req:))
        previewAPI.get("getpreviewlist", use: playgroundControllor.getPreviewMovieList(req:))

        //api/search/get/recommandsearch
        searchAPI.get("getrecommandsearch",use:seachingController.getRecommandSeachKey(req:))

        //api/trailer/get/trailer
        trailerAPI.get("trailers",use:trailerController.getRecommandVideo(req:))
    }
}

