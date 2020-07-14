/**
 * Class : AppRoutingModule
 * @author Mickael MOREIRA
 * @version 1.0.0 
 */

import { ExtraOptions, RouterModule, Routes } from '@angular/router';
import { NgModule } from '@angular/core';
import {
  NbAuthComponent,
  NbLoginComponent,
  NbLogoutComponent,
  NbRegisterComponent,
  NbRequestPasswordComponent,
  NbResetPasswordComponent,
} from '@nebular/auth';
import { HomeComponent } from './home/home.component';
import { EventsComponent } from './events/events.component';
import { ExercisesComponent } from './exercises/exercises.component';
import { ProgramsComponent } from './programs/programs.component';
import { CoachsComponent } from './coachs/coachs.component';
import { MembersComponent } from './members/members.component';
import { InfosComponent } from './infos/infos.component';
import { InactivityComponent } from './inactivity/inactivity.component';
import { NewsComponent } from './news/news.component';
import { LoginComponent } from './login/login.component';
import { UserService } from './services/user.service';
import { ProgramService } from './services/program.service';
import { HttpClientModule } from "@angular/common/http";
import { FitislyService } from './services/fitisly.service';
import { MenuService } from './services/menu.service';
import { ExerciseService } from './services/exercise.service';
import { CommonService } from './services/common.service';

export const routes: Routes = [
  /*{
    path: 'pages',
    loadChildren: () => import('./pages/pages.module')
      .then(m => m.PagesModule),
  },
  {
    path: 'auth',
    component: NbAuthComponent,
    children: [
      {
        path: '',
        component: NbLoginComponent,
      },
      {
        path: 'login',
        component: NbLoginComponent,
      },
      {
        path: 'register',
        component: NbRegisterComponent,
      },
      {
        path: 'logout',
        component: NbLogoutComponent,
      },
      {
        path: 'request-password',
        component: NbRequestPasswordComponent,
      },
      {
        path: 'reset-password',
        component: NbResetPasswordComponent,
      },
    ],
  },*/
  { path: 'home', component: HomeComponent },
  { path: 'events', component: EventsComponent },
  { path: 'exercises', component: ExercisesComponent },
  { path: 'programs', component: ProgramsComponent },
  { path: 'coachs', component: CoachsComponent },
  { path: 'members', component: MembersComponent },
  { path: 'infos', component: InfosComponent },
  { path: 'inactivity', component: InactivityComponent },
  { path: 'news', component: NewsComponent },
  { path: 'login', component: LoginComponent },
  { path: '', redirectTo: 'home', pathMatch: 'full' },
  { path: '**', redirectTo: 'home' },
];

const config: ExtraOptions = {
  useHash: false,
};

@NgModule({
  imports: [RouterModule.forRoot(routes, config), HttpClientModule],
  exports: [RouterModule],
  providers: [UserService, ProgramService, FitislyService, MenuService, ExerciseService, CommonService],
})
export class AppRoutingModule {
}
