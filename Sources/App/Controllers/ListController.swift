//
//  File.swift
//  
//
//  Created by Kao Li Chi on 2021/9/24.
//

import Foundation
import Fluent
import Vapor

struct ListController: RouteCollection{
    
    func boot(routes: RoutesBuilder) throws {
        
        let lists = routes.grouped("list")
        lists.get(use: GetAllList)
        lists.group("my"){ lis in
            lis.get(":userID",use: GetMyList)
        }
        
        lists.post("new",use: postList)
        lists.put("update",use: updateList)
        lists.group("delete"){ lis in
            lis.delete(":listID",use: deleteList)
        }
    }
    
    
    //--------------------------------get片單--------------------------------//

    func GetAllList(req: Request) throws -> EventLoopFuture<[List]> {

        return  List.query(on: req.db)
            .with(\.$user)
            .sort(\.$updatedOn, .descending) //近期的片單出現在前面
            .all()

    }
    
    func GetMyList(req: Request) throws -> EventLoopFuture<[List]> {

        guard let userID = req.parameters.get("userID") as UUID? else{
            throw Abort(.badRequest)
        }
        
        return  List.query(on: req.db)
            .with(\.$user)
            .filter(List.self, \List.$user.$id == userID )
            .sort(\.$updatedOn, .descending)
            .all()

    }


    //--------------------------------post片單--------------------------------//
    func postList(req: Request) throws -> EventLoopFuture<List> {
        let todo = try req.content.decode(NewList.self)

        return User.query(on: req.db)
            .filter(\.$UserName == todo.UserName)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap{ usr in
                let list = List(Title: todo.Title, user: usr)
                return list.create(on: req.db).map{ list }
            }
    }
    
    //--------------------------------update片單內容--------------------------------//
    
    func updateList(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let update = try req.content.decode(UpdateList.self)

        return List.find(update.listID, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap{
                $0.Title = update.listTitle
                return $0.update(on: req.db).transform(to: .ok)
            }

    }
    
    
    
   //--------------------------------delete片單內容--------------------------------//
   
   func deleteList(req: Request) throws -> EventLoopFuture<HTTPStatus> {
       return List.find(req.parameters.get("listID"), on: req.db)
           .unwrap(or: Abort(.notFound))
           .flatMap{ $0.delete(on: req.db) }
           .transform(to: .ok)
   }
    
    
   
}
