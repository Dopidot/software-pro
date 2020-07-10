import { Component, OnInit } from '@angular/core';
import { MenuService } from '../services/menu.service';
import { CalendarKitMonthCellComponent } from '../pages/extra-components/calendar-kit/month-cell/month-cell.component';

@Component({
    selector: 'ngx-events',
    templateUrl: './events.component.html',
    styleUrls: ['./events.component.scss']
})
export class EventsComponent implements OnInit {

    menu = [];
    month = new Date();
    monthCellComponent = CalendarKitMonthCellComponent;

    constructor(
        private menuService: MenuService,
    ) { }

    ngOnInit(): void {
        this.menu = this.menuService.getMenu();
    }

}
