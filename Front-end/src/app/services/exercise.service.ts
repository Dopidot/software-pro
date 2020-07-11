import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Exercise } from "../models/exercise.model";
import { Observable } from "rxjs/index";

@Injectable()
export class ExerciseService {

    baseUrl: string = 'http://localhost:4000';
    baseUrlHttp: string = this.baseUrl + '/api/exercises';

    private headers = new HttpHeaders({
        'Content-Type': 'multipart/form-data',
    });

    constructor(private http: HttpClient) { }

    getExercises(): Observable<any> {
        return this.http.get<any>(this.baseUrlHttp);
    }

    getExerciseById(id: number): Observable<any> {
        return this.http.get<any>(this.baseUrlHttp + '/' + id);
    }

    getPicture(exerciseImage: string): string {
        return this.baseUrl + '/' + exerciseImage;
    }

    createExercise(exercise: Exercise): Observable<any> {
        return this.http.post<any>(this.baseUrlHttp, exercise/*, { headers: headers }*/);
    }

    updateExercise(id: number, exercise: Exercise): Observable<any> {
        return this.http.put<any>(this.baseUrlHttp + '/' + id, exercise/*, { headers: this.headers }*/);
    }

    deleteExercise(id: number): Observable<any> {
        return this.http.delete<any>(this.baseUrlHttp + '/' + id);
    }
}