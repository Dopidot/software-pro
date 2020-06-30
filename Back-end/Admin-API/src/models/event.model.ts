export default class EventModel {
    name: string;
    body: string;
    startDate: Date;
    creationDate: Date;
    localisation: string;

    constructor(name: string, body: string, startDate: Date, creationDate: Date, localisation: string) {
        this.name = name;
        this.body = body;
        this.startDate = startDate;
        this.creationDate = creationDate;
        this.localisation = localisation;
    }
}