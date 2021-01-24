//
//  AuthorisationService.swift
//  VK_app
//
//  Created by macbook on 25.11.2020.
//

import Foundation
import Alamofire
import SwiftyJSON
//import Firebase

class AuthorizationService {

    // базовый URL сервиса
    let baseUrl = "https://oauth.vk.com"
    // id client
    let client_id = "7697149"

    // метод для загрузки данных, в качестве аргументов получает город
    func getVKToken() {
        
    // путь для получения погоды за 5 дней
        let path = "/authorize"
    // параметры, город, единицы измерения градусы, ключ для доступа к сервису
        let parameters: Parameters = [
            "client_id": client_id,
            "display": "mobile",
            "redirect_uri": "https://oauth.vk.com/blank.html",
            "scope": "270342",//"262150",
            "response_type": "token",
            "v": "5.126",
            "revoke": "1"
        ]
        
    // составляем URL из базового адреса сервиса и конкретного пути к ресурсу
        let url = baseUrl+path
    // делаем запрос
        Alamofire.request(url, method: .get, parameters: parameters)
    }
    
    /*func getProfileInfo(){
        
        let path = "/method/account.getProfileInfo?"
        let parameters: Parameters = [
            "access_token": Session.storedSession.token,
            "v": Config.apiVersion
        ]
        let url = Config.apiUrl+path
        AF.request(url, method: .get, parameters: parameters).responseJSON {response in
            guard let data = response.data else {return}
            do {
                let json = try JSON(data: data)
                let result = json["response"]
                let userJSON: [String: Any] = {
                    return [
                        "id": result["id"].stringValue,
                        "name": result["first_name"].stringValue + " " + result["last_name"].stringValue
                    ]
                }()
                let user_id = result["id"].intValue
                Config.user_id_firebase = user_id
                Config.db.collection("users").document("\(user_id)").setData(userJSON) { error in
                    if let error = error {
                        print("Error adding user: \(error)")
                    } else {
                        print("User updated with ID:\(user_id)")
                    }
                }
            } catch {
                print (error)
            }
        }
    }*/
}
