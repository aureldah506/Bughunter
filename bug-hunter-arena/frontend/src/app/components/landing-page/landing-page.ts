import { Component, AfterViewInit, CUSTOM_ELEMENTS_SCHEMA } from '@angular/core';
import { RouterLink } from '@angular/router';

@Component({
  selector: 'app-landing-page',
  standalone: true,
  imports: [RouterLink],
  schemas: [CUSTOM_ELEMENTS_SCHEMA],
  templateUrl: './landing-page.html',
  styleUrls: ['./landing-page.css']
})
export class LandingPageComponent implements AfterViewInit {

  ngAfterViewInit() {
    // On déclare GSAP pour éviter les erreurs TypeScript
    const gsap = (window as any).gsap;
    const ScrollTrigger = (window as any).ScrollTrigger;

    if (gsap) {
      gsap.registerPlugin(ScrollTrigger);

      // 1. Animation du Titre
      gsap.fromTo('.hero-title-line', 
        { y: 40, opacity: 0 },
        { y: 0, opacity: 1, duration: 1, stagger: 0.15, ease: "power3.out" }
      );

      // 2. Animation des éléments qui s'estompent
      gsap.fromTo('.hero-fade',
        { y: 20, opacity: 0 },
        { y: 0, opacity: 1, duration: 1, delay: 0.5, stagger: 0.2, ease: "power2.out" }
      );

      // 3. Animation des cartes (Feature Cards) au scroll
      gsap.fromTo('.feature-card', 
        { y: 60, opacity: 0 },
        { 
          y: 0, 
          opacity: 1, 
          duration: 0.8, 
          stagger: 0.15, 
          ease: "back.out(1.2)",
          scrollTrigger: {
            trigger: '.feature-card',
            start: "top 85%"
          }
        }
      );
    }
  }
}