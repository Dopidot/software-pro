//import ExerciseModel from "./exercise.model";

export default class ProgramModel {
    public id!: number;
    public name!: string;
    public description: string;
    public programImage: string;
    //exercises: ExerciseModel[];

    constructor(name: string, description: string, programImage: string) { //, exercises: ExerciseModel[]) {
        this.name = name;
        this.description = description;
        this.programImage = programImage;
        //this.exercises = exercises;
    }
}
