export default class EventModel {
    name: string;
    body: string;
    startdate: Date;
    creationdate: Date;
    address: string;
    zipcode: string;
    city: string;
    country: string;
    eventimage: string;

    constructor(name: string, body: string, startDate: Date, creationDate: Date, address: string, zipCode: string, city: string, country: string, eventImage: string) {
        this.name = name;
        this.body = body;
        this.startdate = startDate;
        this.creationdate = creationDate;
        this.address = address;
        this.zipcode = zipCode;
        this.city = city;
        this.country = country;
        this.eventimage = eventImage;
    }
}