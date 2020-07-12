/**
 * author : Guillaume Tako
 */

export default class ProgramModel {
    id!: bigint;
    name: string;
    description: string;
    programImage: string;
    exercises: bigint[];

    constructor(id: bigint, name: string, description: string, programImage: string, exercises: bigint[]) { //, exercises: ExerciseModel[]) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.programImage = programImage;
        this.exercises = exercises;
    }
}
