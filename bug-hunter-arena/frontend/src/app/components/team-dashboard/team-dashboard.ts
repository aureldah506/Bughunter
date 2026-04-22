import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import { ApiService } from '../../services/api';
import { Component, OnInit, CUSTOM_ELEMENTS_SCHEMA } from '@angular/core'; // Import ici


@Component({
  selector: 'app-team-dashboard',
  standalone: true,
  imports: [CommonModule],
  schemas: [CUSTOM_ELEMENTS_SCHEMA],
  templateUrl: './team-dashboard.html',
  styleUrls: ['./team-dashboard.css']
})
export class TeamDashboardComponent implements OnInit {
  team: any = null;
  isLoading = false;

  // Mapping des IDs de technos vers les noms
  techNames: { [key: number]: string } = {
    1: 'PHP',
    2: 'ReactJS',
    3: 'C++',
    4: 'C#',
    5: 'Mobile'
  };

  constructor(private apiService: ApiService, private router: Router) {}

  ngOnInit() {
    const savedData = localStorage.getItem('team_data');
    if (savedData) {
      this.team = JSON.parse(savedData);
    } else {
      this.router.navigate(['/']);
    }
  }

  spinWheel() {
    this.isLoading = true;
    // Tirage au sort d'une techno (1 à 5)
    const randomTechId = Math.floor(Math.random() * 5) + 1;

    this.apiService.getRandomQuiz(randomTechId).subscribe({
      next: (quizData) => {
        localStorage.setItem('current_quiz', JSON.stringify(quizData));
        localStorage.setItem('current_tech_name', this.techNames[randomTechId]);
        this.router.navigate(['/arena']);
      },
      error: (err) => {
        alert("Erreur lors de la récupération du quiz.");
        this.isLoading = false;
      }
    });
  }

  logout() {
    localStorage.clear();
    this.router.navigate(['/']);
  }
}