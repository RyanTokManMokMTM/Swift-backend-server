//
//  File.swift
//  
//
//  Created by Kao Li Chi on 2021/5/21.
//

import Vapor

//註冊時客戶端傳回的資訊//
struct UserRegister: Content {
    var user_name: String
    var email: String
    var password: String
    var confirm_password: String // 確認密碼
}

//格式驗證
extension UserRegister: Validatable {
    static func validations(_ validations: inout Validations) {
        // email格式須符合`.email`格式
        validations.add("email", as: String.self, is: .email, required: true)
        // password需為8~16碼
        validations.add("password", as: String.self, is: .count(8...16))
    }
}
