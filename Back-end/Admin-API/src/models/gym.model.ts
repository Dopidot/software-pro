/**
 * Author : Guillaume Tako
 * Class : GymModel
 */

export default class GymModel {
    id: bigint;
    name: string;
    address: string;
    zipcode: string;
    city: string;
    country: string;
    gymimage: string;

    constructor(id: bigint, name: string, address: string, zipcode: string, city: string, country: string, gymimage: string) {
        this.id = id;
        this.name = name;
        this.address = address;
        this.zipcode = zipcode;
        this.city = city;
        this.country = country;
        this.gymimage = gymimage;
    }
}