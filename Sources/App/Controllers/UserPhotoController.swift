//
//  File.swift
//  
//
//  Created by Kao Li Chi on 2021/10/20.
//

import Foundation
import Fluent
import Vapor

struct UserPhotoController: RouteCollection{
    
    func boot(routes: RoutesBuilder) throws {

        let photo = routes.grouped("UserPhoto")
//        photo.get(":userID",use: GetUserPhoto)
        photo.group("post"){ lis in
            lis.post(":userID",use: postUserPhoto)
        }

    }

    //--------------------------------取得頭貼--------------------------------//
//    func GetUserPhoto(req: Request) throws -> EventLoopFuture<Response>  {
//
//        return User.find(req.parameters.get("userID"), on: req.db)
//            .unwrap(or: Abort(.notFound))
//            .flatMap{ usr in
//                req.eventLoop.makeSucceededFuture(
//                    req.fileio.streamFile(at:"\(usr.UserPhoto)")
//                )
//            }
//    }

    //--------------------------------檔案上傳---------------------------------//
    func postUserPhoto(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        struct Input: Content {
            var file: File
        }
        let input = try req.content.decode(Input.self)
        
        let path = "./Public/UserPhoto/" + input.file.filename
        
        req.application.fileio.openFile(path: path,
                                               mode: .write,
                                               flags: .allowFileCreation(posixMode: 0x744),
                                               eventLoop: req.eventLoop)
            .flatMap { handle in
                req.application.fileio.write(fileHandle: handle,
                                             buffer: input.file.data,
                                             eventLoop: req.eventLoop)
                    .flatMapThrowing { _ in
                        try handle.close()
                    }

            }
        
        return User.find(req.parameters.get("userID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap{
                
                $0.UserPhoto = input.file.filename
                return $0.update(on: req.db).transform(to: .ok)
               
            }
        
    
    }
    

    
   
  

    
   
}
