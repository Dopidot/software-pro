/**
 * author : Guillaume Tako
 */

export default class ExerciseModel {
    id: bigint;
    name: string;
    description: string;
    repeatnumber: number;
    resttime: string;
    exerciseimage: string;

    constructor(id: bigint, name: string, description: string, repeatnumber: number, resttime: string, exerciseimage: string) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.repeatnumber = repeatnumber;
        this.resttime = resttime;
        this.exerciseimage = exerciseimage;
    }
}