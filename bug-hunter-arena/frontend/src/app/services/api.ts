// src/app/services/api.ts

import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class ApiService { 
  
  private baseUrl = 'http://localhost/Bughunter/bug-hunter-arena/backend/public/api';

  constructor(private http: HttpClient) { }

  registerTeam(teamData: any): Observable<any> {
    return this.http.post(`${this.baseUrl}/auth/register`, teamData);
  }

  loginTeam(credentials: any): Observable<any> {
    return this.http.post(`${this.baseUrl}/auth/login`, credentials);
  }

  getRandomQuiz(techId: number): Observable<any> {
    return this.http.get(`${this.baseUrl}/quiz/random?tech=${techId}`);
  }

  validateAnswer(teamId: number, answerId: number): Observable<any> {
    return this.http.post(`${this.baseUrl}/quiz/validate`, { team_id: teamId, answer_id: answerId });
  }
}