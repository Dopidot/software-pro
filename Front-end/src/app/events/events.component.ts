import { Component, OnInit, TemplateRef } from '@angular/core';
import { MenuService } from '../services/menu.service';
import { DayCellComponent } from '../pages/extra-components/calendar/day-cell/day-cell.component';
import { NbDialogService } from '@nebular/theme';
import { CommonService } from '../services/common.service';
import { Event } from '../models/event.model';
import { DatePipe } from '@angular/common';

@Component({
    selector: 'ngx-events',
    templateUrl: './events.component.html',
    styleUrls: ['./events.component.scss']
})
export class EventsComponent implements OnInit {

    menu = [];
    events = [];
    eventsDate: any;
    currentEvent: Event = new Event();
    success = 'success';
    danger = 'danger';
    errorMessage: string;
    popupType: number = 0;
    imageBase64: string;
    imagePath: string;
    imageFile: string;
    date = new Date();
    dayCellComponent = DayCellComponent;

    constructor(
        private menuService: MenuService,
        private dialogService: NbDialogService,
        private commonService: CommonService,
        private datePipe: DatePipe,
    ) { }

    ngOnInit(): void {
        this.menu = this.menuService.getMenu();
        this.loadEvents();
    }

    loadEvents(): void {
        this.eventsDate = [];
        this.dayCellComponent.prototype.loadEvents(this.eventsDate);

        this.commonService.getEvents().subscribe(data => {

            data.forEach(element => {
                this.eventsDate.push(new Date(element['startdate']));
            });

            this.events = data;
            this.date = new Date();
            this.compareDateAndAssignEvent(new Date().toString());
        });
    }

    addEvent(): void {
        this.currentEvent.startDate = this.datePipe.transform(this.date, 'yyyy-MM-dd');
        this.currentEvent.creationDate = this.datePipe.transform(new Date(), 'yyyy-MM-dd');
        this.currentEvent['zipCode'] = this.currentEvent.zipcode.toString();

        this.commonService.createEvent(this.currentEvent, this.imageFile).subscribe(data => {
            let res = data['body']['event'];
            this.imagePath = this.commonService.getPicture(res['eventimage']);

            this.loadEvents();
            this.compareDateAndAssignEvent(this.date.toString());
        });
    }

    updateEvent(): void {
        this.currentEvent.startDate = this.datePipe.transform(this.date, 'yyyy-MM-dd');
        this.currentEvent.creationDate = this.datePipe.transform(new Date(), 'yyyy-MM-dd');
        this.currentEvent['zipCode'] = this.currentEvent.zipcode.toString();

        this.commonService.updateEvent(this.currentEvent['id'], this.currentEvent, this.imageFile).subscribe(data => {
            let res = data['body']['event'];
            
            this.imagePath = this.commonService.getPicture(res['eventimage']);
            this.loadEvents();
        });
    }

    deleteEvent(): void {
        this.commonService.deleteEvent(this.currentEvent['id']).subscribe(data => {
            this.loadEvents();
        });
    }

    showEvent(event: any): void {
        let html = event['target'];

        if (typeof(html['className']) === 'string' && html['className'].indexOf('ng-star-inserted') !== -1)
        {
            this.imagePath = null;
            this.imageBase64 = null;
            this.imageFile = null;
            this.currentEvent = new Event();

            if (html['id'])
            {
                this.compareDateAndAssignEvent(html['id']);
            }
        }
    }

    compareDateAndAssignEvent(date: string): void {
        let index = this.events.findIndex(x => this.internalCompareDate(new Date(x['startdate']), new Date(date)));

        if (index !== -1)
        {
            this.currentEvent = this.events[index];
            this.currentEvent.zipcode = parseInt(this.currentEvent.zipcode);

            this.imagePath = this.currentEvent['eventimage'] ? this.commonService.getPicture(this.currentEvent['eventimage']) : null;
        }
    }

    openPopup(dialog: TemplateRef<any>): void {
        this.dialogService.open(
            dialog
        );
    }

    fileChangeEvent(fileInput: any) {
        if (fileInput.target.files && fileInput.target.files[0]) {
            const reader = new FileReader();

            reader.onload = (e: any) => {
                this.imageBase64 = e.target.result;
            };

            reader.readAsDataURL(fileInput.target.files[0]);
            this.imageFile = fileInput.target.files[0];
        }
    }

    internalCompareDate(date1: Date, date2: Date): boolean {
        if (!date1 || !date2)
            return false;

        if (date1.getDate() !== date2.getDate() || date1.getMonth() !== date2.getMonth() || date1.getFullYear() !== date2.getFullYear())
            return false;

        return true;
    }

    removePicture(): void {
        this.imageBase64 = null; 
        this.imagePath = null; 
        this.imageFile = null;
    }

}
