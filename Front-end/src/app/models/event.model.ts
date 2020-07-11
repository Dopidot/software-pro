export class Event {
    public id: number;
    public name: string;
    public body: string;
    public startDate: string;
    public creationDate: string;
    public eventImage: string;
    public address: string;
    public zipcode: any;
    public city: string;
    public country: string;

    constructor() {
        this.country = 'France';
    }
}