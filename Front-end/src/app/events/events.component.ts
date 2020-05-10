import { Component, OnInit } from '@angular/core';
import { MENU_ITEMS } from '../menu/menu';
import { CalendarKitMonthCellComponent } from '../pages/extra-components/calendar-kit/month-cell/month-cell.component';

@Component({
  selector: 'ngx-events',
  templateUrl: './events.component.html',
  styleUrls: ['./events.component.scss']
})
export class EventsComponent implements OnInit {

  constructor() { }

  ngOnInit(): void {
  }

  menu = MENU_ITEMS;

  month = new Date();
  monthCellComponent = CalendarKitMonthCellComponent;

}
