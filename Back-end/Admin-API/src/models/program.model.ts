import ExerciseModel from "./exercise.model";

export default class ProgramModel {
    public id!: number;
    public name!: string;
    public description: string;
    public pictureId: number;
    //exercises: ExerciseModel[];

    constructor(name: string, description: string, pictureId: number) { //, exercises: ExerciseModel[]) {
        this.name = name;
        this.description = description;
        this.pictureId = pictureId;
        //this.exercises = exercises;
    }
}
