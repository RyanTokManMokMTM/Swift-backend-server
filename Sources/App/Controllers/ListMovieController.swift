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
//        de.post(use: create)
//        de.group("delete"){ lis in
//            lis.delete(":commentID",use: delete)
//        }
    }

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

//
//    func create(req: Request) throws -> EventLoopFuture<Comment> {
//        let todo = try req.content.decode(CommentTodo.self)
//
//        return User.query(on: req.db)
//            .filter(\.$UserName == todo.UserName)
//            .first()
//            .unwrap(or: Abort(.notFound))
//            .flatMap{ usr in
//                Article.query(on: req.db)
//                    .filter(\.$id == todo.ArticleID)
//                    .first()
//                    .unwrap(or: Abort(.notFound))
//                    .flatMap{ art in
//                        let comment = Comment(Text: todo.Text, user: usr, article: art, LikeCount: todo.LikeCount)
//                        return comment.create(on: req.db).map{ comment }
//                    }
//            }
//    }
//
//    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
//        return Comment.find(req.parameters.get("commentID"), on: req.db)
//            .unwrap(or: Abort(.notFound))
//            .flatMap{ $0.delete(on: req.db) }
//            .transform(to: .ok)
//    }

    
   
}
