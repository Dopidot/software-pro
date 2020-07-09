import { Component } from '@angular/core';
import { NbCalendarDayCellComponent } from '@nebular/theme';

@Component({
  selector: 'ngx-day-cell',
  templateUrl: 'day-cell.component.html',
  styleUrls: ['day-cell.component.scss'],
  host: { '(click)': 'onClick()', 'class': 'day-cell' },
})
export class DayCellComponent extends NbCalendarDayCellComponent<Date> {

    events: any;

    ngOnInit(): void {
    }

    loadEvents(events: any) : void {
        this.events = events;
    }

    compareDate(date: Date): boolean {
        let result = false;

        this.events.forEach(item => {
            if (this.internalCompareDate(item, date)) {
                result = true;
                return result;
            }
        });
        
        return result;
    }

    internalCompareDate(date1: Date, date2: Date): boolean {
        if (!date1 || !date2)
            return false;

        if (date1.getDate() !== date2.getDate() || date1.getMonth() !== date2.getMonth() || date1.getFullYear() !== date2.getFullYear())
            return false;

        return true;
    }
}
