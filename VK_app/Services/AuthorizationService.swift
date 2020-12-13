//
//  AuthorisationService.swift
//  VK_app
//
//  Created by macbook on 25.11.2020.
//

import Foundation
import Alamofire

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
            "scope": "262150",
            "response_type": "token",
            "v": "5.126",
            "revoke": "1"
        ]
        
    // составляем URL из базового адреса сервиса и конкретного пути к ресурсу
        let url = baseUrl+path
    // делаем запрос
        AF.request(url, method: .get, parameters: parameters)
    }
}
