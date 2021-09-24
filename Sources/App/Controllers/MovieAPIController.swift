//
//  MovieAPIController.swift
//  
//
//  Created by Kao Li Chi on 2021/5/1.
//

import Foundation
import Vapor

struct MovieAPIController: RouteCollection{
    
    // 把routes寫在這裡
    func boot(routes: RoutesBuilder) throws {
        
        // ROUTE GROUPS
        let api = routes.grouped("movieAPI")
        
        api.get(use: all)
        api.get(":movieID",use: findMovie)
    }
    
    
    
    func all(_ req: Request) throws -> EventLoopFuture<[Movie]>{
        Movie.query(on: req.db).all()
    }
    
    func findMovie(req: Request) throws -> EventLoopFuture<Movie>{
        Movie.find(req.parameters.get("movieID"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    
}
