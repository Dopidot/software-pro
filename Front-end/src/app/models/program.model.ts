import { Exercise } from './exercise.model';

export class Program {

    public id: number;
    public name: string;
    public description: string;
    public pictureId: number;
    public exercises: Exercise[];

    constructor() {}
}