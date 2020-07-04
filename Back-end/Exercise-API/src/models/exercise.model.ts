
export default class ExerciseModel{
    name: string;
    description: string;
    repeatNumber: number;
    restTime: string;
    exerciseImage: string;
    videoId: number;
    //programs: ProgramModel[];
    //users: UserModel[];

    constructor(name: string, description: string, repeatNumber: number, restTime: string, exerciseImage: string, videoId: number) {//, programs: ProgramModel[], users: UserModel[]) {
        this.name = name;
        this.description = description;
        this.repeatNumber = repeatNumber;
        this.restTime = restTime;
        this.exerciseImage = exerciseImage;
        this.videoId = videoId;
        //this.programs = programs;
        //this.users = users;
    }
}