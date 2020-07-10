/**
 * @license
 * Copyright Akveo. All Rights Reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 */
import { BrowserModule } from '@angular/platform-browser';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { NgModule } from '@angular/core';
import { HttpClientModule } from '@angular/common/http';
import { CoreModule } from './@core/core.module';
import { ThemeModule } from './@theme/theme.module';
import { AppComponent } from './app.component';
import { AppRoutingModule } from './app-routing.module';
import {
    NbChatModule,
    NbDatepickerModule,
    NbDialogModule,
    NbMenuModule,
    NbSidebarModule,
    NbToastrModule,
    NbWindowModule,
} from '@nebular/theme';
import {
    NbAccordionModule,
    NbButtonModule,
    NbCardModule,
    NbListModule,
    NbRouteTabsetModule,
    NbStepperModule,
    NbTabsetModule, NbUserModule,
} from '@nebular/theme';

import {
    NbCalendarModule
} from '@nebular/theme';

import {
    NbCalendarKitModule
} from '@nebular/theme';


import { NgxEchartsModule } from 'ngx-echarts';
import { NgxChartsModule } from '@swimlane/ngx-charts';
import { ChartModule } from 'angular2-chartjs';

import { ChartsRoutingModule, routedComponents } from './pages/charts/charts-routing.module';
import { ChartjsBarComponent } from './pages/charts/chartjs/chartjs-bar.component';
import { ChartjsLineComponent } from './pages/charts/chartjs/chartjs-line.component';
import { ChartjsPieComponent } from './pages/charts/chartjs/chartjs-pie.component';
import { ChartjsMultipleXaxisComponent } from './pages/charts/chartjs/chartjs-multiple-xaxis.component';
import { ChartjsBarHorizontalComponent } from './pages/charts/chartjs/chartjs-bar-horizontal.component';
import { ChartjsRadarComponent } from './pages/charts/chartjs/chartjs-radar.component';
import { D3BarComponent } from './pages/charts/d3/d3-bar.component';
import { D3LineComponent } from './pages/charts/d3/d3-line.component';
import { D3PieComponent } from './pages/charts/d3/d3-pie.component';
import { D3AreaStackComponent } from './pages/charts/d3/d3-area-stack.component';
import { D3PolarComponent } from './pages/charts/d3/d3-polar.component';
import { D3AdvancedPieComponent } from './pages/charts/d3/d3-advanced-pie.component';
import { EchartsLineComponent } from './pages/charts/echarts/echarts-line.component';
import { EchartsPieComponent } from './pages/charts/echarts/echarts-pie.component';
import { EchartsBarComponent } from './pages/charts/echarts/echarts-bar.component';
import { EchartsMultipleXaxisComponent } from './pages/charts/echarts/echarts-multiple-xaxis.component';
import { EchartsAreaStackComponent } from './pages/charts/echarts/echarts-area-stack.component';
import { EchartsBarAnimationComponent } from './pages/charts/echarts/echarts-bar-animation.component';
import { EchartsRadarComponent } from './pages/charts/echarts/echarts-radar.component';
import { ChartjsComponent } from './pages/charts/chartjs/chartjs.component';
import { ChartsComponent } from './pages/charts/charts.component';

import { NbIconModule, NbInputModule, NbTreeGridModule } from '@nebular/theme';
import { Ng2SmartTableModule } from 'ng2-smart-table';

import { TablesRoutingModule } from './pages/tables/tables-routing.module';
import { FsIconComponent } from './pages/tables/tree-grid/tree-grid.component';


import { HomeComponent } from './home/home.component';
import { EventsComponent } from './events/events.component';
import { ExercisesComponent } from './exercises/exercises.component';
import { ProgramsComponent } from './programs/programs.component';
import { CoachsComponent } from './coachs/coachs.component';
import { MembersComponent } from './members/members.component';
import { InfosComponent } from './infos/infos.component';
import { NotificationsComponent } from './notifications/notifications.component';
import { LoginComponent } from './login/login.component';

import { FormsModule } from '@angular/forms';
import { HTTP_INTERCEPTORS } from '@angular/common/http';
import { HttpHeadersInterceptor } from './services/httpHeadersInterceptor';

import { registerLocaleData } from '@angular/common';
import localeFr from '@angular/common/locales/fr';
import { DynamicLocaleId } from './services/dynamicLocaleId';

import { TranslateModule, TranslateLoader } from '@ngx-translate/core';
import { TranslateHttpLoader } from '@ngx-translate/http-loader';
import { HttpClient } from '@angular/common/http';
import { NewsComponent } from './news/news.component';
import { InactivityComponent } from './inactivity/inactivity.component';


const components = [
    ChartjsBarComponent,
    ChartjsLineComponent,
    ChartjsPieComponent,
    ChartjsMultipleXaxisComponent,
    ChartjsBarHorizontalComponent,
    ChartjsRadarComponent,
    D3BarComponent,
    D3LineComponent,
    D3PieComponent,
    D3AreaStackComponent,
    D3PolarComponent,
    D3AdvancedPieComponent,
    EchartsLineComponent,
    EchartsPieComponent,
    EchartsBarComponent,
    EchartsMultipleXaxisComponent,
    EchartsAreaStackComponent,
    EchartsBarAnimationComponent,
    EchartsRadarComponent,
    /*ChartjsComponent,
    ChartjsBarComponent,
    ChartsComponent*/
];


registerLocaleData(localeFr, 'fr');

// AoT requires an exported function for factories
export function HttpLoaderFactory(http: HttpClient) {
    return new TranslateHttpLoader(http);
}


@NgModule({
    declarations: [AppComponent, HomeComponent, EventsComponent, ExercisesComponent, ProgramsComponent, CoachsComponent, MembersComponent, InfosComponent, NotificationsComponent, LoginComponent, NewsComponent, InactivityComponent/*, ...routedComponents, ...components*/],
    imports: [
        BrowserModule,
        BrowserAnimationsModule,
        HttpClientModule,
        AppRoutingModule,
        NbSidebarModule.forRoot(),
        NbMenuModule.forRoot(),
        NbDatepickerModule.forRoot(),
        NbDialogModule.forRoot(),
        NbWindowModule.forRoot(),
        NbToastrModule.forRoot(),
        NbChatModule.forRoot({
            messageGoogleMapKey: 'AIzaSyA_wNuCzia92MAmdLRzmqitRGvCF7wCZPY',
        }),
        CoreModule.forRoot(),
        ThemeModule.forRoot(),
        ThemeModule,
        NbTabsetModule,
        NbRouteTabsetModule,
        NbStepperModule,
        NbCardModule,
        NbButtonModule,
        NbListModule,
        NbAccordionModule,
        NbUserModule,
        NbCalendarModule,
        NbCalendarKitModule,

        ChartsRoutingModule,
        NgxEchartsModule,
        NgxChartsModule,
        ChartModule,

        NbTreeGridModule,
        NbIconModule,
        NbInputModule,
        TablesRoutingModule,
        Ng2SmartTableModule,
        FormsModule,
        TranslateModule.forRoot({
            loader: {
                provide: TranslateLoader,
                useFactory: HttpLoaderFactory,
                deps: [HttpClient]
            }
        })
    ],
    bootstrap: [AppComponent/*, ...routedComponents, ...components*/],
    providers: [{
        provide: HTTP_INTERCEPTORS,
        useClass: HttpHeadersInterceptor,
        multi: true,
    },
    { provide: localeFr, useClass: DynamicLocaleId }],
})



export class AppModule {
}
