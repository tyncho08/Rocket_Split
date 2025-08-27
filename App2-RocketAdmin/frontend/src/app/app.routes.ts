import { Routes } from '@angular/router';
import { LoginComponent } from './auth/components/login.component';
import { AdminGuard } from './auth/guards/admin.guard';

export const routes: Routes = [
  { 
    path: '', 
    redirectTo: '/admin', 
    pathMatch: 'full' 
  },
  { 
    path: 'login', 
    component: LoginComponent 
  },
  {
    path: 'admin',
    loadComponent: () => import('./admin/components/admin-dashboard.component').then(m => m.AdminDashboardComponent),
    canActivate: [AdminGuard]
  },
  {
    path: 'admin/loans',
    loadComponent: () => import('./admin/components/loan-management.component').then(m => m.LoanManagementComponent),
    canActivate: [AdminGuard]
  },
  {
    path: 'admin/loans/:id',
    loadComponent: () => import('./admin/components/loan-review.component').then(m => m.LoanReviewComponent),
    canActivate: [AdminGuard]
  },
  {
    path: 'admin/users',
    loadComponent: () => import('./admin/components/user-management.component').then(m => m.UserManagementComponent),
    canActivate: [AdminGuard]
  },
  { path: '**', redirectTo: '/admin' }
];