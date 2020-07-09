import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { User } from "../models/user.model";
import { Observable } from "rxjs/index";


@Injectable()
export class StatusService {

    constructor(private http: HttpClient) { }

    isOnline(baseUrl): Observable<any> {
        return this.http.get<any>(baseUrl);
    }

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