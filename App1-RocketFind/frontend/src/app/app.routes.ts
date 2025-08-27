import { Routes } from '@angular/router';
import { HomeComponent } from './shared/components/home.component';
import { LoginComponent } from './auth/components/login.component';
import { RegisterComponent } from './auth/components/register.component';
import { AuthGuard } from './auth/guards/auth.guard';

export const routes: Routes = [
  { path: '', component: HomeComponent },
  { path: 'login', component: LoginComponent },
  { path: 'register', component: RegisterComponent },
  { 
    path: 'search', 
    loadComponent: () => import('./home-search/components/property-search.component').then(m => m.PropertySearchComponent)
  },
  {
    path: 'properties/:id',
    loadComponent: () => import('./home-search/components/property-detail.component').then(m => m.PropertyDetailComponent)
  },
  {
    path: 'mortgage-tools',
    loadComponent: () => import('./mortgage-tools/components/mortgage-calculator.component').then(m => m.MortgageCalculatorComponent)
  },
  {
    path: 'dashboard',
    loadComponent: () => import('./dashboard/components/user-dashboard.component').then(m => m.UserDashboardComponent),
    canActivate: [AuthGuard]
  },
  {
    path: 'loan-application',
    loadComponent: () => import('./loan-application/components/loan-application-form.component').then(m => m.LoanApplicationFormComponent),
    canActivate: [AuthGuard]
  },
  {
    path: 'comparison',
    loadComponent: () => import('./comparison/components/property-comparison.component').then(m => m.PropertyComparisonComponent),
    canActivate: [AuthGuard]
  },
  {
    path: 'refinance-calculator',
    loadComponent: () => import('./mortgage-tools/components/refinance-calculator.component').then(m => m.RefinanceCalculatorComponent)
  },
  {
    path: 'extra-payment-calculator',
    loadComponent: () => import('./mortgage-tools/components/extra-payment-calculator.component').then(m => m.ExtraPaymentCalculatorComponent)
  },
  {
    path: 'rent-vs-buy-calculator',
    loadComponent: () => import('./mortgage-tools/components/rent-vs-buy-calculator.component').then(m => m.RentVsBuyCalculatorComponent)
  },
  {
    path: 'market-trends',
    loadComponent: () => import('./market-trends/components/market-trends-dashboard.component').then(m => m.MarketTrendsDashboardComponent)
  },
  {
    path: 'price-history',
    loadComponent: () => import('./market-trends/components/price-history-charts.component').then(m => m.PriceHistoryChartsComponent)
  },
  { path: '**', redirectTo: '' }
];
