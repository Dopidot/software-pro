import { Program } from './program.model';
import { User } from './user.model';

export class Exercise {
    public id: number;
    public name: string;
    public description: string;
    public repeat_number: number;
    public rest_time: number;
    public video_id: string;
    public exerciseimage: string;

    constructor() {}
}