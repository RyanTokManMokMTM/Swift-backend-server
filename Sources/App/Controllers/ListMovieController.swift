//
//  File.swift
//  
//
//  Created by Kao Li Chi on 2021/9/24.
//
//
import Foundation
import Fluent
import Vapor

struct ListMovieController: RouteCollection{
    
    func boot(routes: RoutesBuilder) throws {

        //http://127.0.0.1:8080/list/detail/...
        let lists = routes.grouped("list")
        let de = lists.grouped("detail")
        
        de.get(":listID",use: GetListDetail)
        de.post("new",use: postListMovie)
        de.put("update",use: updateListMovie)
        de.group("delete"){ lis in
            lis.delete(":listMovieID",use: deleteListMovie)
        }
    }

    //--------------------------------get某片單內容--------------------------------//
    func GetListDetail(req: Request) throws -> EventLoopFuture<[ListMovie]> {

        guard let listID = req.parameters.get("listID") as UUID? else{
            throw Abort(.badRequest)
        }

        return  ListMovie.query(on: req.db)
            .with(\.$list)
            .join(List.self, on: \ListMovie.$list.$id == \List.$id)
            .filter(List.self, \List.$id == listID )
            .all()

    }

    //--------------------------------post片單內容--------------------------------//
    func postListMovie(req: Request) throws -> EventLoopFuture<ListMovie> {
        let todo = try req.content.decode(NewListMovie.self)

        return User.query(on: req.db)
            .filter(\.$UserName == todo.UserName)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap{ usr in
                List.query(on: req.db)
                    .filter(\.$Title == todo.listTitle)
                    .first()
                    .unwrap(or: Abort(.notFound))
                    .flatMap{ lis in
                        let detail = ListMovie(list: lis, movie: todo.movieID, title: todo.movietitle, posterPath: todo.posterPath, feeling: todo.feeling, ratetext: todo.ratetext)
                        return detail.create(on: req.db).map{ detail }
                    }
            }
    }
    
    //--------------------------------update片單內容--------------------------------//
    
    func updateListMovie(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let update = try req.content.decode(UpdateListMovie.self)

        return ListMovie.find(update.ListDetailID, on: req.db)
            .unwrap(or: Abort(.notFound))   //找不到ID就回傳not found
            .flatMap{
                $0.feeling = update.feeling
                $0.ratetext = update.ratetext
                return $0.update(on: req.db).transform(to: .ok)
            }

    }
    
 
    //--------------------------------delete片單內容--------------------------------//
    
    func deleteListMovie(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return ListMovie.find(req.parameters.get("listMovieID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap{ $0.delete(on: req.db) }
            .transform(to: .ok)
    }

    
   
}
