/**
 * Component : HomeComponent
 * @author Mickael MOREIRA
 * @version 1.0.0 
 */

import { Component, OnInit } from '@angular/core';
import { DayCellComponent } from '../pages/extra-components/calendar/day-cell/day-cell.component';
import { FitislyService } from '../services/fitisly.service';
import { MenuService } from '../services/menu.service';
import { NbThemeService, NbColorHelper } from '@nebular/theme';
import { DatePipe } from '@angular/common';
import { ChartjsBarComponent } from '../pages/charts/chartjs/chartjs-bar.component';

@Component({
    selector: 'ngx-home',
    templateUrl: './home.component.html',
    styleUrls: ['./home.component.scss']
})
export class HomeComponent implements OnInit {

    chart1: ChartjsBarComponent;
    data: any;
    options: any = {};
    data2: any;
    options2: any;
    themeSubscription: any;
    genderDatasetMen = [];
    genderDatasetWomen = [];

    selectedEvent: any;
    events: any;
    menu = [];
    users = [];
    date = new Date();
    currentDate = new Date();
    dayCellComponent = DayCellComponent;

    constructor(
        private fitisly: FitislyService,
        private menuService: MenuService,
        private theme: NbThemeService,
        private datePipe: DatePipe,
    ) {
        
     }

    ngOnInit(): void {
        this.menu = this.menuService.getMenu();
        this.loadConnectionByGender();
        this.loadUsers();
        this.loadEvents();
        
    }

    ngAfterViewInit() {
        this.themeSubscription = this.theme.getJsTheme().subscribe(config => {

            const colors = config.variables;
            const echarts: any = config.variables.echarts;
            const titleYearsOld = 'years old';

            this.options = {
                backgroundColor: echarts.bg,
                color: [colors.warningLight, colors.infoLight, colors.dangerLight, colors.successLight, colors.primaryLight],
                tooltip: {
                    trigger: 'item',
                    formatter: '{a} <br/>{b} : {c} ({d}%)',
                },
                legend: {
                    orient: 'vertical',
                    left: 'left',
                    data: [
                        '-18 ' + titleYearsOld, 
                        '18 - 25 ' + titleYearsOld, 
                        '26 - 30 ' + titleYearsOld, 
                        '31 - 35 ' + titleYearsOld, 
                        '+35 ' + titleYearsOld
                    ],
                    textStyle: {
                        color: echarts.textColor,
                    },
                },
                series: [
                    {
                        name: 'Users',
                        type: 'pie',
                        radius: '50%',
                        center: ['50%', '50%'],
                        data: [
                            { value: 335, name: '-18 ' + titleYearsOld },
                            { value: 310, name: '18 - 25 ' + titleYearsOld },
                            { value: 234, name: '26 - 30 ' + titleYearsOld },
                            { value: 135, name: '31 - 35 ' + titleYearsOld },
                            { value: 1548, name: '+35 ' + titleYearsOld },
                        ],
                        itemStyle: {
                            emphasis: {
                                shadowBlur: 10,
                                shadowOffsetX: 0,
                                shadowColor: echarts.itemHoverShadowColor,
                            },
                        },
                        label: {
                            normal: {
                                textStyle: {
                                    color: echarts.textColor,
                                },
                            },
                        },
                        labelLine: {
                            normal: {
                                lineStyle: {
                                    color: echarts.axisLineColor,
                                },
                            },
                        },
                    },
                ],
            };

        });
    }

    ngOnDestroy(): void {
        this.themeSubscription.unsubscribe();
    }

    loadUsers(): void {
        this.fitisly.getUsers().subscribe(data => {
            let users = data['body']['list'];

            let lastUsers = users.slice(1).slice(-10);

            lastUsers.forEach(element => {
                this.fitisly.getUserInfo(element['account_id']).subscribe(info => {
                    info = info['body']['user_profile'];

                    this.users.push({
                        name: this.capitalize(info['pseudonyme']),
                        title: this.capitalize(info['first_name']),
                        picture: this.fitisly.getPicture(info['profile_picture'])
                    });

                });
            });
        });
    }

    capitalize(s: string): string {
        return s.charAt(0).toUpperCase() + s.slice(1);
    }

    loadEvents(): void {
        this.events = [new Date(2020, 5, 25), new Date(2020, 5, 9)];

        this.dayCellComponent.prototype.loadEvents(this.events);
    }

    showEvent(event: any): void {
        this.selectedEvent = null;
        let html = event['target'];

        if (html['id'] === 'flagEvent') {
            this.selectedEvent = 'Seance entrainement gratuit du 28 au 30 Juin !';
        }
    }

    loadConnectionByGender(): void {
        for(let i = 7; i < 14; i++)
        {
            this.fitisly.getConnectionByGender(this.getPastDate(i, 2)).subscribe(data => {
                let res = data['body']['connections'];
                this.genderDatasetMen.push(res['men']);
                this.genderDatasetWomen.push(res['women']);
            });

            if(i === 13)
            {
                this.initChart();
            }
        }
    }

    getPastDate(day: number, format: number): string {
        let result = '';
        const date = new Date();
        date.setDate(date.getDate() - day);

        if(format === 1)
        {
            result = this.datePipe.transform(date, 'dd MMM');
        }
        else
        {
            result = this.datePipe.transform(date, 'yyyy-MM-dd');
        }

        return result;
    }

    initChart(): void {
        this.themeSubscription = this.theme.getJsTheme().subscribe(config => {

            const colors: any = config.variables;
            const chartjs: any = config.variables.chartjs;
      
            this.data2 = {
              labels: [
                  this.getPastDate(13, 1), 
                  this.getPastDate(12, 1), 
                  this.getPastDate(11, 1), 
                  this.getPastDate(10, 1), 
                  this.getPastDate(9, 1), 
                  this.getPastDate(8, 1), 
                  this.getPastDate(7, 1)],
              datasets: [{
                data: this.genderDatasetMen,
                label: 'Homme',
                backgroundColor: NbColorHelper.hexToRgbA(colors.primaryLight, 0.8),
              }, {
                data: this.genderDatasetWomen,
                label: 'Femme',
                backgroundColor: NbColorHelper.hexToRgbA(colors.infoLight, 0.8),
              }],
            };
      
            this.options2 = {
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
}