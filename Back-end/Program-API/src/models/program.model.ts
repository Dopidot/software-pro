/**
 * Author : Guillaume Tako
 * Class : ProgramModel
 */

export default class ProgramModel {
    id: bigint;
    name: string;
    description: string;
    programimage: string;
    exercises: bigint[];

    constructor(id: bigint, name: string, description: string, programimage: string, exercises: bigint[]) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.programimage = programimage;
        this.exercises = exercises;
    }
}
