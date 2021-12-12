import Fluent
import Vapor
import PythonKit

func Pythonsetup(){
    
}


func routes(_ app: Application) throws {
    try app.register(collection: ListMovieController()) //片單內容
    try app.register(collection: ListController())      //片單
    try app.register(collection: CommentController())   //文章留言
    try app.register(collection: ArticleController())   //討論區文章
    try app.register(collection: UserController())      //登入註冊
    try app.register(collection: APIController())     //API stuff
    
    app.get("pythontest"){req  -> EventLoopFuture<Movies>  in
        let uri = URI(string: "https://api.themoviedb.org/3/search/movie?api_key=6dfbbbfc10aa0e69930a9f512c59b66d&include_adult=false&query=Iron&language=zh-TW")
        return req.client.get(uri).flatMapThrowing { res in
           return try res.content.decode(Movies.self)
        }
        
//        let sys = Python.import("sys")
//        sys.path.append("\(app.directory.workingDirectory)py/Cons_sim/")
//        let recommand = Python.import("main")
//        let data = Array(recommand.getRecommandMovies())
//        print(data)
//        return "Testing....!"
    }
}


struct Movies : Content {
    let results : [MovieInfo]
}



struct MovieInfo : Content{
    let id : Int
    let title : String
    let genre_ids : [Int]
    let adult: Bool
    let backdrop_path: String
    let original_language: String
    let original_title: String
    let overview: String
    let popularity : Float
    let poster_path: String
    let release_date: String
    let video: Bool
    let vote_average: Float
    let vote_count: Int
}
