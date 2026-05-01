import { Component, OnInit, CUSTOM_ELEMENTS_SCHEMA, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { ApiService } from '../../services/api';

@Component({
  selector: 'app-admin',
  standalone: true,
  imports: [CommonModule, FormsModule],
  schemas: [CUSTOM_ELEMENTS_SCHEMA],
  templateUrl: './admin.html',
  styleUrls: ['./admin.css']
})
export class AdminComponent implements OnInit {
  adminKey   = '';
  stats      = signal<any>(null);
  message    = signal('');
  messageOk  = signal(false);
  loading    = signal(false);
  confirmed  = signal(false);

  constructor(public router: Router, private apiService: ApiService) {}

  ngOnInit(): void {
    this.loadStats();
  }

  loadStats(): void {
    this.apiService.getAdminStats().subscribe({
      next: (data) => this.stats.set(data),
      error: () => {}
    });
  }

  resetScores(): void {
    if (!this.adminKey) {
      this.message.set('Clé admin requise');
      this.messageOk.set(false);
      return;
    }
    this.loading.set(true);
    this.apiService.resetScores(this.adminKey).subscribe({
      next: (res) => {
        this.message.set(res.success ?? 'Réinitialisé');
        this.messageOk.set(true);
        this.loading.set(false);
        this.confirmed.set(false);
        this.adminKey = '';
        this.loadStats();
        setTimeout(() => this.message.set(''), 3000);
      },
      error: (err) => {
        this.message.set(err.error?.error ?? 'Clé invalide');
        this.messageOk.set(false);
        this.loading.set(false);
      }
    });
  }
}
