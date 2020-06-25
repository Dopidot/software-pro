import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Program } from "../models/program.model";
import { Observable } from "rxjs/index";

@Injectable()
export class ProgramService {

    baseUrl: string = 'http://localhost:4000/api/programs';

    constructor(private http: HttpClient) { }

    getPrograms(): Observable<any> {
        return this.http.get<any>(this.baseUrl);
    }

    createProgram(program: Program): Observable<any> {
        return this.http.post<any>(this.baseUrl, program);
    }

    deleteProgram(id: number): Observable<any> {
        return this.http.delete<any>(this.baseUrl + '/' + id);
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