# EduCam AI - UI/UX Design Prompt for Stitch Design

## Project Overview
EduCam AI is an AI-powered educational platform for Cameroonian secondary school students (Terminale C/D, Premiere C, Seconde C) and their teachers. The app runs on Flutter (mobile Android first).

## Design System Reference
- **Primary**: #0D1B2A (dark navy)
- **Accent**: #4F46E5 (indigo)
- **Highlight**: #F59E0B (amber)
- **Background**: #F8FAFC (light gray)
- **Surface**: #FFFFFF
- **Success**: #10B981 (green)
- **Error**: #EF4444 (red)
- **Font**: Poppins / PlusJakartaSans
- **Border radius**: 12-20px
- **Card style**: White cards with soft shadow, 16px radius, 0.5px border

## Subject Colors
- Math: #4F46E5 (indigo)
- SVT (Biology): #10B981 (green)
- Histoire-Géo: #F59E0B (amber)
- Physique: #EF4444 (red)
- Français: #EC4899 (pink)
- Anglais: #06B6D4 (cyan)

---

## Screens to Design (24 screens)

### 1. Onboarding & Auth
#### 1.1 Splash Screen
- Gradient background (#0D1B2A → #312E81)
- Centered logo (white square with rounded corners)
- Loading spinner
- Auto-navigates after session check

#### 1.2 Role Selection
- Two large cards: "Élève" (indigo accent) + "Professeur" (primary)
- Each card: icon, title, subtitle, arrow
- Animated entrance (fade + slide)

#### 1.3 Login/Register Form
- Toggle between login & register
- Fields: email, password (login) + name, class dropdown (register)
- Role-aware CTA button color
- Back button to role selection

### 2. Student Screens (Bottom Nav: 5 tabs)

#### 2.1 Student Dashboard
- **Header**: Greeting with student name, avatar circle
- **Stats Row**: 4 cards (6 Cours, 2 Devoirs, 14.5 Moy, 12h)
- **Teacher Updates**: Horizontal scroll cards with teacher avatars
- **Continue Learning**: Horizontal course cards with progress bars
- **Upcoming Assignments**: Vertical list with due dates
- **Quick Access**: 4 icon buttons (TutorBot, Correction, Documents, Vidéos)

#### 2.2 Student Courses
- **Search bar** at top
- **Filter chips**: Tous, Maths, SVT, Histoire, Physique, Français, Anglais
- **Course list**: Cards with subject color bar, icon, title, subtitle, progress bar, lesson count

#### 2.3 Course Detail (4 tabs)
- **Tab 1 - Leçons**: List of lesson cards (video/pdf icons, title, description)
- **Tab 2 - Exercices**: List with score badges, action buttons
- **Tab 3 - Quiz**: Quiz cards with time limit, question count
- **Tab 4 - Annales**: Past exam papers by year
- **FAB**: Convert to video / Download actions per item

#### 2.4 Take Quiz Screen
- **Top**: Progress bar (Question 3/10), timer
- **Question area**: Question text + 4 option cards (A/B/C/D)
- **Navigation**: Previous / Next buttons
- **Submit**: End screen with score (14/20), pass/fail status, review all answers

#### 2.5 Student Documents
- **Category chips**: Tous, Cours, Exercices, Notes
- **Document list**: File icon, name, category, date, size
- **FAB**: Upload button → bottom sheet with 3 options (Camera, File, Cloud)

#### 2.6 Student Assignments
- **Section 1**: "Urgent" amber header, exercise cards with due dates
- **Section 2**: "Complété" green header, graded items with scores
- **Grades by subject**: Compact list with subject name and avg

#### 2.7 Student Profile
- **Header**: Avatar (initials), name, class
- **Stats card**: 3 metrics (Moyenne 14.5, Rang 5/42, Assiduité 94%)
- **Grades list**: Per-subject rows with color dots and averages
- **Settings toggles**: Mode sombre, Notifications, Langue (EN/FR/FUL/EWO)
- **Logout button**

### 3. Teacher Screens (Bottom Nav: 4 tabs)

#### 3.1 Teacher Dashboard
- **Stats row**: 128 Élèves, 4 Classes, 8 À corriger, 82% Réussite
- **Recent submissions**: List of student work needing review
- **Class overview**: Cards for Terminale C/D, Premiere C, Seconde C with pass rates
- **Quick actions**: Add content, grade, message

#### 3.2 Teacher Courses
- **Course cards**: Subject color, title, class name, progress, action chips (Leçons/Exercices/Quiz/Annales)
- **Tap →** Course detail with 4 tabs
- **Each tab**: Items list + FAB to add new content

#### 3.3 Add Content Forms
- **Add Lesson**: Type selector (Video/PDF), title, description, URL
- **Add Exercise**: Title, instructions, dynamic question list (text + points), add question button
- **Add Quiz**: Title, time limit, QCM questions (4 options + correct answer selector via radio dots)
- **Add Exam**: Title, year, description, PDF URL

#### 3.4 Teacher Students
- **Class filter chips**: Terminale C, Terminale D, Premiere C, Seconde C
- **Subject filter**: Optional subject filter
- **Student list**: Sorted by average, each row = initials avatar, name, class, avg with color, completion ratio
- **Tap →** Student dashboard

#### 3.5 Teacher Student Dashboard
- **Header**: Student initials, name, class, status (En difficulté/Bon/Excellent)
- **Stats**: 3 cards (Moyenne, Exercices complétés, Quiz réussis)
- **AI Recommendations**: Color-coded cards by urgency (red/orange/green) with action buttons
- **Scores chart**: Bar chart of recent scores
- **Recent activity**: Timeline of submissions
- **Global statistics**: Section summary

#### 3.6 Teacher Profile
- Similar to student but with class analytics and performance overview

### 4. Shared Screens

#### 4.1 TutorBot (AI Chat)
- **Header**: Gradient bar with AI avatar + "TutorBot" title
- **Subject chips**: Math, SVT, Physique, Histoire, Français, Anglais (horizontal scroll)
- **Chat area**: User bubbles (right, accent color), AI bubbles (left, white with shadow)
- **Loading**: Animated dots bubble
- **Empty state**: Welcome message + suggested questions
- **Input bar**: Text field + mic button + send button (gradient)

#### 4.2 Copy Corrector (Photo Correction)
- **Camera view**: Full-screen camera preview, subject dropdown at top
- **Tips panel**: Slide-up with tips for good photo
- **Result view**: Score with animated ring, grade (A-F), corrections list, praises, AI feedback
- **Actions**: Retake, share, save

#### 4.3 Settings
- Tiles: Langue, Mode hors-ligne, Notifications, Mode sombre, Sauvegarde auto, Taille police (slider)
- Storage info, About section

## Key UX Patterns
- **Empty states**: Illustration + title + subtitle + optional action button
- **Loading states**: Shimmer skeleton loaders
- **Error states**: Message + retry button
- **Staggered entrance**: Items fade in sequentially on page load
- **Pull to refresh**: On all data screens
- **Snackbar**: For success/error feedback

## Tech Notes for Design
- App uses Riverpod for state management
- API data loads asynchronously → skeleton loaders required
- Offline-first: cache data when available
- Bottom nav must support 5 items (student) and 4 items (teacher)
- Icons should be Material Design outlined style
- Subject colors must be consistent across all screens
