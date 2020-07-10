import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { User } from "../models/user.model";
import { Observable } from "rxjs/index";

@Injectable()
export class FitislyService {

    baseUrl: string = 'http://51.178.16.171:8150/';

    constructor(private http: HttpClient) { }

    getUsers(): Observable<any> {
        return this.http.get<any>(this.baseUrl + 'get-users');
    }

    getUserInfo(id: number): Observable<any> {
        return this.http.get<any>(this.baseUrl + 'get-user-profile/id/' + id);
    }

    getCoachs(): Observable<any> {
        return this.http.get<any>(this.baseUrl + 'get-all-coachs');
    }

    getPicture(pictureId: string): string {
        return this.baseUrl + 'get-user-profile-picture/' + pictureId;
    }

    /*getUserById(id: number): Observable<User> {
        return this.http.get<User>(this.baseUrl + '/' + id);
    }*/

    /*getUsers(): Observable<ApiResponse> {
        return this.http.get<ApiResponse>(this.baseUrl);
    }

    getUserById(id: number): Observable<ApiResponse> {
        return this.http.get<ApiResponse>(this.baseUrl + id);
    }

    createUser(user: User): Observable<ApiResponse> {
        return this.http.post<ApiResponse>(this.baseUrl, user);
    }

    updateUser(user: User): Observable<ApiResponse> {
        return this.http.put<ApiResponse>(this.baseUrl + user.id, user);
    }

    deleteUser(id: number): Observable<ApiResponse> {
        return this.http.delete<ApiResponse>(this.baseUrl + id);
    }*/
}