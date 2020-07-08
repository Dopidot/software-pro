export default class EventModel {
    name: string;
    body: string;
    startDate: Date;
    creationDate: Date;
    address: string;
    zipcode: string;
    city: string;
    country: string;
    eventImage: string;

    constructor(name: string, body: string, startDate: Date, creationDate: Date, address: string, zipCode: string, city: string, country: string, eventImage: string) {
        this.name = name;
        this.body = body;
        this.startDate = startDate;
        this.creationDate = creationDate;
        this.address = address;
        this.zipCode = zipCode;
        this.city = city;
        this.country = country;
        this.eventImage = eventImage;
    }
}