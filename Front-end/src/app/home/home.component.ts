/**
 * Component : HomeComponent
 * @author Mickael MOREIRA
 * @version 1.0.0 
 */

import { Component, OnInit } from '@angular/core';
import { FitislyService } from '../services/fitisly.service';
import { MenuService } from '../services/menu.service';
import { NbThemeService, NbColorHelper } from '@nebular/theme';
import { DatePipe } from '@angular/common';
import { TranslateService } from '@ngx-translate/core';

@Component({
    selector: 'ngx-home',
    templateUrl: './home.component.html',
    styleUrls: ['./home.component.scss']
})
export class HomeComponent implements OnInit {

    menu = [];
    data: any;
    options: any = {};
    data2: any;
    options2: any = {};
    themeSubscription: any;
    genderDatasetMen: number[] = [7];
    genderDatasetWomen: number[] = [7];
    ageStats: number[] = [];
    showGenderChart: boolean = false;
    titleMen = '';
    titleWomen = '';
    titleYearsOld = '';
    titleUser = '';

    constructor(
        private fitisly: FitislyService,
        private menuService: MenuService,
        private theme: NbThemeService,
        private datePipe: DatePipe,
        private translate: TranslateService,
    ) { }

    ngOnInit(): void {
        this.menu = this.menuService.getMenu();

        this.translate.get(['HOME_MEN', 'HOME_WOMEN', 'HOME_YEARS_OLD', 'HOME_USERS']).subscribe((res: string) => {

            this.titleMen = res['HOME_MEN'];
            this.titleWomen = res['HOME_WOMEN'];
            this.titleYearsOld = res['HOME_YEARS_OLD'];
            this.titleUser = res['HOME_USERS'];

            this.loadConnectionByGender();
            this.loadAgeStats();
        });
    }

    loadConnectionByGender(): void {
        let index = 0;

        for (let i = 13; i > 6; i--) {
            this.loadConnectionByGenderPerDay(i, index);
            index++;
        }
    }

    loadConnectionByGenderPerDay(minusDay: number, index: number): void {
        this.fitisly.getConnectionByGender(this.getPastDate(minusDay, 2)).subscribe(data => {
            let res = data['body']['connections'];
            this.genderDatasetMen[index] = res['men'];
            this.genderDatasetWomen[index] = res['women'];

            this.initGenderChart();
        });
    }

    loadAgeStats(): void {
        this.fitisly.getUserAgeStats().subscribe(data => {
            let res = data['body']['data']['statistics'];

            this.ageStats.push(res['less_than_eighteen']);
            this.ageStats.push(res['eighteen_to_twenty_five']);
            this.ageStats.push(res['twenty_six_to_thirty']);
            this.ageStats.push(res['thirty_one_to_thirty_five']);
            this.ageStats.push(res['more_than_thirty_five']);

            this.initAgeChart();
        });
    }

    getPastDate(day: number, format: number): string {
        let result = '';
        const date = new Date(2020, 6, 13);
        date.setDate(date.getDate() - day);

        if (format === 1) {
            result = this.datePipe.transform(date, 'dd MMM');
        }
        else {
            result = this.datePipe.transform(date, 'yyyy-MM-dd');
        }

        return result;
    }

    initGenderChart(): void {
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
                    label: this.titleMen,
                    backgroundColor: NbColorHelper.hexToRgbA(colors.primaryLight, 0.8),
                }, {
                    data: this.genderDatasetWomen,
                    label: this.titleWomen,
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
            this.showGenderChart = true;
        });
    }

    initAgeChart(): void {
        this.themeSubscription = this.theme.getJsTheme().subscribe(config => {

            const colors = config.variables;
            const echarts: any = config.variables.echarts;

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
                        '-18 ' + this.titleYearsOld,
                        '18 - 25 ' + this.titleYearsOld,
                        '26 - 30 ' + this.titleYearsOld,
                        '31 - 35 ' + this.titleYearsOld,
                        '+35 ' + this.titleYearsOld
                    ],
                    textStyle: {
                        color: echarts.textColor,
                    },
                },
                series: [
                    {
                        name: this.titleUser,
                        type: 'pie',
                        radius: '50%',
                        center: ['50%', '50%'],
                        data: [
                            { value: this.ageStats[0], name: '-18 ' + this.titleYearsOld },
                            { value: this.ageStats[1], name: '18 - 25 ' + this.titleYearsOld },
                            { value: this.ageStats[2], name: '26 - 30 ' + this.titleYearsOld },
                            { value: this.ageStats[3], name: '31 - 35 ' + this.titleYearsOld },
                            { value: this.ageStats[4], name: '+35 ' + this.titleYearsOld },
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
}