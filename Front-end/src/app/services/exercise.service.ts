/**
 * Service : ExerciseService
 * @author Mickael MOREIRA
 * @version 1.0.0 
 */

import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Exercise } from "../models/exercise.model";
import { Observable } from "rxjs/index";
import { ApiConfig } from '../../../src/api.config';

@Injectable()
export class ExerciseService {

    apiConfig: ApiConfig = new ApiConfig();
    baseUrlHttp: string;

    constructor(private http: HttpClient) {
        this.baseUrlHttp = this.apiConfig.adminApiUrl + '/api/exercises';
     }

    getExercises(): Observable<any> {
        return this.http.get<any>(this.baseUrlHttp);
    }

    getExerciseById(id: number): Observable<any> {
        return this.http.get<any>(this.baseUrlHttp + '/' + id);
    }

    getPicture(exerciseImage: string): string {
        return this.apiConfig.adminApiUrl + '/' + exerciseImage;
    }

    createExercise(exercise: Exercise, file: any): Observable<any> {
        let form = this.createFormData(exercise, 'exerciseImage', file);

        return this.http.post<any>(this.baseUrlHttp, form);
    }

    updateExercise(id: number, exercise: Exercise, file: any): Observable<any> {
        let form = this.createFormData(exercise, 'exerciseImage', file);

        return this.http.put<any>(this.baseUrlHttp + '/' + id, form);
    }

    deleteExercise(id: number): Observable<any> {
        return this.http.delete<any>(this.baseUrlHttp + '/' + id);
    }

    createFormData(obj: any, imageAttribut: string, file: any): FormData {
        let formData = new FormData(); 
        Object.keys(obj).forEach(key => formData.append(key, obj[key]));

        if (file)
        {
            formData.set(imageAttribut, file, file.name);
        }

        return formData;
    }
}