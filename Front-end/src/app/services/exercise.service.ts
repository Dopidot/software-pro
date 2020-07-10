import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Exercise } from "../models/exercise.model";
import { Observable } from "rxjs/index";

@Injectable()
export class ExerciseService {

    baseUrl: string = 'http://localhost:4000/api/exercises';

    constructor(private http: HttpClient) { }

    getExercises(): Observable<any> {
        return this.http.get<any>(this.baseUrl);
    }

    getExerciseById(id: number): Observable<any> {
        return this.http.get<any>(this.baseUrl + '/' + id);
    }

    createExercise(exercise: Exercise): Observable<any> {
        return this.http.post<any>(this.baseUrl, exercise);
    }

    updateExercise(id: number, exercise: Exercise): Observable<any> {
        return this.http.put<any>(this.baseUrl + '/' + id, exercise);
    }

    deleteExercise(id: number): Observable<any> {
        return this.http.delete<any>(this.baseUrl + '/' + id);
    }
}