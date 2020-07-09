import { Component, OnInit } from '@angular/core';
import { MENU_ITEMS } from '../menu/menu';
import { NbThemeService, NbColorHelper } from '@nebular/theme';
import { DayCellComponent } from '../pages/extra-components/calendar/day-cell/day-cell.component';

@Component({
    selector: 'ngx-home',
    templateUrl: './home.component.html',
    styleUrls: ['./home.component.scss']
})
export class HomeComponent implements OnInit {

    data: any;
    options: any;
    themeSubscription: any;
    selectedEvent: any;
    date = new Date();
    events: any;
    dayCellComponent = DayCellComponent;

    menu = MENU_ITEMS;

    users: { name: string, title: string }[] = [
        { name: 'Carla Espinosa', title: 'Nurse' },
        { name: 'Bob Kelso', title: 'Doctor of Medicine' },
        { name: 'Janitor', title: 'Janitor' },
        { name: 'Perry Cox', title: 'Doctor of Medicine' },
        { name: 'Ben Sullivan', title: 'Carpenter and photographer' },
    ];



    constructor(private theme: NbThemeService) {
        this.themeSubscription = this.theme.getJsTheme().subscribe(config => {

            const colors: any = config.variables;
            const chartjs: any = config.variables.chartjs;

            this.data = {
                labels: ['2006', '2007', '2008', '2009', '2010', '2011', '2012'],
                datasets: [{
                    data: [65, 59, 80, 81, 56, 55, 40],
                    label: 'Series A',
                    backgroundColor: NbColorHelper.hexToRgbA(colors.primaryLight, 0.8),
                }, {
                    data: [28, 48, 40, 19, 86, 27, 90],
                    label: 'Series B',
                    backgroundColor: NbColorHelper.hexToRgbA(colors.infoLight, 0.8),
                }],
            };

            this.options = {
                maintainAspectRatio: false,
                responsive: true,
                legend: {
                    labels: {
                        fontColor: chartjs.textColor,
                    },
                },
                scales: {
                    xAxes: [
                        {
                            gridLines: {
                                display: false,
                                color: chartjs.axisLineColor,
                            },
                            ticks: {
                                fontColor: chartjs.textColor,
                            },
                        },
                    ],
                    yAxes: [
                        {
                            gridLines: {
                                display: true,
                                color: chartjs.axisLineColor,
                            },
                            ticks: {
                                fontColor: chartjs.textColor,
                            },
                        },
                    ],
                },
            };
        });
    }

    ngOnInit(): void {
        this.loadEvents();
    }

    ngOnDestroy(): void {
        this.themeSubscription.unsubscribe();
    }

    loadEvents(): void {
        this.events = [new Date(2020, 5, 25), new Date(2020, 5, 9)];

        this.dayCellComponent.prototype.loadEvents(this.events);
    }

    showEvent(event: any): void {
        this.selectedEvent = null;
        let html = event['target'];

        if (html['id'] === 'flagEvent')
        {
            this.selectedEvent = 'Seance entrainement gratuit du 28 au 30 Juin !';
        }
    }
}